# plantbuddy
App to monitor and advise about plant growth


## Gather data from Arduino

1. Download Arduino
2. Download `helloworld.ino`
3. Download `convert.py`
4. Open Arduino and open `helloworld.ino`
5. Press Upload, and then ctrl-shift-m to open Serial console
6. Let it run!
7. Once done, copy and paste the output into a txtfile called "tmp.txt"
8. run `convert.py` , make sure it's in the same directory
9. `out.csv` should be produced


## Get data about plant care

1. Run `temp_calc.m` in Matlab
2. This program will take a little bit to run
3. Produces two files - `conditions.csv` and `plant_temp_ranges.csv` in `outputs` directory


## Run messaging system

1. Open `Monitor_loop.ipynb` in Jupyter Notebook
2. On the dashboard of `twilio.com`, look for `Auth token`
3. Copy the `Auth token` into the `Twilio` cell in `Monitor_loop.ipynb`
4. Run the cells of `Monitor_loop.ipynb`