 # please note that training data was generated considering monthly variations and not based on the day and year
# so when doing the model extract the month in datetime and do 
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
class SupplyChain2:
    def __init__(self):
        # 12 months, 50 parts, 100 factories
        self.demand = np.random.uniform(10000, 100000, size=(12, 50, 100))
        self.prod_time = np.random.uniform(0.1, 0.5, size=(50, 100))
        self.costinit = np.random.randint(1000, 10000, size=(50,))
        self.demandfactor = 1 + 0.005 * np.random.randn(50, 1)

        self.deliverytime_factor = np.random.uniform(1, 5, size=(50, 1))
        self.deliverytime_init = 48 + 5 *24* skewnorm.rvs(5.0, loc=1, scale=1, size=(50, 100))
        self.deliverycost_init = np.random.uniform(100, 1000, size=(50, 100))

    def generate_training(self, nsamples=100):
        # Generate random dates and extract zero-indexed month numbers
        random_days = np.random.randint(0, 365, size=nsamples)
        self.dates = pd.to_datetime('2026-01-01') + pd.to_timedelta(random_days, unit='D')
        month_num = self.dates.month - 1  # (nsamples,)

        self.noise_matrix = np.random.uniform(0.95, 1.05, size=(nsamples, 50, 100))

        # cahnge here if there is a warehouse- this is number of orders per day
        self.order_numbers = np.random.randint(200, 500, size=(nsamples,50,100))

        demand_part_mean = np.mean(np.transpose(self.demand, (1, 0, 2)), axis=(1, 2), keepdims=True).squeeze(-1)
        sample_demand = self.demand[month_num]

        exponent = (sample_demand * self.noise_matrix) - np.expand_dims(demand_part_mean, axis=0)
        self.cost = np.expand_dims(self.costinit, axis=(0, 2)) * (np.expand_dims(self.demandfactor, axis=0) ** exponent)

        self.deliverycost = self.deliverycost_init * self.deliverytime_init / self.deliverytime_factor/24
        self.totalcost = self.cost + np.expand_dims(self.deliverycost, axis=0)

        self.lead_time = sample_demand * np.expand_dims(self.prod_time, axis=0) + self.order_numbers * np.expand_dims(self.prod_time, axis=0)

        self.deliverytime = self.deliverytime_factor * self.deliverytime_init
        self.deliverytime = self.noise_matrix * np.expand_dims(self.deliverytime, axis=0)
        self.total_time = self.lead_time + self.deliverytime

        # --- Create Index Grids for Parts (0-49) and Factories (0-99) ---
        part_idx, factory_idx = np.meshgrid(np.arange(50), np.arange(100), indexing='ij')
        
        # Broadcast indices across nsamples: Shape becomes (nsamples, 50, 100)
        part_matrix = np.broadcast_to(part_idx, (nsamples, 50, 100))
        factory_matrix = np.broadcast_to(factory_idx, (nsamples, 50, 100))
        dates_matrix = np.repeat(self.dates.values[:, None, None], 50*100, axis=1).reshape(nsamples, 50, 100)
        #orders_matrix = np.repeat(self.order_numbers[:, None, None], 50*100, axis=1).reshape(nsamples, 50, 100)
        delivery_cost_matrix = np.broadcast_to(self.deliverycost, (nsamples, 50, 100))

        # Flatten all arrays into 1D for tabular output
        df_data = {
            "Date": dates_matrix.ravel(),
            "Part_Number": part_matrix.ravel(),
            "Factory_Number": factory_matrix.ravel(),
            "Number_of_orders": self.order_numbers.ravel(),
            "Delivery_Cost": delivery_cost_matrix.ravel(),
            "Initial_COST": self.cost.ravel(),
            "Total Cost": self.totalcost.ravel(),
            "Lead_Time": self.lead_time.ravel(),
            "Delivery_Time": self.deliverytime.ravel(),
            "Total_Time": self.total_time.ravel(),
        }

        df = pd.DataFrame(df_data)
        df.set_index("Date", inplace=True)
        df.to_csv('training_full.csv')
        #return df

    def simulate(self, target_date=None):
        """
        Simulates supply chain metrics for a single date.
        If no date is provided, a random date in 2026 is generated.
        """
        # 1. Generate or parse the target date
        if target_date is None:
            random_day = np.random.randint(0, 365)
            date = pd.to_datetime('2026-01-01') + pd.to_timedelta(random_day, unit='D')
        else:
            date = pd.to_datetime(target_date)

        # Extract zero-indexed month number (0 to 11)
        month_num = date.month - 1

        # 2. Sample single-instance parameters and noise matrix for shape (50, 100)
        noise_matrix = np.random.uniform(0.95, 1.05, size=(50, 100))
        order_numbers = np.random.randint(100, 300,size=(50,100))

        # Extract demand for the target month -> Shape: (50, 100)
        sample_demand = self.demand[month_num]

        # Calculate mean across Months (axis 0) and Factories (axis 2) -> Output shape: (50, 1)
        demand_part_mean = np.mean(np.transpose(self.demand, (1, 0, 2)), axis=(1, 2), keepdims=True).squeeze(-1)

        # 3. Compute Initial Cost with noise applied
        exponent = (sample_demand * noise_matrix) - demand_part_mean
        cost = np.expand_dims(self.costinit, axis=1) * (self.demandfactor ** exponent)  # Shape: (50, 100)

        # 4. Compute Delivery Cost & Total Cost
        deliverycost = self.deliverycost_init * self.deliverytime_init / self.deliverytime_factor /24 # Shape: (50, 100)
        totalcost = cost + deliverycost  # Shape: (50, 100)

        # 5. Compute Lead Time, Delivery Time (with noise), and Total Time
        lead_time = sample_demand * self.prod_time + order_numbers * self.prod_time  # Shape: (50, 100)
        deliverytime = self.deliverytime_factor * self.deliverytime_init  # Base shape: (50, 100)
        deliverytime = noise_matrix * deliverytime  # Applied noise -> Shape: (50, 100)
        total_time = lead_time + deliverytime  # Shape: (50, 100)

        # 6. Return values packaged in a dictionary
        return {
            "Date": date.strftime('%Y-%m-%d'),
            "Month_Index": month_num,
            "Order_Numbers": order_numbers,
            "Noise_Matrix": noise_matrix,
            "Initial_Cost": cost,
            "Delivery_Cost": deliverycost,
            "Total_Cost": totalcost,
            "Lead_Time": lead_time,
            "Delivery_Time": deliverytime,
            "Total_Time": total_time
        }
