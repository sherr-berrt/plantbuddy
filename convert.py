import csv

f = open("tmp.txt","r")



outFile = open("out.csv","w+")

out=csv.writer(outFile)

row = []
out.writerow(["Time","Light","Temperature","Humidity","Pressure"])
for line in f:
    
    separated = line.split(" -> ")

    print("separated is : " + str(separated))
    if separated[1] == "=newline=\n":
        if row != []:
            print("writing: " + str(row) + " ...")
            out.writerow(row)
        row = []
    else:
        
        #print(separated[0])
        #print(separated[1])

    
        attribute = separated[1].split(":")
        
        if attribute[0] == "light":
            row.append(separated[0])
        #print(attribute)

        row.append(attribute[1])
        
        #print(row)

f.close()
