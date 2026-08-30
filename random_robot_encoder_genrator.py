import numpy as np
def generate_random_robot():
    lrob=[{} for i in range(1000)]
    # [{robo11:{section:,line_name:,lengths:[],mass:[],exy_tot:[],eyz_tot:[],exy_start:,eyz_tot:[]}}]
    # generate 5 different lines 2 old 2 automatedish 1 full new

    '''
the 2 old will have lesser robots
the 2 semi will have more sensors and robots
the last line will be almost autonomous with less human activity
so check for robot sensors 
'''
    for i in range(5):
        for b in range(20):
            lrob[][
        

    # mechanism for generation for 1 robot
    assuming 3 arms.
    D={'section':'welding','line':3}

    tensor1=[] # array of number of arms
    tensor=np.vstack((np.where(tensor1!=0,tensor1,np.nan)/np.where(tensor1!=0,tensor1,np.nan),np.where(tensor1-1>0,tensor1-1,np.nan)/np.where(tensor1-1>0,tensor1-1,np.nan),np.where(tensor1-2>0,tensor1-2,np.nan)/np.where(tensor1-2>0,tensor1-2,np.nan),np.where(tensor1-3>0,tensor1-3,np.nan)/np.where(tensor1-3>0,tensor1-3,np.nan)))
    tensor=tensor.T
    length=np.vstack((1+3*np.random.randn(1000,),1+np.random.randn(1000,),0.5+np.random.randn(1000,),0.5+0.5*np.random.randn(1000,)))
    length=length.T
    D['lengths']=tensor*length
    massvec=np.hstack((15+20*np.random.randn(1000,),10+10*np.random.randn(1000,),5+10*np.random.randn(1000,),3+2*np.random.randn(1000,)))
    D['mass']=massvec*tensor
    exy=[]# array for whichever robotic arms have xy axis rotation
    eyz=[] # array for whcihever have yz rotation
    exy=exy*np.ones((exy.size,4))
    eyz=eyz*np.ones((eyz.size,4))
    D['exy_tot']=exy*np.random.randint(30,180,400).resize((100,4))
    D['eyz_tot']=eyz*np.random.randint(180,360,400).resize((100,4))
    D['exy_start']=exy*np.random.randint(0,90,400).resize((100,4))
    D['eyz_start']=eyz*np.random.randint(0,360,400).resize((100,4))
    
def generate_curves():
    
    
