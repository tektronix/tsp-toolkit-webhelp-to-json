-- delay()
beeper.beep(0.5, 2400)
delay(0.250)
beeper.beep(0.5, 2400)

dataqueue.clear()
dataqueue.add(35)
timer.cleartime()
delay(0.5)
dt = timer.gettime()
print("Delay time was " .. dt)
print(dataqueue.next())

-- waitcomplete()
waitcomplete()

waitcomplete(G)

waitcomplete(0)

-- userstring.add()
userstring.add("assetnumber", "236")
userstring.add("product", "Widgets")
userstring.add("contact", "John Doe")
for name in userstring.catalog() do
print(name .. " = " ..
userstring.get(name))
end

-- userstring.catalog()
for name in userstring.catalog() do
userstring.delete(name)
end

userstring.add("assetnumber", "236")
userstring.add("product", "Widgets")
userstring.add("contact", "John Doe")
for name in userstring.catalog() do
print(name .. " = " ..
userstring.get(name))
end

-- userstring.delete()
userstring.delete("assetnumber")
userstring.delete("product")
userstring.delete("contact")

-- userstring.get()
userstring.add("assetnumber", "236")
value = userstring.get("assetnumber")
print(value)

-- upgrade.previous()
-- upgrade.unit()
-- tspnet.clear()

testdevice = tspnet.connect("")

tspnet.write(testdevice, "print([[hello]])")
print(tspnet.readavailable(testdevice))



tspnet.clear(testdevice)
print(tspnet.readavailable(testdevice))

-- tspnet.connect()
instrumentID = tspnet.connect("192.0.2.1")
if instrumentID then
-- Use instrumentID as needed here
tspnet.disconnect(instrumentID)
end

instrumentID = tspnet.connect("192.0.2.1", 1394, "*rst\r\n")
if instrumentID then
-- Use instrumentID as needed here
tspnet.disconnect(instrumentID)
end

-- tspnet.disconnect()
testID = tspnet.connect("192.0.2.0")
-- Use the connection
tspnet.disconnect(testID)

-- tspnet.execute()
tspnet.execute(instrumentID, "runScript()")

tspnet.timeout = 5
id_instr = tspnet.connect("192.0.2.23", 23, "*rst\r\n")
tspnet.termination(id_instr, tspnet.TERM_CRLF)
tspnet.execute(id_instr, "*idn?")
print("tspnet.execute returns:", tspnet.read(id_instr))

-- tspnet.idn()
deviceID = tspnet.connect("192.0.2.1")
print(tspnet.idn(deviceID))
tspnet.disconnect(deviceID)

-- tspnet.read()
tspnet.write(deviceID, "*idn?\r\n")

print("write/read returns:", tspnet.read(deviceID))

-- tspnet.readavailable()
ID = tspnet.connect("192.0.2.1")
tspnet.write(ID, "*idn?\r\n")

repeat bytes = tspnet.readavailable(ID) until bytes > 0

print(tspnet.read(ID))
tspnet.disconnect(ID)

-- tspnet.reset()
-- tspnet.timeout
tspnet.timeout = 2.0

-- tspnet.tsp.abort()
testConnection = tspnet.connect("")
tspnet.tsp.abort(testConnection)

-- tspnet.tsp.abortonconnect
tspnet.tsp.abortonconnect = 0

-- tspnet.write()
myID = tspnet.connect("")
tspnet.write(myID, "runscript()\r\n")

-- tspnet.tsp.rbtablecopy()
testTspdevice = tspnet.connect("")
times =   tspnet.tsp.rbtablecopy(testTspdevice,
"testRemotebuffername.timestamps", 1, 3)
print(times)

-- dataqueue.add()
dataqueue.clear()
dataqueue.add(10)
dataqueue.add(11, 2)
result = dataqueue.add(12, 3)
if result == false then
print("Failed to add 12 to the dataqueue")
end
print("The dataqueue contains:")
while dataqueue.count > 0 do
print(dataqueue.next())
end

-- dataqueue.clear()
MaxCount = dataqueue.CAPACITY
while dataqueue.count < MaxCount do
dataqueue.add(1)
end
print("There are " .. dataqueue.count
.. " items in the data queue")
dataqueue.clear()
print("There are " .. dataqueue.count
.. " items in the data queue")

-- dataqueue.CAPACITY
MaxCount = dataqueue.CAPACITY
while dataqueue.count < MaxCount do
dataqueue.add(1)
end
print("There are " .. dataqueue.count
.. " items in the data queue")

-- dataqueue.count
MaxCount = dataqueue.CAPACITY
while dataqueue.count < MaxCount do
dataqueue.add(1)
end
print("There are " .. dataqueue.count
.. " items in the data queue")
dataqueue.clear()
print("There are " .. dataqueue.count
.. " items in the data queue")

-- dataqueue.next()
dataqueue.clear()
for i = 1, 10 do
dataqueue.add(i)
end
print("There are " .. dataqueue.count
.. " items in the data queue")

while dataqueue.count > 0 do
x = dataqueue.next()
print(x)
end
print("There are " .. dataqueue.count
.. " items in the data queue")

-- exit()
-- fs.chdir()
if fs.is_dir("/usb1/temp") == true then
fs.chdir("/usb1/temp")
testPath = fs.cwd()
print(testPath)
else
testPath = fs.cwd()
print(testPath)
end

-- fs.cwd()
if fs.is_dir("/usb1/temp") == true then
fs.chdir("/usb1/temp")
testPath = fs.cwd()
print(testPath)
else
testPath = fs.cwd()
print(testPath)
end

-- fs.is_dir()
print("Is directory: ", fs.is_dir("/usb1/"))

if fs.is_dir("/usb1/temp") == false then
fs.mkdir("/usb1/temp")
end

-- fs.mkdir()
if fs.is_dir("/usb1/temp") == false then
fs.mkdir("/usb1/temp")
end

-- fs.readdir()
rootDirectory = "/usb1/"
entries = fs.readdir(rootDirectory)
count = table.getn(entries)
print("Found a total of "..count.." files and directories")
for i = 1, count do
print(entries[i])
end

-- fs.rmdir()
rootDirectory = "/usb1/"
tempDirectoryName = "temp"
if fs.is_dir(rootDirectory..tempDirectoryName) == false then
fs.mkdir(rootDirectory..tempDirectoryName)
end
fs.rmdir(rootDirectory..tempDirectoryName)

-- fs.is_file()
rootDirectory = "/usb1/"
print("Is file: ", fs.is_file(rootDirectory))

-- gpib.address
gpib.address = 26
address = gpib.address
print(address)

-- lan.lxidomain
print(lan.lxidomain)

-- node[N].execute()
node[2].execute("")

node[3].execute("x = 5")

-- node[32].execute(TestDut.source)

-- node[N].getglobal()
print(node[5].getglobal("test_val"))

-- localnode.model
print(localnode.model)

-- node[N].setglobal()
node[3].setglobal("x", 5)

-- printbuffer()
reset()
testData = buffer.make(200)
format.data = format.ASCII
format.asciiprecision = 6
trigger.model.load("SimpleLoop", 6, 0, testData)
trigger.model.initiate()
waitcomplete()
printbuffer(1, testData.n, testData.readings, testData.units,   testData.relativetimestamps)

for x = 1, testData.n do
printbuffer(x,x,testData, testData.units, testData.relativetimestamps)
end

-- printnumber()
format.asciiprecision = 10
x = 2.54
printnumber(x)
format.asciiprecision = 3
printnumber(x, 2.54321, 3.1)

-- tsplink.group
tsplink.group = 3

-- tsplink.node
tsplink.node = 3

-- tsplink.readport()
data = tsplink.readport()
print(data)

-- tsplink.state
state = tsplink.state
print(state)

-- tsplink.writeport()
tsplink.writeport(3)

-- trigger.blender[N].clear()
trigger.blender[2].clear()

-- trigger.blender[N].orenable
trigger.blender[1].orenable = true
trigger.blender[1].stimulus[1] = trigger.EVENT_DIGIO3
trigger.blender[1].stimulus[2] = trigger.EVENT_DIGIO5

-- trigger.blender[N].overrun
print(trigger.blender[1].overrun)

-- trigger.timer[N].clear()
trigger.timer[1].clear()

-- trigger.timer[N].delay
trigger.timer[1].delay = 50e-6

-- trigger.timer[N].delaylist
trigger.timer[3].delaylist = {50e-6, 100e-6, 150e-6}

DelayList = trigger.timer[3].delaylist
for x = 1, table.maxn(DelayList) do
print(DelayList[x])
end

-- trigger.timer[N].wait()
triggered = trigger.timer[3].wait(10)
print(triggered)

-- trigger.timer[N].count
print(trigger.timer[1].count)

reset()
trigger.timer[4].reset()
trigger.timer[4].delay = 0.5
trigger.timer[4].start.stimulus = trigger.EVENT_NOTIFY8
trigger.timer[4].start.generate = trigger.OFF
trigger.timer[4].count = 20
trigger.timer[4].enable = trigger.ON

trigger.model.load("Empty")
trigger.model.setblock(1, trigger.BLOCK_BUFFER_CLEAR, defbuffer1)
trigger.model.setblock(2, trigger.BLOCK_NOTIFY, trigger.EVENT_NOTIFY8)
trigger.model.setblock(3, trigger.BLOCK_WAIT, trigger.EVENT_TIMER4)
trigger.model.setblock(4, trigger.BLOCK_MEASURE_DIGITIZE, defbuffer1)
trigger.model.setblock(5, trigger.BLOCK_BRANCH_COUNTER, 20, 3)
trigger.model.initiate()
waitcomplete()
print(defbuffer1.n)

-- scriptVar.run()
test8.run()

-- scriptVar.save()
test8.save()

test8.save("/usb1/myScript.tsp")

-- print()
x = 10
print(x)

x = true
print(tostring(x))

-- trigger.blender[N].reset()
trigger.blender[1].reset()

-- smu.measure.func
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.math.format = smu.MATH_PERCENT
smu.measure.math.enable = smu.ON
smu.measure.func = smu.FUNC_RESISTANCE
smu.measure.math.format = smu.MATH_RECIPROCAL
smu.measure.math.enable = smu.ON
print(smu.measure.math.format)
smu.measure.func = smu.FUNC_DC_VOLTAGE
print(smu.measure.math.format)

-- buffer.getstats()
reset()
trigger.model.load("SimpleLoop", 12, 0.001, defbuffer1)
trigger.model.initiate()
waitcomplete()

stats = buffer.getstats(defbuffer1)
print(stats)

-- trigger.model.abort()
trigger.model.abort()

-- buffer.make()
capTest2 = buffer.make(200, buffer.STYLE_FULL)

-- bufferVar.n
reset()
testData = buffer.make(100)
trigger.model.load("SimpleLoop", 3, 0, testData)
trigger.model.initiate()
waitcomplete()
print(testData.n)
print(defbuffer1.n)
print(defbuffer2.n)

-- timer.gettime()
dataqueue.clear()
dataqueue.add(35)
timer.cleartime()
delay(0.5)
dt = timer.gettime()
print("Delay time was " .. dt)
print(dataqueue.next())

-- timer.cleartime()
dataqueue.clear()
dataqueue.add(35)
timer.cleartime()
delay(0.5)
dt = timer.gettime()
print("Delay time was " .. dt)
print(dataqueue.next())
print(trigger.wait(1))
trigger.clear()
print(trigger.wait(1))

-- trigger.wait()
triggered = trigger.wait(10)
print(triggered)

-- bufferVar.formattedreadings
reset()
testData = buffer.make(50)
trigger.model.load("SimpleLoop", 3, 0, testData)
trigger.model.initiate()
waitcomplete()
print(testData.formattedreadings[1])
printbuffer(1, testData.n, testData.formattedreadings)

-- bufferVar.units
reset()
testData = buffer.make(50)
testData.fillmode = buffer.FILL_CONTINUOUS
smu.measure.func = smu.FUNC_DC_CURRENT
trigger.model.load("SimpleLoop", 3, 0, testData)
trigger.model.initiate()
waitcomplete()
printbuffer(1, testData.n, testData.units)
smu.measure.func = smu.FUNC_DC_VOLTAGE
trigger.model.initiate()
waitcomplete()
printbuffer(1, testData.n, testData.units)

-- buffer.saveappend()
buffer.saveappend(MyBuffer, "/usb1/myData.csv")

buffer.saveappend(MyBuffer, "/usb1/myDataRel.csv", buffer.SAVE_RELATIVE_TIME)

reset()
if file.usbdriveexists() == 1 then
testDir = "TestData11"
-- Create a directory on the USB drive for the data.
file.mkdir(testDir)
-- Build the full file and path.
fileName = "/usb1/" .. testDir .. "/myTestData.csv"
-- Open the file where the data will be stored.
fileNumber = file.open(fileName, file.MODE_WRITE)
-- Write the string data to a file.
file.write(fileNumber, "Tested to Company Standard ABC.101\n")
-- Write the header separator to a file.
file.write(fileNumber, "====================================================================\n")
-- Write the string data to a file.
file.write(fileNumber, "\t1. Connect HI/LO to respective DUT terminals.\n")
file.write(fileNumber, "\t2. Set power supply to 5 VDC @ 1 A.\n")
file.write(fileNumber, "\t3. Wait 30 minutes.\n")
file.write(fileNumber, "\t4. Capture 100 readings and analyze data.\n\n\n")
-- Write buffering data to a file.
file.flush(fileNumber)
-- Close the data file.
file.close(fileNumber)
end
-- Fix the range to 10 V.
smu.measure.range = 10.0
-- Set the measurement count to 100.
smu.measure.count = 100
-- Set up reading buffers.
-- Ensure the default measurement buffer size matches the count.
defbuffer1.capacity = smu.measure.count
smu.measure.read()
buffer.saveappend(defbuffer1, fileName)

-- smu.measure.math.enable
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.math.format = smu.MATH_PERCENT
smu.measure.math.enable = smu.ON

-- smu.measure.rel.acquire()
smu.measure.func = smu.FUNC_DC_VOLTAGE
rel_value = smu.measure.rel.acquire()
smu.measure.rel.enable = smu.ON

-- smu.measure.limit[Y].autoclear
smu.measure.func = smu.FUNC_DC_CURRENT
smu.measure.limit[1].autoclear = smu.ON

-- smu.measure.limit[Y].clear()
smu.measure.func = smu.FUNC_DC_CURRENT
smu.measure.limit[2].clear()

-- smu.measure.limit[Y].fail
reset()
-- set the instrument source current
smu.source.func = smu.FUNC_DC_CURRENT
-- set the instrument to measure voltage
smu.measure.func = smu.FUNC_DC_VOLTAGE
-- set the range to 10 V
smu.measure.range = 10
-- set the nplc to 0.1
smu.measure.nplc = 0.1
-- disable auto clearing for limit 1
smu.measure.limit[1].autoclear = smu.OFF
-- set high limit on 1 to fail if reading exceeds 5 V
smu.measure.limit[1].high.value = 5
-- set low limit on 1 to fail if reading is less than 3 V
smu.measure.limit[1].low.value = 3
--- set the beeper to sound if the reading exceeds the limits for limit 1
smu.measure.limit[1].audible = smu.AUDIBLE_FAIL
-- enable limit 1 checking for voltage measurements
smu.measure.limit[1].enable = smu.ON
-- disable auto clearing for limit 2
smu.measure.limit[2].autoclear = smu.OFF
-- set high limit on 2 to fail if reading exceeds 7 V
smu.measure.limit[2].high.value = 7
-- set low limit on 2 to fail if reading is less than 1 V
smu.measure.limit[2].low.value = 1
-- enable limit 2 checking for voltage measurements
smu.measure.limit[2].enable = smu.ON
-- set the measure count to 50
smu.measure.count = 50
-- create a reading buffer that can store 100 readings
LimitBuffer = buffer.make(100)
-- make 50 readings and store them in LimitBuffer
smu.measure.read(LimitBuffer)
-- Check if any of the 50 readings were outside of the limits
print("limit 1 results = " .. smu.measure.limit[1].fail)
print("limit 2 results = " .. smu.measure.limit[2].fail)
-- clear limit 1 conditions
smu.measure.limit[1].clear()
-- clear limit 2 conditions
smu.measure.limit[2].clear()


-- smu.measure.math.format
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.math.format = smu.MATH_RECIPROCAL
smu.measure.math.enable = smu.ON

-- smu.measure.read()
voltMeasBuffer = buffer.make(10000)
smu.measure.func = smu.FUNC_DC_VOLTAGE
print(smu.measure.read(voltMeasBuffer))

-- smu.measure.configlist.create()
smu.measure.configlist.create("MyMeasList")

-- smu.source.configlist.store()
smu.source.configlist.store("MyConfigList")

-- smu.source.configlist.catalog()
print(smu.source.configlist.catalog())

-- smu.source.configlist.create()
reset()

smu.source.configlist.create("MyScrList")

print(smu.source.configlist.catalog())

print(smu.source.configlist.catalog())



smu.source.configlist.store("MyScrList")
smu.source.configlist.store("MyScrList")
print(smu.source.configlist.size("MyScrList"))

-- smu.source.configlist.delete()
smu.source.configlist.delete("mySourceList")

-- smu.source.configlist.query()
print(smu.source.configlist.query("MyScrList", 2))

-- smu.source.configlist.size()
print(smu.source.configlist.size("MyScrList"))

-- eventlog.save()
eventlog.save("/usb1/WarningsApril", eventlog.SEV_WARN)

-- bufferVar.capacity
reset()
testData = buffer.make(500)
capTest = buffer.make(300)
bufferCapacity = capTest.capacity

print(bufferCapacity)


print(testData.capacity)


testData.capacity = 600
print(testData.capacity)
print(defbuffer1.capacity)

-- bufferVar.sourceunits
reset()
testData = buffer.make(50)
smu.source.output = smu.ON
testData.fillmode = buffer.FILL_CONTINUOUS
trigger.model.load("SimpleLoop", 3, 0, testData)
smu.source.func = smu.FUNC_DC_CURRENT
trigger.model.initiate()
waitcomplete()
printbuffer(1, testData.n, testData.sourceunits)
trigger.model.load("SimpleLoop", 3, 0, testData)
smu.source.func = smu.FUNC_DC_VOLTAGE
trigger.model.initiate()
waitcomplete()
printbuffer(1, testData.n, testData.sourceunits)
smu.source.output = smu.OFF

-- bufferVar.relativetimestamps
reset()
testData = buffer.make(50)
trigger.model.load("SimpleLoop", 3, 0, testData)
trigger.model.initiate()
waitcomplete()
print(testData.relativetimestamps[1])
printbuffer(1, 3, testData.relativetimestamps)

-- bufferVar.seconds
reset()
testData = buffer.make(50)
trigger.model.load("SimpleLoop", 6, 0, testData)
trigger.model.initiate()
waitcomplete()
printbuffer(1, 6, testData.seconds)

-- bufferVar.times
reset()
testData = buffer.make(50)
trigger.model.load("SimpleLoop", 3, 0, testData)
trigger.model.initiate()
waitcomplete()
print(testData.times[1])
printbuffer(1, 3, testData.times)

-- bufferVar.timestamps
reset()
testData = buffer.make(50)
trigger.model.load("SimpleLoop", 3, 0, testData)
trigger.model.initiate()
waitcomplete()
print(testData.timestamps[1])

for x = 1, 3 do printbuffer(x, x, testData.timestamps) end

-- display.readingformat
display.readingformat = display.FORMAT_EXPONENT

-- display.settext()
display.clear()
display.changescreen(display.SCREEN_USER_SWIPE)
display.settext(display.TEXT1, "A122 \185 A123")
display.settext(display.TEXT2, "Results in \018")

-- file.mkdir()
file.mkdir("TestData")

-- file.open()
file_num = file.open("/usb1/testfile.txt", file.MODE_WRITE)
if file_num ~= nil then
file.write(file_num, "This is my test file")
file.close(file_num)
end

-- lan.ipconfig()
lan.ipconfig(lan.MODE_AUTO)
print(lan.ipconfig())
lan.ipconfig(lan.MODE_MANUAL, "192.168.0.7", "255.255.240.0", "192.168.0.3")
print(lan.ipconfig())

-- localnode.settime()
localnode.settime(2017, 12, 5, 15, 48, 20)
print(localnode.settime())

systemTime = os.time({year = 2018,
month = 3,
day = 31,
hour = 14,
min = 25})
localnode.settime(systemTime)
print(os.date('%c', gettime()))

-- smu.interlock.tripped
print(smu.interlock.tripped)

-- smu.measure.sense
smu.measure.func = smu.FUNC_RESISTANCE
smu.measure.sense = smu.SENSE_4WIRE

-- smu.terminals
smu.terminals = smu.TERMINALS_FRONT

-- trigger.model.state()
print(trigger.model.state())

-- eventlog.clear()
-- eventlog.next()
print(eventlog.next(5))

-- file.read()
file_num = file.open("/usb1/testfile.txt", file.MODE_READ)
if file_num ~= nil then
file_contents = file.read(file_num, file.READ_ALL)
file.close(file_num)
end

-- file.close()
file_num = file.open("/usb1/GENTRIGGER", file.MODE_WRITE)
file.close(file_num)

-- file.write()
file_num = file.open("testfile.txt", file.MODE_WRITE)
if file_num ~= nil then
file.write(file_num, "This is my test file")
file.close(file_num)
end

-- file.flush()
reset()

-- Fix the range to 10 V
smu.measure.range = 10

-- Set the measurement count to 100
smu.measure.count = 100

-- Set up reading buffers
-- Ensure the default measurement buffer size matches the count
defbuffer1.capacity = 100
smu.measure.read()

testDir = "TestData5"

-- create a directory on the USB drive for the data
file.mkdir(testDir)
fileName = "/usb1/" .. testDir .. "/myTestData.csv"
buffer.save(defbuffer1, fileName)

if file.usbdriveexists() ~= 0 then
-- testDir = "TestData3"

-- Create a directory on the USB drive for the data
-- file.mkdir(testDir)
-- Open the file where the data will be stored
-- fileName = "/usb1/" .. testDir .. "/myTestData.csv"
fileNumber = file.open(fileName, file.MODE_APPEND)
-- Write header separator to file
file.write(fileNumber, "\n\n====================================================================\n")
-- Write the string data to a file
file.write(fileNumber, "Tested to Company Standard ABC.123\n")
-- Ensure a hurry-up of data written to the file before close or script end
file.flush(fileNumber)
-- Close the data file
file.close(fileNumber)

end

-- smu.source.output
smu.source.output = smu.ON

-- format.byteorder
x = 1.23
format.data = format.REAL32
format.byteorder = format.LITTLEENDIAN
printnumber(x)
format.byteorder = format.BIGENDIAN
printnumber(x)

-- format.asciiprecision
format.asciiprecision = 10
x = 2.54
printnumber(x)
format.asciiprecision = 3
printnumber(x)

-- format.data
format.asciiprecision = 10
x = 3.14159265
format.data = format.ASCII
printnumber(x)
format.data = format.REAL64
printnumber(x)

-- trigger.lanin[N].edge
trigger.lanin[1].edge = trigger.EDGE_FALLING

-- smu.measure.displaydigits
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.displaydigits = smu.DIGITS_6_5

-- smu.measure.configlist.catalog()
print(smu.measure.configlist.catalog())

-- smu.measure.configlist.query()
print(smu.measure.configlist.query("testMeasList", 2, "\n"))

-- smu.measure.configlist.recall()
smu.measure.configlist.recall("MyMeasList")

-- smu.measure.configlist.delete()
smu.measure.configlist.delete("myMeasList")

-- lan.macaddress
print(lan.macaddress)

-- smu.measure.autozero.enable
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.autozero.enable = smu.OFF

-- smu.measure.autozero.once()
smu.measure.autozero.once()

-- smu.measure.nplc
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.nplc = 0.5

-- smu.source.protect.level
smu.source.func = smu.FUNC_DC_VOLTAGE
smu.source.protect.level = smu.PROTECT_40V

-- smu.source.delay
smu.source.func = smu.FUNC_DC_VOLTAGE
smu.source.delay = 3

-- smu.measure.offsetcompensation
smu.measure.func = smu.FUNC_RESISTANCE
smu.measure.sense = smu.SENSE_4WIRE
smu.measure.offsetcompensation = smu.ON
smu.source.output = smu.ON
print(smu.measure.read())
smu.source.output = smu.OFF

-- smu.source.offmode
smu.source.offmode = smu.OFFMODE_HIGHZ

-- smu.source.func
smu.source.func = smu.FUNC_DC_CURRENT

-- smu.source.range
smu.source.func = smu.FUNC_DC_CURRENT
smu.source.autorange = smu.OFF
smu.source.range = 1

-- smu.source.autorange
smu.source.func = smu.FUNC_DC_CURRENT
smu.source.autorange = smu.ON

-- smu.measure.autorange
smu.measure.func = smu.FUNC_DC_CURRENT
smu.measure.autorange = smu.ON

-- smu.measure.range
smu.source.func = smu.FUNC_DC_CURRENT
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.range = 0.5

-- smu.measure.autorangelow
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.autorange = smu.ON
smu.measure.autorangelow = 2

-- smu.measure.autorangehigh
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.autorange = smu.ON
print(smu.measure.autorangehigh)

-- beeper.beep()
beeper.beep(2, 2400)

-- opc()
opc()
waitcomplete()
print("1")

-- smu.measure.limit[Y].enable
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.limit[1].enable = smu.ON

-- smu.source.level
smu.source.func = smu.FUNC_DC_VOLTAGE
smu.source.level = 1

-- smu.measure.rel.enable
smu.measure.func = smu.FUNC_DC_VOLTAGE
rel_value = smu.measure.rel.acquire()
smu.measure.rel.enable = smu.ON

-- smu.measure.rel.level
smu.measure.func = smu.FUNC_DC_CURRENT
smu.measure.rel.level = smu.measure.read()
smu.measure.rel.enable = smu.ON

-- smu.measure.filter.count
smu.measure.func = smu.FUNC_DC_CURRENT
smu.measure.filter.count = 10
smu.measure.filter.type = smu.FILTER_MOVING_AVG
smu.measure.filter.enable = smu.ON

-- smu.measure.filter.type
smu.measure.func = smu.FUNC_DC_CURRENT
smu.measure.filter.count = 10
smu.measure.filter.type = smu.FILTER_MOVING_AVG
smu.measure.filter.enable = smu.ON

-- smu.measure.filter.enable
smu.measure.func = smu.FUNC_DC_CURRENT
smu.measure.filter.count = 10
smu.measure.filter.type = smu.FILTER_MOVING_AVG
smu.measure.filter.enable = smu.ON

-- smu.measure.math.mxb.bfactor
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.math.format = smu.MATH_MXB
smu.measure.math.mxb.mfactor = 0.80
smu.measure.math.mxb.bfactor = 50
smu.measure.math.enable = smu.ON

-- smu.measure.math.mxb.mfactor
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.math.format = smu.MATH_MXB
smu.measure.math.mxb.mfactor = 0.80
smu.measure.math.mxb.bfactor = 50
smu.measure.math.enable = smu.ON

-- smu.measure.math.percent
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.math.format = smu.MATH_PERCENT
smu.measure.math.percent = 50
smu.measure.math.enable = smu.ON

-- smu.source.protect.tripped
print(smu.source.protect.tripped)

-- bufferVar.clear()
reset()
testData = buffer.make(50)
trigger.model.load("SimpleLoop", 3, 0, testData)
trigger.model.initiate()
waitcomplete()
printbuffer(1, testData.n, testData)
testData.clear()
print("Readings in buffer after clear ="    .. testData.n)
trigger.model.initiate()
waitcomplete()
printbuffer(1, testData.n, testData)

-- bufferVar.dates
reset()
testData = buffer.make(50)
trigger.model.load("SimpleLoop", 3, 1, testData)
trigger.model.initiate()
waitcomplete()
print(testData.dates[1])
printbuffer(1, testData.n, testData.dates)

-- bufferVar.fillmode
reset()
testData = buffer.make(50)
print(testData.fillmode)
testData.fillmode = buffer.FILL_CONTINUOUS
print(testData.fillmode)

-- trigger.digout[N].stimulus
digio.line[2].mode = digio.MODE_TRIGGER_OUT
trigger.digout[2].stimulus = trigger.EVENT_TIMER3

-- display.clear()
display.clear()
display.changescreen(display.SCREEN_USER_SWIPE)
display.settext(display.TEXT1, "Serial number:")
display.settext(display.TEXT2, localnode.serialno)

-- display.changescreen()
display.clear()
display.settext(display.TEXT1, "Batch A122")
display.settext(display.TEXT2, "Test running")
display.changescreen(display.SCREEN_USER_SWIPE)

-- localnode.showevents
localnode.showevents = eventlog.SEV_ERROR | eventlog.SEV_INFO
trigger.digin[3].edge = trigger.EDGE_EITHER

-- smu.measure.count
reset()

-- Set up measure function
smu.measure.func = smu.FUNC_DC_CURRENT
smu.terminals = smu.TERMINALS_REAR
smu.measure.autorange = smu.ON
smu.measure.nplc = 1
smu.measure.count = 200

-- Set up source function
smu.source.func = smu.FUNC_DC_VOLTAGE
smu.source.ilimit.level = 0.1
smu.source.level = 20
smu.source.delay = 0.1
smu.source.highc = smu.OFF

-- Turn on output and initiate readings
smu.source.output = smu.ON
smu.measure.read(defbuffer1)

-- Parse index and data into three columns
print("Rdg #", "Time (s)", "Current (A)")
for i = 1, defbuffer1.n do
print(i, defbuffer1.relativetimestamps[i], defbuffer1[i])
end

-- Discharge the capacitor to 0 V and turn off the output
smu.source.level = 0
delay(2)
smu.source.output = smu.OFF

reset()

-- Set up measure function
smu.measure.func = smu.FUNC_DC_CURRENT
smu.terminals = smu.TERMINALS_REAR
smu.measure.autorange = smu.ON
smu.measure.nplc = 1

-- Set up source function
smu.source.func = smu.FUNC_DC_VOLTAGE
smu.source.ilimit.level = 0.1
smu.source.level = 20
smu.source.delay = 0.1
smu.source.highc = smu.OFF

-- Turn on output and initiate readings
smu.source.output = smu.ON
trigger.model.load("SimpleLoop", 200)
trigger.model.initiate()
waitcomplete()

-- Parse index and data into three columns
print("Rdg #", "Time (s)", "Current (A)")
for i = 1, defbuffer1.n do
print(i, defbuffer1.relativetimestamps[i], defbuffer1[i])
end

-- Discharge the capacitor to 0 V and turn off the output
smu.source.level = 0
delay(2)
smu.source.output = smu.OFF

-- smu.reset()
smu.reset()

-- status.operation.getmap()
print(status.operation.getmap(0))

-- status.questionable.event
-- decimal 66 = binary 0100 0010
questionableRegister = 66
status.questionable.enable = questionableRegister

-- decimal 2560 = binary 00001010 0000 0000
questionableRegister = 2560
status.questionable.enable = questionableRegister

-- status.standard.enable
standardRegister = status.standard.OPC + status.standard.QYE
status.standard.enable = standardRegister

-- decimal 5 = binary 0000 0101
standardRegister = 5
status.standard.enable = standardRegister

-- trigger.timer[N].start.generate
trigger.timer[4].reset()
trigger.timer[4].delay = 0.5
trigger.timer[4].start.stimulus = trigger.EVENT_NOTIFY8
trigger.timer[4].start.generate = trigger.OFF
trigger.timer[4].count = 20
trigger.timer[4].enable = trigger.ON

-- bufferVar.sourceformattedvalues
reset()
trigger.model.load("SimpleLoop", 6, 0)
trigger.model.initiate()
waitcomplete()
print(defbuffer1.sourceformattedvalues[1])
printbuffer(1,6,defbuffer1.sourceformattedvalues)

-- bufferVar.fractionalseconds
reset()
testData = buffer.make(50)
trigger.model.load("SimpleLoop", 6, 0, testData)
trigger.model.initiate()
waitcomplete()
print(testData.fractionalseconds[1])
printbuffer(1, 6, testData.fractionalseconds)

-- bufferVar.readings
reset()
testData = buffer.make(50)
trigger.model.load("SimpleLoop", 3, 0, testData)
trigger.model.initiate()
waitcomplete()
for x = 1, 3 do printbuffer(x, x, testData.readings, testData.sourcevalues, testData.relativetimestamps) end

-- bufferVar.sourcevalues
reset()
testData = buffer.make(50)
smu.source.func = smu.FUNC_DC_CURRENT
smu.source.level = 1e-6
smu.source.output = smu.ON
trigger.model.load("SimpleLoop", 3, 0, testData)
trigger.model.initiate()
waitcomplete()
printbuffer(1, 3, testData.sourcevalues)

-- tsplink.initialize()
nodesFound = tsplink.initialize(2)
print("Nodes found = " .. nodesFound)

-- eventlog.getcount()
print(eventlog.getcount(eventlog.SEV_INFO))

-- trigger.timer[N].start.overrun
print(trigger.timer[1].start.overrun)

-- trigger.timer[N].start.stimulus
digio.line[3].mode = digio.MODE_TRIGGER_IN
trigger.timer[1].delay = 3e-3
trigger.timer[1].start.stimulus = trigger.EVENT_DIGIO3

-- smu.measure.configlist.store()
smu.measure.configlist.store("MyConfigList")

-- smu.measure.unit
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.unit = smu.UNIT_WATT

-- smu.source.ilimit.level
smu.source.func = smu.FUNC_DC_VOLTAGE
smu.source.ilimit.level = 1

-- smu.source.vlimit.level
smu.source.func = smu.FUNC_DC_VOLTAGE
smu.source.ilimit.level = 1

-- smu.source.ilimit.tripped
print(smu.source.vlimit.tripped)

-- smu.source.vlimit.tripped
print(smu.source.vlimit.tripped)

-- smu.source.sweeplinear()
reset()
smu.source.func = smu.FUNC_DC_VOLTAGE
smu.source.range = 20
smu.source.sweeplinear("VoltLinSweep", 0, 10, 20, 1e-3, 1, smu.RANGE_FIXED)
smu.measure.func = smu.FUNC_DC_CURRENT
smu.measure.range = 100e-6
trigger.model.initiate()

-- smu.source.sweeplinearstep()
reset()
smu.source.func = smu.FUNC_DC_CURRENT
smu.source.range = 1
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.range = 20
smu.source.sweeplinearstep("CurrLogSweep", -1.05, 1.05, .25, 10e-3, 1, smu.RANGE_FIXED)
trigger.model.initiate()

-- smu.source.sweeplog()
reset()
smu.source.func = smu.FUNC_DC_VOLTAGE
smu.source.range = 20
smu.measure.func = smu.FUNC_DC_CURRENT
smu.measure.range = 100e-6
smu.source.sweeplog("VoltLogSweep", 1, 10, 20, 1e-3, 1, smu.RANGE_FIXED)
trigger.model.initiate()

-- status.clear()
status.clear()

-- trigger.model.getblocklist()
print(trigger.model.getblocklist())

-- trigger.model.getbranchcount()
reset()
trigger.model.setblock(1, trigger.BLOCK_BUFFER_CLEAR)
trigger.model.setblock(2, trigger.BLOCK_MEASURE_DIGITIZE)
trigger.model.setblock(3, trigger.BLOCK_DELAY_CONSTANT, 0.1)
trigger.model.setblock(4, trigger.BLOCK_BRANCH_COUNTER, 10, 2)
trigger.model.initiate()
delay(1)
print(trigger.model.getbranchcount(4))
waitcomplete()

-- trigger.model.initiate()
-- trigger.BLOCK_BUFFER_CLEAR
trigger.model.setblock(3, trigger.BLOCK_BUFFER_CLEAR, capTest2)

-- trigger.timer[N].enable
trigger.timer[3].enable = trigger.ON

-- bufferVar.logstate
reset()
MyBuffer = buffer.make(500)
print(MyBuffer.logstate)

-- smu.source.readback
reset()
testDataBuffer = buffer.make(100)
smu.source.func = smu.FUNC_DC_VOLTAGE
smu.measure.func = smu.FUNC_DC_CURRENT
smu.source.readback = smu.ON
smu.source.level = 10
smu.measure.count = 100
smu.source.output = smu.ON
smu.measure.read(testDataBuffer)
smu.source.output = smu.OFF
printbuffer(1, 100, testDataBuffer.sourcevalues, testDataBuffer)

-- smu.source.highc
smu.source.highc = smu.ON

-- trigger.model.load() - DurationLoop
reset()

-- Set up measure function
smu.measure.func = smu.FUNC_DC_CURRENT

-- Set up source function
smu.source.func = smu.FUNC_DC_VOLTAGE
smu.source.level = 5

-- Turn on output, initiate readings, and store them in defbuffer1
trigger.model.load("DurationLoop", 10, 0.01, defbuffer1)
trigger.model.initiate()

-- digio.writeport()
digio.writeport(63)

-- digio.line[N].state
digio.line[1].mode = digio.MODE_DIGITAL_OUT
digio.line[1].state = digio.STATE_HIGH

-- trigger.timer[N].reset()
trigger.timer[1].reset()

-- trigger.BLOCK_WAIT
trigger.model.setblock(9, trigger.BLOCK_WAIT, trigger.EVENT_DISPLAY)

-- trigger.BLOCK_MEASURE_DIGITIZE
reset()
smu.measure.func = smu.FUNC_DC_VOLTAGE
trigger.model.setblock(1, trigger.BLOCK_BUFFER_CLEAR, defbuffer1)
trigger.model.setblock(2, trigger.BLOCK_DELAY_CONSTANT, 0)
trigger.model.setblock(3, trigger.BLOCK_MEASURE_DIGITIZE, defbuffer1, trigger.COUNT_INFINITE)
trigger.model.setblock(4, trigger.BLOCK_WAIT, trigger.EVENT_DISPLAY)
trigger.model.setblock(5, trigger.BLOCK_MEASURE_DIGITIZE, defbuffer1, trigger.COUNT_STOP)
trigger.model.setblock(6, trigger.BLOCK_NOTIFY, trigger.EVENT_NOTIFY1)
trigger.model.initiate()
waitcomplete()
print(defbuffer1.n)

reset()
smu.measure.configlist.create("countactive")
smu.measure.count = 2
smu.measure.configlist.store("countactive")  -- index1
smu.measure.count = 10
smu.measure.configlist.store("countactive")  -- index2
smu.measure.count = 3
smu.measure.configlist.store("countactive")  -- index3

trigger.model.setblock(1, trigger.BLOCK_CONFIG_NEXT, "countactive")
trigger.model.setblock(2, trigger.BLOCK_MEASURE_DIGITIZE, defbuffer1, trigger.COUNT_AUTO)
trigger.model.setblock(3, trigger.BLOCK_DELAY_CONSTANT, 1)
trigger.model.setblock(4, trigger.BLOCK_BRANCH_COUNTER, 3, 1)
trigger.model.initiate()
waitcomplete()
print(defbuffer1.n)

-- trigger.BLOCK_SOURCE_OUTPUT
trigger.model.setblock(2, trigger.BLOCK_SOURCE_OUTPUT, smu.ON)

-- trigger.BLOCK_CONFIG_RECALL
trigger.model.setblock(3, trigger.BLOCK_CONFIG_RECALL, "measTrigList", 5)

trigger.model.setblock(3, trigger.BLOCK_CONFIG_RECALL, "measTrigList", 5,
"sourTrigList")
print(trigger.model.getblocklist())

-- trigger.BLOCK_CONFIG_NEXT
trigger.model.setblock(5, trigger.BLOCK_CONFIG_NEXT, "measTrigList")

trigger.model.load("Empty")
trigger.model.setblock(1, trigger.BLOCK_CONFIG_RECALL, "measTrigList")
trigger.model.setblock(2, trigger.BLOCK_BUFFER_CLEAR)
trigger.model.setblock(3, trigger.BLOCK_CONFIG_NEXT, "measTrigList")
print(trigger.model.getblocklist())

trigger.model.setblock(7, trigger.BLOCK_CONFIG_NEXT, "measTrigList", "sourTrigList")

-- trigger.BLOCK_CONFIG_PREV
trigger.model.setblock(8, trigger.BLOCK_CONFIG_PREV, "measTrigList")

trigger.model.load("Empty")
trigger.model.setblock(1, trigger.BLOCK_CONFIG_RECALL, "measTrigList", 3)
trigger.model.setblock(2, trigger.BLOCK_BUFFER_CLEAR)
trigger.model.setblock(3, trigger.BLOCK_CONFIG_PREV, "measTrigList")
print(trigger.model.getblocklist())

trigger.model.setblock(7, trigger.BLOCK_CONFIG_PREV, "measTrigList", "sourTrigList")

-- trigger.BLOCK_DELAY_DYNAMIC
smu.measure.userdelay[1] = 5
trigger.model.setblock(1, trigger.BLOCK_SOURCE_OUTPUT, smu.ON)
trigger.model.setblock(2, trigger.BLOCK_DELAY_DYNAMIC, trigger.USER_DELAY_M1)
trigger.model.setblock(3, trigger.BLOCK_MEASURE_DIGITIZE)
trigger.model.setblock(4, trigger.BLOCK_SOURCE_OUTPUT, smu.OFF)
trigger.model.setblock(5, trigger.BLOCK_BRANCH_COUNTER, 10, 1)
trigger.model.initiate()

-- trigger.BLOCK_DIGITAL_IO
for x = 3, 6 do digio.line[x].mode = digio.MODE_DIGITAL_OUT end
trigger.model.setblock(4, trigger.BLOCK_DIGITAL_IO, 20, 60)

-- trigger.BLOCK_BRANCH_COUNTER
trigger.model.setblock(4, trigger.BLOCK_BRANCH_COUNTER, 10, 2)
print(trigger.model.getbranchcount(4))

-- trigger.BLOCK_BRANCH_ON_EVENT
trigger.model.setblock(6, trigger.BLOCK_BRANCH_ON_EVENT, trigger.EVENT_DISPLAY, 2)

-- trigger.BLOCK_BRANCH_LIMIT_CONSTANT
trigger.model.setblock(5, trigger.BLOCK_BRANCH_LIMIT_CONSTANT, trigger.LIMIT_ABOVE, 0.1, 1, 2)

-- trigger.BLOCK_BRANCH_DELTA
trigger.model.setblock(5, trigger.BLOCK_BRANCH_DELTA, 0.35, 8, 3)

-- trigger.BLOCK_BRANCH_ONCE
trigger.model.setblock(2, trigger.BLOCK_BRANCH_ONCE, 4)

-- trigger.BLOCK_BRANCH_ONCE_EXCLUDED
trigger.model.setblock(2, trigger.BLOCK_BRANCH_ONCE_EXCLUDED, 4)

-- trigger.BLOCK_NOTIFY
digio.line[3].mode = digio.MODE_TRIGGER_OUT
trigger.model.setblock(5, trigger.BLOCK_NOTIFY, trigger.EVENT_NOTIFY2)
trigger.digout[3].stimulus = trigger.EVENT_NOTIFY2

-- trigger.BLOCK_BRANCH_ALWAYS
trigger.model.setblock(6, trigger.BLOCK_BRANCH_ALWAYS, 20)

-- trigger.BLOCK_BRANCH_LIMIT_DYNAMIC
trigger.model.setblock(7, trigger.BLOCK_BRANCH_LIMIT_DYNAMIC, trigger.LIMIT_OUTSIDE, 2, 10, 5)

-- trigger.BLOCK_DELAY_CONSTANT
trigger.model.setblock(7, trigger.BLOCK_DELAY_CONSTANT, 30e-3)

-- trigger.digin[N].edge
digio.line[4].mode = digio.MODE_TRIGGER_IN
trigger.digin[4].edge = trigger.EDGE_RISING

-- digio.line[N].mode
digio.line[1].mode = digio.MODE_TRIGGER_OUT

-- digio.readport()
data = digio.readport()
print(data)

-- trigger.digin[N].clear()
trigger.digin[2].clear()

-- trigger.digin[N].overrun
overrun = trigger.digin[1].overrun
print(overrun)

-- trigger.digout[N].pulsewidth
digio.line[4].mode = digio.MODE_TRIGGER_OUT
trigger.digout[4].pulsewidth = 20e-6

-- trigger.digout[N].assert()
digio.line[2].mode = digio.MODE_TRIGGER_OUT
trigger.digout[2].pulsewidth = 20e-6
trigger.digout[2].assert()

-- digio.line[N].reset()
-- Set the digital I/O trigger line 3 for a falling edge
digio.line[3].mode = digio.MODE_TRIGGER_OUT
trigger.digout[3].logic = trigger.LOGIC_NEGATIVE
-- Set the digital I/O trigger line 3 to have a pulsewidth of 50 microseconds.
trigger.digout[3].pulsewidth = 50e-6
-- Use digital I/O line 5 to trigger the event on line 3.
trigger.digout[3].stimulus = trigger.EVENT_DIGIO5
-- Print configuration (before reset).
print(digio.line[3].mode, trigger.digout[3].pulsewidth, trigger.digout[3].stimulus)
-- Reset the line back to factory default values.
digio.line[3].reset()
-- Print configuration (after reset).
print(digio.line[3].mode, trigger.digout[3].pulsewidth, trigger.digout[3].stimulus)

-- trigger.digin[N].wait()
digio.line[4].mode = digio.MODE_TRIGGER_IN
triggered = trigger.digin[4].wait(3)
print(triggered)

-- trigger.digout[N].release()
digio.line[4].mode = digio.MODE_TRIGGER_OUT
trigger.digout[4].release()

-- trigger.lanout[N].assert()
trigger.lanout[5].assert()

-- trigger.lanin[N].wait()
triggered = trigger.lanin[5].wait(3)

-- trigger.lanin[N].clear()
trigger.lanin[5].clear()

-- trigger.lanout[N].connect()
trigger.lanout[1].protocol = lan.PROTOCOL_MULTICAST
trigger.lanout[1].connect()
trigger.lanout[1].assert()

-- trigger.lanout[N].disconnect()
-- trigger.lanout[N].connected
trigger.lanout[1].protocol = lan.PROTOCOL_MULTICAST
print(trigger.lanout[1].connected)

-- trigger.lanout[N].ipaddress
trigger.lanout[3].protocol = lan.PROTOCOL_TCP
trigger.lanout[3].ipaddress = "192.0.32.10"
trigger.lanout[3].connect()

-- trigger.lanin[N].overrun
overrun = trigger.lanin[5].overrun
print(overrun)

-- trigger.lanout[N].protocol
print(trigger.lanout[1].protocol)

-- trigger.lanout[N].stimulus
trigger.lanout[5].stimulus = trigger.EVENT_TIMER1

-- smu.measure.userdelay[N]
smu.measure.userdelay[1] = 5
trigger.model.setblock(1, trigger.BLOCK_SOURCE_OUTPUT, smu.ON)
trigger.model.setblock(2, trigger.BLOCK_DELAY_DYNAMIC, trigger.USER_DELAY_M1)
trigger.model.setblock(3, trigger.BLOCK_MEASURE_DIGITIZE)
trigger.model.setblock(4, trigger.BLOCK_SOURCE_OUTPUT, smu.OFF)
trigger.model.setblock(5, trigger.BLOCK_BRANCH_COUNTER, 10, 1)
trigger.model.initiate()

-- smu.measure.readwithtime()
print(smu.measure.readwithtime(defbuffer1))

-- smu.source.sweeplist()
reset()
smu.source.configlist.create("CurrListSweep")
smu.source.func = smu.FUNC_DC_CURRENT
smu.source.range = 100e-3
smu.source.level = 1e-3
smu.source.configlist.store("CurrListSweep")
smu.source.level = 10e-6
smu.source.configlist.store("CurrListSweep")
smu.source.level = 7e-3
smu.source.configlist.store("CurrListSweep")
smu.source.level = 11e-3
smu.source.configlist.store("CurrListSweep")
smu.source.level = 9e-3
smu.source.configlist.store("CurrListSweep")
smu.source.sweeplist("CurrListSweep", 1, 0.001)
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.range = 20
trigger.model.initiate()

-- status.questionable.setmap()
status.questionable.setmap(0, 4917, 4918)

-- status.questionable.getmap()
print(status.questionable.getmap(9))

-- status.questionable.condition
print(status.questionable.condition)

-- status.questionable.enable
status.questionable.enable = 17
print(status.questionable.enable)

-- status.condition
statusByte = status.condition
print(statusByte)

-- status.operation.enable
-- decimal 20480 = binary 0101 0000 0000 0000
operationRegister = 20480
status.operation.enable = operationRegister

-- status.operation.event
status.request_enable = status.OSB
status.operation.setmap(0, 4918, 4917)
status.operation.enable = 1
defbuffer1.clear()
defbuffer1.fillmode = buffer.FILL_ONCE
defbuffer1.capacity = 10
smu.measure.count = 10
smu.measure.read()
print(status.operation.event)

-- status.operation.condition
print(status.operation.condition)

-- status.operation.setmap()
status.operation.setmap(0, 2731, 2732)

-- status.standard.event
print(status.standard.event)

-- status.request_enable
requestSRQEnableRegister = status.MSB + status.OSB
status.request_enable = requestSRQEnableRegister

-- decimal 129 = binary 10000001
requestSRQEnableRegister = 129
status.request_enable = requestSRQEnableRegister

status.request_enable = 0

-- localnode.gettime()
print(os.date('%c', gettime()))

-- tsplink.line[N].mode
tsplink.line[3].mode = tsplink.MODE_TRIGGER_OPEN_DRAIN

-- trigger.tsplinkin[N].edge
tsplink.line[3].mode = tsplink.MODE_TRIGGER_OPEN_DRAIN
trigger.tsplinkin[3].edge = trigger.EDGE_RISING

-- trigger.tsplinkout[N].logic
tsplink.line[3].mode = tsplink.MODE_TRIGGER_OPEN_DRAIN
trigger.tsplinkout[3].logic = trigger.LOGIC_POSITIVE

-- tsplink.line[N].reset()
tsplink.line[3].reset()

-- tsplink.line[N].state
lineState = tsplink.line[3].state
print(lineState)

-- trigger.tsplinkout[N].assert()
tsplink.line[2].mode = tsplink.MODE_TRIGGER_OPEN_DRAIN
trigger.tsplinkout[2].assert()

-- trigger.tsplinkin[N].clear()
tsplink.line[2].mode = tsplink.MODE_TRIGGER_OPEN_DRAIN
trigger.tsplinkin[2].clear()

-- trigger.tsplinkin[N].overrun
print(trigger.tsplinkin[1].overrun)

-- trigger.tsplinkout[N].pulsewidth
tsplink.line[3].mode = tsplink.MODE_TRIGGER_OPEN_DRAIN
trigger.tsplinkout[3].pulsewidth = 20e-6

-- trigger.tsplinkout[N].release()
tsplink.line[3].mode = tsplink.MODE_TRIGGER_OPEN_DRAIN
trigger.tsplinkout[3].release()

-- trigger.tsplinkout[N].stimulus
print(trigger.tsplinkout[3].stimulus)

-- trigger.tsplinkin[N].wait()
tsplink.line[3].mode = tsplink.MODE_TRIGGER_OPEN_DRAIN
triggered = trigger.tsplinkin[3].wait(10)
print(triggered)

-- tsplink.master
LinkMaster = tsplink.master

-- localnode.version
print(localnode.version)

-- localnode.serialno
display.clear()
display.settext(display.TEXT2, "Serial #: " ..localnode.serialno)
display.changescreen(display.SCREEN_USER_SWIPE)

-- localnode.linefreq
frequency = localnode.linefreq
print(frequency)

-- tspnet.tsp.runscript()
myConnection = tspnet.connect("")
tspnet.tsp.runscript(myConnection, "myTest",
"print([[start]]) for d = 1, 10 do print([[work]]) end print([[end]])")

-- smu.measure.configlist.size()
print(smu.measure.configlist.size("testMeasList"))

-- localnode.access
localnode.access = localnode.ACCESS_LOCKOUT

-- smu.source.autodelay
smu.source.autodelay = smu.OFF

-- localnode.prompts
localnode.prompts = localnode.ENABLE

-- smu.source.configlist.recall()
smu.source.configlist.recall("MySourceList")

-- trigger.lanout[N].logic
trigger.lanout[2].logic = trigger.LOGIC_POSITIVE

-- trigger.digout[N].logic
digio.line[4].mode = digio.MODE_TRIGGER_OUT
trigger.digout[4].logic = trigger.LOGIC_NEGATIVE

-- bufferVar.statuses
reset()
testData = buffer.make(50)
smu.source.output = smu.ON
trigger.model.load("SimpleLoop", 2, 0, testData)
trigger.model.initiate()
waitcomplete()
printbuffer(1, 2, testData.statuses)

-- buffer.save()
buffer.save(MyBuffer, "/usb1/myData.csv")

buffer.save(MyBuffer, "/usb1/myDataRel.csv", buffer.SAVE_RELATIVE_TIME)

buffer.save(defbuffer1, "/usb1/defbuf1data", buffer.SAVE_RAW_TIME)

-- display.prompt()
smu.source.sweeplinear("test", 1, 10, 10)
display.prompt(display.BUTTONS_YESNO, "Would you like to start the sweep now?")
sweepTest, result = display.waitevent()
if result == display.BUTTON_YES then
trigger.model.initiate()
end
display.prompt(display.BUTTONS_YESNO, "Would you like to switch to the Graph screen?")
promptID, result = display.waitevent()
if result == display.BUTTON_YES then
display.changescreen(display.SCREEN_GRAPH)
end

-- display.waitevent()
smu.source.sweeplinear("test", 1, 10, 10)
display.prompt(display.BUTTONS_YESNO, "Would you like to start the sweep now?")
sweepTest, result = display.waitevent()
if result == display.BUTTON_YES then
trigger.model.initiate()
end
display.prompt(display.BUTTONS_YESNO, "Would you like to switch to the Graph screen?")
promptID, result = display.waitevent()
if result == display.BUTTON_YES then
display.changescreen(display.SCREEN_GRAPH)
end

-- script.load()
test8 = script.load("/usb1/testSetup.tsp")

-- script.catalog()
for name in script.catalog() do
print(name)
end

-- script.delete()
script.delete("test8")

-- scriptVar.source
test7 = script.load("")
print(test7.source)

-- display.lightstate
display.lightstate = display.STATE_LCD_50

-- status.preset()
status.preset()

-- buffer.delete()
buf400 = buffer.make(400)
smu.measure.read(buf400)
printbuffer(1, buf400.n, buf400.relativetimestamps)
buffer.delete(buf400)
collectgarbage()

-- trigger.timer[N].start.seconds
trigger.timer[1].start.seconds = localnode.gettime() + 30
trigger.timer[1].enable = trigger.ON

-- trigger.timer[N].start.fractionalseconds
trigger.timer[1].start.fractionalseconds = 0.4

-- reset()
reset(true)

-- bufferVar.sourcestatuses
reset()
testData = buffer.make(50)
smu.source.output = smu.ON
trigger.model.load("SimpleLoop", 2, 0, testData)
trigger.model.initiate()
waitcomplete()
printbuffer(1, 2, testData.sourcestatuses)

-- tspnet.termination()
deviceID = tspnet.connect("192.0.2.1")
if deviceID then
tspnet.termination(deviceID, tspnet.TERM_LF)
end

-- trigger.blender[N].stimulus[M]
digio.line[3].mode = digio.MODE_TRIGGER_IN
digio.line[5].mode = digio.MODE_TRIGGER_IN
trigger.digin[3].edge = trigger.EDGE_FALLING
trigger.digin[5].edge = trigger.EDGE_FALLING
trigger.blender[1].orenable = true
trigger.blender[1].stimulus[1] = trigger.EVENT_DIGIO3
trigger.blender[1].stimulus[2] = trigger.EVENT_DIGIO5

-- buffer.clearstats()
buffer.clearstats()

-- -- createconfigscript()
-- createconfigscript("myConfigurationScript")
-- reset()
-- myConfigurationScript()

-- localnode.password
localnode.password = "N3wpa55w0rd"

-- eventlog.post()
eventlog.clear()
eventlog.post("Results in \018", eventlog.SEV_ERROR)
print(eventlog.next())

-- file.usbdriveexists()
local response
local xMax = 10

for x = 1, xMax do
-- Make xMax readings and store them in defbuffer1.
smu.measure.read()
end

if (file.usbdriveexists() == 1) then
response = display.BUTTON_YES
else
response = display.input.prompt(display.BUTTONS_YESNO, "Insert a USB flash drive.\nPress Yes to write data or No to not write data.")
end

if (response == display.BUTTON_YES) then
if (file.usbdriveexists() == 1) then
FileNumber = file.open("/usb1/TenReadings.csv", file.MODE_WRITE)
file.write(FileNumber,"Reading,Seconds\n")

-- Print out the measured values in a two-column format.
print("\nIteration:\tReading:\tTime:\n")

for i = 1, xMax do
print(i, defbuffer1[i], defbuffer1.relativetimestamps[i])
file.write(FileNumber, string.format("%g, %g\r\n",defbuffer1.readings[i], defbuffer1.relativetimestamps[i]))
end
file.close(FileNumber)
else
response = display.input.prompt(display.BUTTONS_OK,
"No drive detected. Allow more time after inserting a drive.")
end
end

-- smu.source.userdelay[N]
smu.source.userdelay[1] = 5
trigger.model.setblock(1, trigger.BLOCK_SOURCE_OUTPUT, smu.ON)
trigger.model.setblock(2, trigger.BLOCK_DELAY_DYNAMIC, trigger.USER_DELAY_M1)
trigger.model.setblock(3, trigger.BLOCK_MEASURE_DIGITIZE)
trigger.model.setblock(4, trigger.BLOCK_SOURCE_OUTPUT, smu.OFF)
trigger.model.setblock(5, trigger.BLOCK_BRANCH_COUNTER, 10, 1)
trigger.model.initiate()

-- trigger.blender[N].wait()
digio.line[3].mode = digio.MODE_TRIGGER_IN
digio.line[5].mode = digio.MODE_TRIGGER_IN
trigger.digin[3].edge = trigger.EDGE_FALLING
trigger.digin[5].edge = trigger.EDGE_FALLING
trigger.blender[1].orenable = true
trigger.blender[1].stimulus[1] = trigger.EVENT_DIGIO3
trigger.blender[1].stimulus[2] = trigger.EVENT_DIGIO5
print(trigger.blender[1].wait(3))

-- trigger.model.load() - ConfigList
reset()
smu.source.configlist.create("SOURCE_LIST")
smu.measure.configlist.create("MEASURE_LIST")
smu.source.level = 1
smu.source.configlist.store("SOURCE_LIST")
smu.measure.range = 1e-3
smu.measure.configlist.store("MEASURE_LIST")
smu.source.level = 5
smu.source.configlist.store("SOURCE_LIST")
smu.measure.range = 10e-3
smu.measure.configlist.store("MEASURE_LIST")
smu.source.level = 10
smu.source.configlist.store("SOURCE_LIST")
smu.measure.range = 100e-3
smu.measure.configlist.store("MEASURE_LIST")
trigger.model.load("ConfigList", "MEASURE_LIST", "SOURCE_LIST")
trigger.model.initiate()

-- trigger.model.load() - Empty
trigger.model.load("Empty")
print(trigger.model.getblocklist())

-- trigger.model.load() - LogicTrigger
trigger.model.load("LogicTrigger", 1, 2, 10, 0.001, defbuffer1)

-- trigger.model.load() — Simple Loop
reset()

--set up measure function
smu.measure.func = smu.FUNC_DC_CURRENT
smu.measure.terminals = smu.TERMINALS_REAR
smu.measure.autorange = smu.ON
smu.measure.nplc = 1

--set up source function
smu.source.func = smu.FUNC_DC_VOLTAGE
smu.source.ilimit.level = 0.1
smu.source.level = 20
smu.source.delay = 0.1
smu.source.highc = smu.OFF

--turn on output and initiate readings
smu.source.output = smu.ON
trigger.model.load("SimpleLoop", 200)
trigger.model.initiate()
waitcomplete()

--Parse index and data into three columns
print("Rdg #", "Time (s)", "Current (A)")
for i = 1, defbuffer1.n do
print(i, defbuffer1.relativetimestamps[i], defbuffer1[i])
end

--Discharge the capacitor to 0 V and turn off the output
smu.source.level = 0
delay(2)
smu.source.output = smu.OFF

-- trigger.BLOCK_LOG_EVENT
trigger.model.setblock(9, trigger.BLOCK_LOG_EVENT, trigger.LOG_INFO2, "Trigger model complete.")

-- trigger.BLOCK_NOP
trigger.model.setblock(4, trigger.BLOCK_NOP)

-- display.delete()
removePrompt3 = display.prompt(display.BUTTONS_NONE, "This prompt will disappear in 3 seconds")
delay(3)
display.delete(removePrompt3)

-- eventlog.suppress()
eventlog.suppress(-109)

-- display.input.number()
smu.source.func = smu.FUNC_DC_CURRENT
testcurrent = display.input.number("Enter a Test Current (0 to 1 A)", display.NFORMAT_PREFIX, 0, 0, 1)
smu.source.level = testcurrent

-- display.input.option()
optionID = display.input.option("Select an option", "Apple", "Orange", "Papaya", "Pineapple", "Blueberry", "Banana", "Grapes", "Peach", "Apricot", "Guava")
print(optionID)

-- display.input.prompt()
result = display.input.prompt(display.BUTTONS_YESNO, "Do you want to display the graph screen?")
if result == display.BUTTON_YES then
display.changescreen(display.SCREEN_GRAPH)
end

-- display.input.string()
value = display.input.string("Enter Test Name", display.SFORMAT_ANY)
print(value)

-- localnode.prompts4882
localnode.prompts4882 = localnode.DISABLE

-- trigger.BLOCK_RESET_BRANCH_COUNT
trigger.model.load("Empty")
trigger.model.setblock(1, trigger.BLOCK_BUFFER_CLEAR)
trigger.model.setblock(2, trigger.BLOCK_MEASURE_DIGITIZE)
trigger.model.setblock(3, trigger.BLOCK_BRANCH_COUNTER, 5, 2)
trigger.model.setblock(4, trigger.BLOCK_DELAY_CONSTANT, 1)
trigger.model.setblock(5, trigger.BLOCK_BRANCH_COUNTER, 3, 2)
trigger.model.setblock(6, trigger.BLOCK_RESET_BRANCH_COUNT, 3)
trigger.model.initiate()
waitcomplete()
print(defbuffer1.n)

-- trigger.model.load() - SimpleLoop
reset()

-- Set up measure function
smu.measure.func = smu.FUNC_DC_CURRENT
smu.terminals = smu.TERMINALS_REAR
smu.measure.autorange = smu.ON
smu.measure.nplc = 1

-- Set up source function
smu.source.func = smu.FUNC_DC_VOLTAGE
smu.source.ilimit.level = 0.1
smu.source.level = 20
smu.source.delay = 0.1
smu.source.highc = smu.OFF

-- Turn on output and initiate readings
smu.source.output = smu.ON
trigger.model.load("SimpleLoop", 200)
trigger.model.initiate()
waitcomplete()

-- Parse index and data into three columns
print("Rdg #", "Time (s)", "Current (A)")
for i = 1, defbuffer1.n do
print(i, defbuffer1.relativetimestamps[i], defbuffer1[i])
end

-- Discharge the capacitor to 0 V and turn off the output
smu.source.level = 0
delay(2)
smu.source.output = smu.OFF

-- trigger.model.load() - LoopUntilEvent
reset()

-- Set up measure function
smu.measure.func = smu.FUNC_DC_CURRENT

-- Initiate readings
trigger.model.load("LoopUntilEvent", trigger.EVENT_DISPLAY, 50)
trigger.model.initiate()

-- trigger.model.load() - GradeBinning
-- trigger.model.load() - SortBinning
-- bufferVar.extravalues
extBuffer = buffer.make(100, buffer.STYLE_WRITABLE_FULL)
buffer.write.format(extBuffer, buffer.UNIT_WATT, buffer.DIGITS_3_5,   buffer.UNIT_WATT, buffer.DIGITS_3_5)
buffer.write.reading(extBuffer, 1, 7)
buffer.write.reading(extBuffer, 2, 8)
buffer.write.reading(extBuffer, 3, 9)
buffer.write.reading(extBuffer, 4, 10)
buffer.write.reading(extBuffer, 5, 11)
buffer.write.reading(extBuffer, 6, 12)
printbuffer(1, 6, extBuffer.readings, extBuffer.units, extBuffer.extravalues,   extBuffer.units)

-- buffer.write.format()
extBuffer = buffer.make(100, buffer.STYLE_WRITABLE)
buffer.write.format(extBuffer, buffer.UNIT_WATT, buffer.DIGITS_3_5)
buffer.write.reading(extBuffer, 1)
buffer.write.reading(extBuffer, 2)
buffer.write.reading(extBuffer, 3)
buffer.write.reading(extBuffer, 4)
buffer.write.reading(extBuffer, 5)
buffer.write.reading(extBuffer, 6)
printbuffer(1, 6, extBuffer.readings, extBuffer.units)

extBuffer = buffer.make(100, buffer.STYLE_WRITABLE_FULL)
buffer.write.format(extBuffer, buffer.UNIT_WATT, buffer.DIGITS_3_5,   buffer.UNIT_WATT, buffer.DIGITS_3_5)
buffer.write.reading(extBuffer, 1, 7)
buffer.write.reading(extBuffer, 2, 8)
buffer.write.reading(extBuffer, 3, 9)
buffer.write.reading(extBuffer, 4, 10)
buffer.write.reading(extBuffer, 5, 11)
buffer.write.reading(extBuffer, 6, 12)
printbuffer(1, 6, extBuffer.readings, extBuffer.units, extBuffer.extravalues,   extBuffer.units)

-- buffer.write.reading()
extBuffer = buffer.make(100, buffer.STYLE_WRITABLE)
buffer.write.format(extBuffer, buffer.UNIT_WATT, buffer.DIGITS_3_5)
buffer.write.reading(extBuffer, 1)
buffer.write.reading(extBuffer, 2)
buffer.write.reading(extBuffer, 3)
buffer.write.reading(extBuffer, 4)
buffer.write.reading(extBuffer, 5)
buffer.write.reading(extBuffer, 6)
printbuffer(1, 6, extBuffer.readings, extBuffer.units)

extBuffer = buffer.make(100, buffer.STYLE_WRITABLE_FULL)
buffer.write.format(extBuffer, buffer.UNIT_WATT, buffer.DIGITS_3_5,   buffer.UNIT_WATT, buffer.DIGITS_3_5)
buffer.write.reading(extBuffer, 1, 7)
buffer.write.reading(extBuffer, 2, 8)
buffer.write.reading(extBuffer, 3, 9)
buffer.write.reading(extBuffer, 4, 10)
buffer.write.reading(extBuffer, 5, 11)
buffer.write.reading(extBuffer, 6, 12)
printbuffer(1, 6, extBuffer.readings, extBuffer.units, extBuffer.extravalues,   extBuffer.units)

-- bufferVar.startindex
test1 = buffer.make(100)
smu.measure.count = 6
smu.measure.read(test1)
print(test1.startindex, test1.endindex, test1.capacity)

-- bufferVar.endindex
test1 = buffer.make(100)
smu.measure.count = 6
smu.measure.read(test1)
print(test1.startindex, test1.endindex, test1.capacity)
smu.measure.read(test1)
print(test1.startindex, test1.endindex)

-- trigger.model.pause()
reset()
smu.measure.func = smu.FUNC_DC_VOLTAGE
trigger.model.setblock(1, trigger.BLOCK_BUFFER_CLEAR, defbuffer1)
trigger.model.setblock(2, trigger.BLOCK_DELAY_CONSTANT, 0)
trigger.model.setblock(3, trigger.BLOCK_MEASURE_DIGITIZE, defbuffer1, trigger.COUNT_INFINITE)
trigger.model.setblock(4, trigger.BLOCK_WAIT, trigger.EVENT_DISPLAY)
trigger.model.setblock(5, trigger.BLOCK_MEASURE_DIGITIZE, defbuffer1, trigger.COUNT_STOP)
trigger.model.setblock(6, trigger.BLOCK_NOTIFY, trigger.EVENT_NOTIFY1)
trigger.model.initiate()
trigger.model.pause()
delay(10)
trigger.model.resume()
waitcomplete()
print(defbuffer1.n)

-- trigger.model.resume()
reset()
smu.measure.func = smu.FUNC_DC_VOLTAGE
trigger.model.setblock(1, trigger.BLOCK_BUFFER_CLEAR, defbuffer1)
trigger.model.setblock(2, trigger.BLOCK_DELAY_CONSTANT, 0)
trigger.model.setblock(3, trigger.BLOCK_MEASURE_DIGITIZE, defbuffer1, trigger.COUNT_INFINITE)
trigger.model.setblock(4, trigger.BLOCK_WAIT, trigger.EVENT_DISPLAY)
trigger.model.setblock(5, trigger.BLOCK_MEASURE_DIGITIZE, defbuffer1, trigger.COUNT_STOP)
trigger.model.setblock(6, trigger.BLOCK_NOTIFY, trigger.EVENT_NOTIFY1)
trigger.model.initiate()
trigger.model.pause()
delay(10)
trigger.model.resume()
waitcomplete()
print(defbuffer1.n)

-- buffer.math()
reset()
mathExp = buffer.make(200, buffer.STYLE_FULL)
smu.measure.func = smu.FUNC_DC_VOLTAGE

buffer.math(mathExp, buffer.UNIT_NONE, buffer.EXPR_MULTIPLY)
for x = 1, 3 do
print("Reading: ", smu.measure.read(mathExp))
end

display.changescreen(display.SCREEN_READING_TABLE)

print("Extra value reading 1: ", mathExp.extravalues[1])
print("Extra value reading 2: ", mathExp.extravalues[2])
print("Extra value reading 3: ", mathExp.extravalues[3])

-- buffer.unit()
reset()
mathExp = buffer.make(200, buffer.STYLE_FULL)
smu.measure.func = smu.FUNC_DC_VOLTAGE
buffer.unit(buffer.UNIT_CUSTOM1, "fb")

buffer.math(mathExp, buffer.UNIT_CUSTOM1, buffer.EXPR_MULTIPLY)
for x = 1, 3 do
print("Reading "..x..":", smu.measure.read(mathExp))
end

display.changescreen(display.SCREEN_READING_TABLE)
for x = 1, 3 do
print("Extra value reading "..x..":", mathExp.extravalues[x])
end

-- bufferVar.extraformattedvalues
reset()
mathExp = buffer.make(400, buffer.STYLE_FULL)
smu.measure.func = smu.FUNC_DC_VOLTAGE
buffer.math(mathExp, buffer.UNIT_NONE, buffer.EXPR_MULTIPLY)
for x = 1, 3 do
print("Reading: ", smu.measure.read(mathExp))
end
display.changescreen(display.SCREEN_READING_TABLE)
print("Extra value reading 1: ", mathExp.extraformattedvalues[1])
print("Extra value reading 2: ", mathExp.extraformattedvalues[2])
print("Extra value reading 3: ", mathExp.extraformattedvalues[3])

-- bufferVar.extravalueunits
extBuffer = buffer.make(100, buffer.STYLE_WRITABLE_FULL)
buffer.write.format(extBuffer, buffer.UNIT_WATT, buffer.DIGITS_3_5,   buffer.UNIT_WATT, buffer.DIGITS_3_5)
buffer.write.reading(extBuffer, 1, 7)
buffer.write.reading(extBuffer, 2, 8)
buffer.write.reading(extBuffer, 3, 9)
buffer.write.reading(extBuffer, 4, 10)
buffer.write.reading(extBuffer, 5, 11)
buffer.write.reading(extBuffer, 6, 12)
printbuffer(1, 6, extBuffer.readings, extBuffer.extravalueunits)

-- display.activebuffer
buffer2 = buffer.make(20)
display.activebuffer = buffer2

-- buffer.save()
buffer.save(MyBuffer, "/usb1/myData.csv")

buffer.save(MyBuffer, "/usb1/myDataRel.csv", buffer.SAVE_RELATIVE_TIME)

buffer.save(defbuffer1, "/usb1/defbuf1data", buffer.SAVE_RAW_TIME)

-- trigger.continuous
trigger.continuous = trigger.CONT_OFF

-- smu.measure.autorangerebound
smu.measure.func = smu.FUNC_DC_CURRENT
smu.measure.autorange = smu.ON
smu.measure.autorangerebound = smu.ON

-- smu.interlock.enable
smu.interlock.enable = smu.ON

-- available()
print(available(gpib))

-- smu.measure.getattribute()
print(smu.measure.getattribute(smu.FUNC_DC_VOLTAGE, smu.ATTR_MEAS_RANGE))
print(smu.measure.getattribute(smu.FUNC_DC_VOLTAGE, smu.ATTR_MEAS_NPLC))
print(smu.measure.getattribute(smu.FUNC_DC_VOLTAGE, smu.ATTR_MEAS_DIGITS))

-- smu.measure.configlist.storefunc()
smu.measure.configlist.create("MyMeasList")
smu.measure.configlist.storefunc("MyMeasList", smu.FUNC_DC_VOLTAGE)


-- smu.source.configlist.storefunc()
smu.source.configlist.create("sourcelist")
smu.source.configlist.storefunc("sourcelist", smu.FUNC_DC_CURRENT)

-- smu.source.setattribute()
smu.source.setattribute(smu.FUNC_DC_CURRENT, smu.ATTR_SRC_RANGE, 0.007)
smu.source.setattribute(smu.FUNC_DC_CURRENT, smu.ATTR_SRC_DELAY, 0.35)
smu.source.setattribute(smu.FUNC_DC_CURRENT, smu.ATTR_SRC_LEVEL, 0.035)

-- smu.source.getattribute()
print(smu.source.getattribute(smu.FUNC_DC_CURRENT, smu.ATTR_SRC_DELAY))

-- smu.measure.setattribute()
smu.measure.setattribute(smu.FUNC_DC_VOLTAGE, smu.ATTR_MEAS_REL_LEVEL, 0.55)
smu.measure.setattribute(smu.FUNC_DC_VOLTAGE, smu.ATTR_MEAS_LIMIT_HIGH_1, 0.64)
smu.measure.setattribute(smu.FUNC_DC_VOLTAGE, smu.ATTR_MEAS_LIMIT_LOW_1, 0.32)
smu.measure.configlist.create("MyMeasList")
smu.measure.configlist.storefunc("MyMeasList", smu.FUNC_DC_VOLTAGE)

