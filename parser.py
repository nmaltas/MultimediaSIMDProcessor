# -*- coding: utf-8 -*-
"""
Created on Fri Apr 27 19:40:20 2018

@author: nolan
"""
def binary(temp):
    first=temp[0]
    total=""
    flag=1
    #print(first)
    if first == "a":
        total = "00011000000"
    elif first == "addx":
        total = "01101000000"
    elif first == "bg":
        total = "00001000010"
    elif first == "bgx":
        total = "01101000011"
    elif first == "and":
        total = "00011000001"
    elif first == "ceq":
        total = "01111000000"
    elif first == "cg":
        total = "00011000010"
    elif first == "cgt":
        total = "01001000000"
    elif first == "cgx":
        total = "01101000010"
    elif first == "or":
        total = "00001000001"
    elif first == "sf":
        total = "00001000000"
    elif first == "sfx":
        total = "01101000001"
    elif first == "xor":
        total = "01001000001"
    elif first == "mpy":
        total = "01111000100"
    elif first == "mpyhh":
        total = "01111000110"
    elif first == "rot":
        total = "00001011000"
    elif first == "shl":
        total = "00001011011"
    elif first == "clz":
        total = "01010100101"
    elif first == "fa":
        total = "01011000100"
    elif first == "fceq":
        total = "01111000010"
    elif first == "fcgt":
        total = "01011000010"
    elif first == "fm":
        total = "01011000110"
    elif first == "fs":
        total = "01011000101"
    elif first == "cgtb":
        total = "01001010000"
    elif first == "cntb":
        total = "01010110100"
    elif first == "sumb":
        total = "01001010011"
    elif first == "shlqbi":
        total = "00111011011"
    elif first == "rotqbi":
        total = "00111011000"
    elif first == "lqx":
        total = "00111000100"
    elif first == "stqx":
        total = "00101000100"
    elif first == "ai":
        total = "00011100"
        flag = "i10"
    elif first == "andi":
        total = "00010100"
        flag = "i10"
    elif first == "ceqi":
        total = "01111100"
        flag = "i10"
    elif first == "cgti":
        total = "01001100"
        flag = "i10"
    elif first == "ori":
        total = "00000100"
        flag = "i10"
    elif first == "xori":
        total = "01000100"
        flag = "i10"
    elif first == "mpyi":
        total = "01110100"
        flag = "i10"
    elif first == "sfi":
        total = "00001100"
        flag = "i10"
    elif first == "roti":
        total = "00001111000"
        flag = "i7"
    elif first == "shli":
        total = "00001111011"
        flag = "i7"
    elif first == "andbi":
        total = "00010110"
        flag = "i10"
    elif first == "ceqbi":
        total = "01111110"
        flag = "i10"
    elif first == "cgtbi":
        total = "01001110"
        flag = "i10"
    elif first == "orbi":
        total = "00000110"
        flag = "i10"
    elif first == "xorbi":
        total = "01000110"
        flag = "i10"
    elif first == "rotqbii":
        total = "00111111000"
        flag = "i7"
    elif first == "shlqbii":
        total = "00111111011"
        flag = "i7"
    elif first == "il":
        total = "010000001"
        flag = "i16"
    elif first == "ila":
        total = "0100001"
        flag = "i18"
    elif first == "lqa":
        total = "001100001"
        flag = "i16"
    elif first == "lqd":
        total = "00110100"
        excep=temp[2]
        excep=excep.replace("("," ")
        excep=excep.replace(")","")
        excep=excep.split(" ")
        new=[]
        new.append(temp[0])
        new.append(temp[1])
        new.append(excep[1])
        new.append(excep[0])
        temp=new
        flag = "i10"
    elif first == "stqa":
        total = "001000001"
        flag = "i16"
    elif first == "stqd":
        total = "00100100"
        excep=temp[2]
        excep=excep.replace("("," ")
        excep=excep.replace(")","")
        excep=excep.split(" ")
        new=[]
        new.append(temp[0])
        new.append(temp[1])
        new.append(excep[1])
        new.append(excep[0])
        temp=new
        flag = "i10"
    elif first == "lnop":
        total = "00000000001"
        temp.append("dk21")
        flag="dk21"
    elif first == "nop":
        total = "01000000001"
        temp.append("dk21")
        flag = "dk21"
    elif first == "stop":
        total = "00000000000"
	temp.append("dk21")
        flag = "dk21"
    elif first=="bi":
        total="00110101000"
        new=[]
        new.append(temp[0])
        new.append("0")
        new.append(temp[1])
        new.append("0")
        temp=new
    elif first=="biz":
        total="00100101000"
        temp.append("0")
    elif first=="br":
        total="001100100"
        flag="i16"
        new=[]
        new.append(temp[0])
        new.append("dk7")
        new.append(temp[1])
        temp=new
    elif first=="bra":
        total="001100000"
        flag="i16"
        new=[]
        new.append(temp[0])
        new.append("dk7")
        new.append(temp[1])
        temp=new
    elif first=="brnz":
        total="001000010"
        flag = "i16"
    elif first=="brz":
        total="001000000"
        flag = "i16"
    elif first=="binz":
        total="00100101001"
    elif first=="brasl":
        total="001100010"
        flag = "i16"
    elif first=="brsl":
        total="001100110"
        flag = "i16"
    elif first=="imiss":
        total="00011111111"
        new=[]
        new.append(temp[0])
        new.append("dk11")
        new.append(temp[1])
        temp=new
        flag="i10"
    elif first=="fma":
        total="1110"
        new=[]
        new.append(temp[0])
        new.append(temp[4])
        new.append(temp[2])
        new.append(temp[3])
        new.append(temp[1])
        temp=new
    elif first=="fms":
        total="1111"
        new=[]
        new.append(temp[0])
        new.append(temp[4])
        new.append(temp[2])
        new.append(temp[3])
        new.append(temp[1])
        temp=new
    else:
        pass
    temp=temp[1:]
    temp=temp[::-1]
    if flag==1:
        for i in temp:
            if i[0]=='r':
                i=i[1:]
            i=int(i)
            i='{0:07b}'.format(i)
            total=total+str(i)
    elif flag=="dk21":
        for i in temp:
            i=0
            i='{0:021b}'.format(i)
            total=total+str(i)
    elif flag=="i10":
        for i in temp:
            if i[0]=='r':
                i=i[1:]
                i=int(i)
                i='{0:07b}'.format(i)
                total=total+str(i)
            elif i=='dk11':
                i = 0
                i = '{0:011b}'.format(i)
                total = total + str(i)
            else:
                i = int(i)
                i = '{0:010b}'.format(i)
                total = total + str(i)
    elif flag=="i7":
        for i in temp:
            if i[0]=='r':
                i=i[1:]
            i=int(i)
            i='{0:07b}'.format(i)
            total=total+str(i)
    elif flag=="i18":
        for i in temp:
            if i[0]=='r':
                i=i[1:]
                i=int(i)
                i='{0:07b}'.format(i)
                total=total+str(i)
            else:
                i = int(i)
                i = '{0:018b}'.format(i)
                total = total + str(i)
    elif flag=="i16":
        for i in temp:
            if i[0]=='r':
                i=i[1:]
                i=int(i)
                i='{0:07b}'.format(i)
                total=total+str(i)
            elif i=='dk7':
                i = 0
                i = '{0:07b}'.format(i)
                total = total + str(i)
            else:
                i = int(i)
                i = '{0:016b}'.format(i)
                total = total + str(i)
    return total

def main():
    part1=[]
    part2=[]
    middle=[]
    with open("Calliop2.sv","r") as o:
        with open("opcode.txt","r") as f:
            opcodes=[]
            for line in f:
                line=line.replace(","," ")
                temp=line.strip()
                temp=temp.split(" ")
                ans=binary(temp)
                opcodes.append(ans)
            count=0
            data=o.readlines()
            part1=data[:143]
            part2=data[143:]
            count=0
            for value in opcodes:
                write = "InstructionMemory[" +str(count)+ "] = 32'b" + value +";"+"\n"
                middle.append(write)
                count=count+1
    o.close()
    f.close()
    with open("Calliop2.sv", "w") as x:
        newdata=part1+middle+part2
        x.writelines(newdata)

main()

