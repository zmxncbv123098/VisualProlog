with open("selection.txt", "r") as f:
    for i in f.readlines():
        if len(i)==1:
            pass
        else:
            print(i.replace("\n","").replace("-","_"))