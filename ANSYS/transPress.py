#import numpy as np
finp = open('press.txt','r')
fout = open('press.dat','w')

text = finp.readlines()
sumLine = len(text)
print(sumLine)
n = 0
while 1:
    n = n+1
    if n>sumLine:
        break
    if text[n][0:8]==' ELEMENT':
        print(n)
        for m in range(0,10):
            i = n+2*m+1
            if i>sumLine-1:
                break
            #print(i)
            line = text[i]
            line = line.strip('\n').split()
            elem = int(line[0])
            face = int(line[1])
            pres = float(line[3])
            fout.write('%8d%8d%20.4f\n'%(elem,face,pres))
        n = i
            
        

finp.close()
fout.close()