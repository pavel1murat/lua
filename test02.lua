#!/usr/bin/env lua

TIME_OFFSET_MAPS = { "compressDigiMCs:protonTimeMap", "compressDigiMCs:muonTimeMap" }

StntupleModuleFclDefaults = {
    interactiveMode = -55,

    TAnaDump = { 
	timeOffsetMaps  = TIME_OFFSET_MAPS,
	printUtils      = { 
	    mcTruth = 1
	}
    },

    debugBits = { 
	x = 1  
    }
}

StntupleModuleA = {}
StntupleModuleA['StntupleModuleFclDefaults'] =  StntupleModuleFclDefaults

table.insert(StntupleModuleA, {blin = -5})


-- #
----- printing 

print ('table  :',StntupleModuleFclDefaults.TAnaDump.timeOffsetMaps[1])
print ('mcTruth:',StntupleModuleFclDefaults.TAnaDump.printUtils.mcTruth)


StntupleModuleFclDefaults.TAnaDump.printUtils.mcTruth = -89

print ("StntupleModuleA.blin:", StntupleModuleA.blin)

print ("assignment works:", StntupleModuleFclDefaults.TAnaDump.printUtils.mcTruth)

print ("StntupleModuleA.interactiveMode:", StntupleModuleA[1].interactiveMode)
StntupleModuleA.blin = -3
print ("StntupleModuleA.blin:", StntupleModuleA.blin)

print ("StntupleModuleA.interactiveMode:", StntupleModuleA['interactiveMode'])

print ('-------------------- StntupleModuleA')

for k, v in pairs( StntupleModuleA) do 
  print(k, v) 
end
