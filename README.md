# HIT-Blockchain-Election-Final-Project

Developed by:  
- Lior Bergman-Haboosha
- Ilay Simon

## Installation

### Depenedencies:

- Download and install node from:  
[https://nodejs.org/en/](https://nodejs.org/en/)

- Download and install truffle using npm, run:  
```bash
npm install -g truffle
```

- Download and install Ganache from:  
[https://trufflesuite.com/ganache/](https://trufflesuite.com/ganache/)

- Download and install MetaMask extension from:  
[https://metamask.io/](https://metamask.io/)  

### Deployment:

- make directory named Election

- Download the code from the following GitHub repo as a ZIP file:  
<<<<<<< HEAD
[https://github.com/L1326/HIT-Blockchain-Election-Final-Project/tree/dev](https://github.com/L1326/HIT-Blockchain-Election-Final-Project/tree/dev)  
=======
[https://github.com/L1326/HIT-Blockchain-Election-Final-Project](https://github.com/L1326/HIT-Blockchain-Election-Final-Project)  
>>>>>>> d3c98186ac35765174ba81c5cbb1f03ca421fad4

If you already have the ZIP file of the code:  

- Extract the ZIP file into your Election directory

- Inside your Election directory run:  
```bash
npm install
```

- Run Ganache (make sure the RPC server in ganache is [http://127.0.0.1:7545](http://127.0.0.1:7545) )

### Execution:

- Open your Election folder in your IDE (VSCode is Recommanded)

- In terminal run:    
```bash
on Windows:  
truffle migrate --reset

On Mac:
sudo truffle migrate --reset
```

- In a new terminal run:  
```bash
npm run dev
```


- In your favorite browser, browse to:  
[http://127.0.0.1:3000](http://127.0.0.1:3000)

### MetaMask:
- Open MetaMask
- Connect to local network: [http://localhost:7545](http://localhost:7545)
- In MetaMask, import 2 accounts from Ganache (not the first account)  
 
