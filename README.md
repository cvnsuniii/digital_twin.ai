Digital twin of vehicle assembly systems 

The project aims to builda live digital frontend to various levels of workers in a vehicle assembly system such as the planning department, 
supply chain managers, factory mangagers and at the root factory screens 

 Features
- Embedding with the existing SCADA systems and new factories with micropython connections with sensors and robots
- Uses PINNs to map out various issues which can occur 
- provides a Flutter frontend giving various data and suggestions to the apex members along with a dashboard showing various bottlenecks and defects of assembly
- creates a diffferent class for each car with its data which can be easily traceable
- The model connects easily with supply chain as well as market demand to make better descitions( connection part not done yet)




##  Usage and Working
The entire prototype has not been fully assembled and is in the Jupyter notebook file "data_gen.ipynp" as separate classes as defined below. The classes will be moved 
to models folder

The supplychain2 class is used to simulate as well as generate supply chain dynamics training data 

The marketsim2 class is used to generate and simulate the demand as well as exporter visit dates and number of cars taken by each exporter which hence maps market dynamics

The factory class will consist of robots along with a connection to SCADA as well as micropython systems for different factories 
The robot class will be a sub class for this which will map out and simulate robot synamics such as DOF's , vibrations and deformations. It generates and simulates
random paths for training data 

There is a car_model class which defines the car parameters such as dimensions, FEA snalysis ,etc. It should be able to generate the required data as given in an example
with the arc_weld class. This cell would also feature a PINN class which gets the data from factory class via sensors updates it into the car class which then has 
has to be processed through this PINN module based on arc welding dynamics such as changing orientation, uneven current supply ,etc caused due to various factors like 
misalighment of car body, encoder failure in robot, high wear in robot , aging wire systems,etc. The arc_weld class generates training data as well as simulates data
for testing.

This is an example for 1 process out of the many processes which occur in assembly line. Similar PINN modules can be made for each of them and needs to be added 
accordingly. 

The frontend of this is a flutter application which is planned to be connected to the factory class with a backend hosted locally. the flutter features a login home
page for different types of work such as planners, plant operations managers and monitors within the factory which shall be authenticated using credentials stored on firebase.

The frontend features an interactive framework which will give data of each model, each car , each factory and lines showing bottlenecks and issues classified. It is
also planned on having a module which will help take actions such as planning supply chain , planning expansions and new factories,etc which has to be incorporated
using the RNN models which are planned to be added.
