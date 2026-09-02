
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.stats import skewnorm
from scipy.stats import t
import calendar

from datetime import datetime

import torch
import torch.nn as nn
import torch.optim as optim
def f2(a):
    # Check if the element is NaN or None
    if pd.isna(a):
        return np.nan
    return int(str(a).split('-')[2])

vf2 = np.vectorize(f2, otypes=[object])

def f3(a, b):
    if pd.isna(a):
        return np.nan
    if a <= 0:
        a = 1
    elif a > calendar.monthrange(2026, int(b))[1]:
        a = calendar.monthrange(2026, int(b))[1]
    return a 

vf3 = np.vectorize(f3, otypes=[object])

class marketsim2:
    def __init__(self):
        # 1. Array of randomized demand across 12 months for the car company
        self.total_demands = np.random.randint(15000, 30000, size=(12,))
        self.monthly_demands = np.zeros((12, 20), dtype=int)
        for a in range(12):
            cuts_models = np.sort(np.random.choice(np.arange(1, self.total_demands[a]), size=20 - 1, replace=False))
            self.monthly_demands[a] = np.diff(np.concatenate(([0], cuts_models, [self.total_demands[a]])))
        
        self.num_visits_export = np.random.randint(1, 3, size=(12, 10, 20))
        
        # 2. Generate Random Visit Dates (4D array: 12 months, 10 exporters, 20 models, 2 visits)
        visit_dates = np.full((12, 10, 20, 2), np.nan, dtype=object)

        for month in range(12):
            month_str = f"2026-{month+1:02d}"
            days_in_month = pd.Period(month_str).days_in_month
            
            for exp in range(10):
                for mod in range(20):
                    visits = self.num_visits_export[month, exp, mod]
                    picked_days = np.sort(np.random.choice(np.arange(1, days_in_month + 1), size=visits, replace=False))
                    
                    visit_dates[month, exp, mod, 0] = f"2026-{month+1:02d}-{picked_days[0]:02d}"
                    
                    # If exporter visits TWICE, set second date; if ONCE, second date remains NaN
                    if visits == 2:
                        visit_dates[month, exp, mod, 1] = f"2026-{month+1:02d}-{picked_days[1]:02d}"

        self.visit_dates = visit_dates

        # 3. Allocate Cars Taken per Visit based on each month's dynamic demand
        self.cars_taken = np.full((12, 10, 20, 2), np.nan)

        for mod in range(20):
            for month in range(12):
                current_month_demand = self.monthly_demands[month, mod]
                active_visits_mask = ~pd.isna(self.visit_dates[month, :, mod, :])
                total_visits_this_month = np.sum(active_visits_mask)
                
                if total_visits_this_month > 0 and current_month_demand > 0:
                    if total_visits_this_month > 1:
                        v_cuts = np.sort(np.random.choice(np.arange(1, max(current_month_demand, total_visits_this_month)), 
                                                          size=total_visits_this_month - 1, replace=False))
                        visit_allocations = np.diff(np.concatenate(([0], v_cuts, [current_month_demand])))
                    else:
                        visit_allocations = np.array([current_month_demand])
                        
                    self.cars_taken[month, :, mod, :][active_visits_mask] = visit_allocations

        self.cars_taken[pd.isna(self.visit_dates)] = np.nan

    def gen_training_data(self, nsamples=1000):
        # 1. Generate random base dates for each sample (nsamples,)
        random_days = np.random.randint(0, 365, size=nsamples)
        self.dates = pd.to_datetime('2026-01-01') + pd.to_timedelta(random_days, unit='D')
        self.month_no = self.dates.month.values  # 1-indexed month numbers (1 to 12)

        # 2. Sample noise matrices with shape (nsamples, 10 exporters, 20 models, 2 visits)
        self.noise_matrix_cars = t.rvs(df=5, loc=1, scale=0.1, size=(nsamples, 10, 20, 2))
        self.noise_visit = np.round(np.random.uniform(-2, 2, size=(nsamples, 10, 20, 2)), 0)

        # 3. Extract base dates and cars for active month (nsamples, 10, 20, 2)
        month_idx = self.month_no - 1  # 0-indexed for self.cars_taken / self.visit_dates
        base_dates_sample = self.visit_dates[month_idx]  # Shape: (nsamples, 10, 20, 2)
        base_cars_sample = self.cars_taken[month_idx]    # Shape: (nsamples, 10, 20, 2)

        # Extract day component and apply noise
        extracted_days = vf2(base_dates_sample)
        month_expanded = np.repeat(self.month_no[:, None, None, None], 10*20*2, axis=1).reshape(nsamples, 10, 20, 2)
        
        # Calculate shifted days clamped to valid month ranges
        visit_days = vf3(extracted_days + self.noise_visit, month_expanded)
        cars_taken = np.round(base_cars_sample * self.noise_matrix_cars, 0)
        
        # Preserve NaNs for invalid second visits
        nan_mask = pd.isna(base_dates_sample)
        visit_days[nan_mask] = np.nan
        cars_taken[nan_mask] = np.nan

        # Extract total number of scheduled visits for the selected month (nsamples, 10, 20)
        scheduled_visits = self.num_visits_export[month_idx]

        # 4. Meshgrid / Broadcast dimensions for 3D layout (nsamples, 10 exporters, 20 models)
        exp_idx, mod_idx = np.meshgrid(np.arange(10), np.arange(20), indexing='ij')
        
        exp_matrix = np.broadcast_to(exp_idx, (nsamples, 10, 20))
        mod_matrix = np.broadcast_to(mod_idx, (nsamples, 10, 20))
        date_matrix = np.repeat(self.dates.values[:, None, None], 10*20, axis=1).reshape(nsamples, 10, 20)
        month_3d = np.repeat(self.month_no[:, None, None], 10*20, axis=1).reshape(nsamples, 10, 20)

        # 5. Build Flat Dictionary separating Visit 1 and Visit 2 columns
        df_data = {
            "Date": date_matrix.ravel(),
            "Month_Number": month_3d.ravel(),
            "Exporter_Number": exp_matrix.ravel(),
            "Car_Model_Number": mod_matrix.ravel(),
            "Number_of_Visits": scheduled_visits.ravel(),
            "Days_Visited_1": visit_days[:, :, :, 0].ravel(),
            "Days_Visited_2": visit_days[:, :, :, 1].ravel(),
            "Cars_Taken_1": cars_taken[:, :, :, 0].ravel(),
            "Cars_Taken_2": cars_taken[:, :, :, 1].ravel()
        }

        df = pd.DataFrame(df_data)
        
        # 6. Save directly to CSV
        df.to_csv('market_training_data.csv', index=False)
        return df
    def simulate(self, date=datetime.datetime.now()):
            self.month_no = int(str(date).split('-')[1])
            noise_visit = np.round(np.random.uniform(-2, 2, size=(10, 20, 2)), 0)
            cars_take = np.round(self.cars_taken[self.month_no - 1] * t.rvs(df=5, loc=1, scale=0.1, size=(10, 20, 2)), 0)
            visit_days = vf3(vf2(self.visit_dates[self.month_no - 1]) + noise_visit, self.month_no)
            return {'cars_taken': cars_take, 'visiting days': visit_days}