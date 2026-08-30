class plant1:
    def __init__(self,plantname):
        self.plant=plantname
        # below are the list of sensors used for testing and other data 
        '''
        dictionary format 
        key= line number or name 
        
        '''
        self.stamping={}
        self.welding=[]
        self.painting=[]
        self.ga=[]
        self.inspection=[]