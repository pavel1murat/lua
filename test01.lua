#!/usr/bin/env lua

TIME_OFFSET_MAPS = { "compressDigiMCs:protonTimeMap", "compressDigiMCs:muonTimeMap" }

StntupleModuleFclDefaults = {
    interactiveMode = 0,

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

-- --- printing ..  remember lua indexing runs from 1....

print ('table[0]  :',StntupleModuleFclDefaults.TAnaDump.timeOffsetMaps[1])
print ('table[1]  :',StntupleModuleFclDefaults.TAnaDump.timeOffsetMaps[2])

print ('mcTruth:',StntupleModuleFclDefaults.TAnaDump.printUtils.mcTruth)


StntupleModuleFclDefaults.TAnaDump.printUtils.mcTruth = -89


print ("assignment works:", StntupleModuleFclDefaults.TAnaDump.printUtils.mcTruth)
