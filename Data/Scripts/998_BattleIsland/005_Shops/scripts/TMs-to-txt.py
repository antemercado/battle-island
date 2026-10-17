import csv

tm_file = f"TMs.csv"
lines = []

with open(tm_file, 'r', encoding='utf-8') as fr:
    reader = csv.reader(fr)
    for l in reader:
        lines.append(l)

with open("../../../../../PBS/items_tms.txt", "w", encoding="utf-8") as output:
    i = 0
    for l in lines:
        output.write("#-------------------------------" + "\n")
        output.write(l[0] + "\n")
        output.write("Name = TM" + f"{i:03d}" + "\n")
        output.write("NamePlural = TM" + f"{i:03d}""s\n")
        output.write("Pocket = 4" + "\n")
        output.write("Price = 3000" + "\n")
        output.write("BPPrice = 80" + "\n")
        output.write("FieldUse = TR" + "\n")
        output.write("Flags = " + l[3] + "\n")
        output.write("Move = " + l[2] + "\n")
        if l[5] == '':
            descr = "TBD"
        else:
            descr = l[5]
        output.write("Description = " + descr + "\n")
        i += 1

with open("TM_types.txt", "w", encoding="utf-8") as output:
    type_dict = {}
    for l in lines:
        type_dict.setdefault(l[4], []).append(":" + l[0][1:-1])
    for key, value in type_dict.items():
        output.write(key + " => [")
        output.write(", ".join(value) + "],\n")