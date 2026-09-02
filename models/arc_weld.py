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
'''
this class can be a subclass of design of car

design defect
jerks due to robot wear causes undercuts
if there is camera in the line analyze if there is growing distance between 2 sheets being weld. if there is a high difference enough to cause burnthrough or undercuts stop

when weld tolerance fails easily identify using ai instead of waiting for 3 more failures and remove hospital bay
'''
class arc_weld_design:
    def __init__(self,idd):
        # weld id 
        self.weldid=idd
        # filler material yield strength 
        self.material=material
        # thickness of sheets to weld
        self.thickness=thickness
        # length of weld
        self.length=lemgth
        # length of filler
        self.filler=filler
        # current required
        self.current=current
        # robot paths for all 4 lines in factory
        self.robot_paths=robot_path
        # maximum force to be taken also make an another dictionary for normal operating force and cycles to operate
        self.forces={'tensile':0.7*self.thickness*self.length*self.material,'shear':.7*self.thickness*self.length*self.material/(3)**0.5,'bending':self.material*0.7*self.thickness*self.length**2/6,'torsion':self.material*0.7*self.thickness*self.length**2/6/3**0.5,'impact':impact}
        # the below will differer based on car model
        self.operating_forces={'tensile':tensile,'shear':shear,'bending':bending,'torsion':torsion,'impact':impact}
        self.cyclesofops=cycles
        # these all stuff should be read from file and automatically updated here 
    def gen_training_data(self,nsamples=100000):
        # array of distorsion defect
        distort=np.random.choice([0,1],nsamples,p=[1-0.001,0.001])


        def gen_encoder_mal(nsamples=1000):
            # generates for 1000 encoder measuring distance malfunction

            # lets model actual current and voltage decreses later 
            lengths=np.int16(skewnorm.rvs(a=5,loc=30,scale=35,size=nsamples))
            # represents the currents required for some 3 types of sheet metals
            currents=np.random.choice([70,90,110],size=nsamples)
            # represent weld speed in mm/s
            speed=(currents==70)*np.full(nsamples,fill_value=3.5)+(currents==90)*np.full(nsamples,fill_value=5)+(currents==110)*np.full(nsamples,full_value=7)
            # represent weld time
            times=lengths/speed
            # sample rate of current and voltages is usally 80 Khz or 100Khz but im taking 40 & 50Khz for data purposes
            samplerates=np.random.choice([40000,50000],size=nsamples)
            # arc lengths
            arcl=(currents==70)*np.full(nsamples,fill_value=2)+(currents==90)*np.full(nsamples,fill_value=3.2)+(currents==110)*np.full(nsamples,full_value=5)

            #  problem start event 
            



    
    def simulate(self):
        

    def weld_analysis(self,weld_params):
        # put the pinn model to analyze weld goodness 
        # this model part should also update in scada system
        