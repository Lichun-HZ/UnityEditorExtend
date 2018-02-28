-- EMERGENT GAME TECHNOLOGIES PROPRIETARY INFORMATION
--
-- This software is supplied under the terms of a license agreement or
-- nondisclosure agreement with Emergent Game Technologies and may not
-- be copied or disclosed except in accordance with the terms of that
-- agreement.
--
--      Copyright (c) 1996-2007 Emergent Game Technologies.
--      All Rights Reserved.
--
-- Emergent Game Technologies, Chapel Hill, North Carolina 27517
-- http://www.emergent.net
-----------------------------------------------------------------------------

	global strNone = "NONE"
	global strBlankSeq = "EMPTY_SEQUENCE"
	global AllActorRoots = #()
	global ActorRoot = undefined
	global AccumRoot = undefined
	global LayerRoot1 = undefined
	global AllLayerRoots = #()
	global lastTime = 0.0
	global strAccum = "KFAccumRoot"
	global ActiveSequence = undefined
	global ActiveSequenceEnd = undefined
	global ActiveNoteTrack = undefined
	global ActiveMorphKeyTime = undefined
	global ActiveMorphKeyText = undefined
	global ActiveInfoKeyTime = undefined
	global ActiveInfoKeyText = undefined

	include "AnimationHelpers.ms"

-- 	rollout NiActorSeqPredefineRollout "Predefine Sequence"  
-- 	(
-- 		group "Morph Tags"
-- 		(
-- 			dropdownlist ddlMorphTags "Morph Tags:" enabled:false
-- 			edittext editMorphText "Key Text:" text:"" enabled:false
-- 		)
-- 	)
	
	rollout NiActorSeqTagsRollout "Sequence Tags"  
	(
		group "Morph Tags"
		(
			dropdownlist ddlMorphTags "Morph Tags:" enabled:false
			edittext editMorphText "Key Text:" text:"" enabled:false
			spinner spnMorphTagFrame "Tag Time: "  range:[0,99999,0] type:#integer align:#left width:132 enabled:false 
			button btnAddMorphTag "Add Morph Tag" enabled:false width:132
			button btnRemMorphTag "Remove Morph Tag" enabled:false width:132

		)
		
		group "Extra Info Tags"
		(
			dropdownlist ddlInfoTags "Extra Info Tags:" enabled:false
			edittext editInfoText "Key Text:" text:"" enabled:false
			spinner spnInfoTagFrame "Tag Time: "  range:[0,99999,0] type:#integer align:#left width:132 enabled:false 
			button btnAddInfoTag "Add Info Tag" enabled:false width:132
			button btnRemInfoTag "Remove Info Tag" enabled:false width:132
		)
		
		function GetActiveInfoKey =
		(
				for trackTime = ActiveSequence.time to ActiveSequenceEnd.time do 
				(
					TempInfoKey = undefined 
					TempInfoKeys = GetInfoKey ActiveNoteTrack trackTime 
					
					if TempInfoKeys != undefined and TempInfoKeys.count > 0 do
					(
						for i = 1 to TempInfoKeys.count do
						(
							TempInfoKey = TempInfoKeys[i]
							if ActiveInfoKeyTime == TempInfoKey.time and ActiveInfoKeyText == TempInfoKey.value then return TempInfoKey
						)
					)
					
				)
				
				return undefined
		)
		
		function GetActiveMorphKey =
		(
				for trackTime = ActiveSequence.time to ActiveSequenceEnd.time do 
				(
					TempMorphKey = undefined 
					TempMorphKeys = GetMorphKey ActiveNoteTrack trackTime 
					
					if TempMorphKeys != undefined and TempMorphKeys.count > 0 do
					(
						for i = 1 to TempMorphKeys.count do
						(
							TempMorphKey = TempMorphKeys[i]
							if ActiveMorphKeyTime == TempMorphKey.time and ActiveMorphKeyText == TempMorphKey.value then return TempMorphKey
						)
					)
					
				)
				
				return undefined
		)
				
		function UpdateSequenceTagsUI =
		(
			bAdded = false
			if LayerRoot1 != undefined and ActiveNoteTrack != undefined and ActiveSequence != undefined do
			(
				btnAddInfoTag.enabled = true
				btnAddMorphTag.enabled = true
			
				ddlInfoTags.enabled = false
				ddlMorphTags.enabled = false

				AllSequenceMorphTags = #()
				AllSequenceInfoTags = #()
				MorphTagSelectedIndex = 1
				InfoTagSelectedIndex = 1
				
				for trackTime = ActiveSequence.time to ActiveSequenceEnd.time do 
				(
					TempMorphKey = undefined 
					TempMorphKeys = GetMorphKey ActiveNoteTrack trackTime 
					
					if TempMorphKeys != undefined and TempMorphKeys.count > 0 do
					(
						for i = 1 to TempMorphKeys.count do
						(
							TempMorphKey = TempMorphKeys[i]
							append AllSequenceMorphTags (TempMorphKey.value as string)
							if ActiveMorphKeyTime == undefined do
							( 
								ActiveMorphKeyTime = TempMorphKey.time
								ActiveMorphKeyText = TempMorphKey.value
							)
							
							if ActiveMorphKeyTime == TempMorphKey.time and ActiveMorphKeyText == TempMorphKey.value do
							(
								MorphTagSelectedIndex = AllSequenceMorphTags.count
								print "MorphTagSelectedIndex = "
								print MorphTagSelectedIndex
								print "\n"
							)
						)
					)
					
					TempInfoKey = undefined 
					TempInfoKeys = GetInfoKey ActiveNoteTrack trackTime 
					
					if TempInfoKeys != undefined and TempInfoKeys.count > 0 do
					(
						for i = 1 to TempInfoKeys.count do
						(
							TempInfoKey = TempInfoKeys[i]
							append AllSequenceInfoTags (TempInfoKey.value as string)
							if ActiveInfoKeyTime == undefined do 
							(
								ActiveInfoKeyTime = TempInfoKey.time
								ActiveInfoKeyText = TempInfoKey.value
							)
							
							if ActiveInfoKeyText == TempInfoKey.value and ActiveInfoKeyTime == TempInfoKey.time do
							( 
								InfoTagSelectedIndex = AllSequenceInfoTags.count 
								print "InfoTagSelectedIndex = "
								print InfoTagSelectedIndex
								print "\n"
							)
						)
					)
				)
				
				if AllSequenceMorphTags.count > 0 do 
				(
					ddlMorphTags.items = AllSequenceMorphTags
					ddlMorphTags.enabled = true
					ddlMorphTags.selection = MorphTagSelectedIndex
				)
				if AllSequenceInfoTags.count > 0 do 
				(
					ddlInfoTags.items = AllSequenceInfoTags
					ddlInfoTags.enabled = true
					ddlInfoTags.selection = InfoTagSelectedIndex
				)
				
				if ActiveMorphKeyTime != undefined do
				(
					editMorphText.enabled = true
					value = ""
					if ActiveMorphKeyText.count > 7 then
						value = substring ActiveMorphKeyText 8 -1
					
					editMorphText.text = value
					spnMorphTagFrame.enabled = true
					spnMorphTagFrame.value = ActiveMorphKeyTime
					btnRemMorphTag.enabled = true
				)
				if ActiveMorphKeyTime == undefined do
				(
					editMorphText.enabled = false
					editMorphText.text = ""
					spnMorphTagFrame.enabled = false
					spnMorphTagFrame.value = slidertime
					btnRemMorphTag.enabled = false
				)
				
				if ActiveInfoKeyTime != undefined do
				(
					editInfoText.enabled = true
					value = ActiveInfoKeyText								
					editInfoText.text = value
					spnInfoTagFrame.enabled = true
					spnInfoTagFrame.value = ActiveInfoKeyTime
					btnRemInfoTag.enabled = true
				)
				if ActiveInfoKeyTime == undefined do
				(
					editInfoText.enabled = false
					editInfoText.text = ""
					spnInfoTagFrame.enabled = false
					spnInfoTagFrame.value = slidertime
					btnRemInfoTag.enabled = false
				)

				bAdded = true
			)
			if bAdded == false do
			(
				editMorphText.enabled = false
				editMorphText.text = ""
				editInfoText.enabled = false
				editInfoText.text = ""
				btnAddMorphTag.enabled = false
				btnAddInfoTag.enabled = false
				btnRemMorphTag.enabled = false
				btnRemInfoTag.enabled = false
				spnMorphTagFrame.enabled = false
				spnMorphTagFrame.value = slidertime
				spnInfoTagFrame.enabled = false
				spnInfoTagFrame.value = slidertime
			)
		)
		
		on ddlInfoTags selected index do 
		(
			iCount = 0
			for trackTime = ActiveSequence.time to ActiveSequenceEnd.time do 
			(
				TempInfoKeys = GetInfoKey ActiveNoteTrack trackTime 
				if TempInfoKeys != undefined and TempInfoKeys.count > 0 do
				(
					for i = 1 to TempInfoKeys.count do
					(
						iCount = iCount + 1
						if iCount == index do
						(
							ActiveInfoKeyTime = TempInfoKeys[i].time
							ActiveInfoKeyText = TempInfoKeys[i].value
							UpdateSequenceTagsUI()
							return ok
						)
					)
				)				
			)
		) 

		on ddlMorphTags selected index do 
		(
			iCount = 0
			for trackTime = ActiveSequence.time to ActiveSequenceEnd.time do 
			(
				TempMorphKeys = GetMorphKey ActiveNoteTrack trackTime 
				if TempMorphKeys != undefined and TempMorphKeys.count > 0 do
				(
					for i = 1 to TempMorphKeys.count do
					(
						iCount = iCount + 1
						if iCount == index do 
						(
							ActiveMorphKeyTime = TempMorphKeys[i].time
							ActiveMorphKeyText = TempMorphKeys[i].value
							UpdateSequenceTagsUI()
							return ok
						)
					)
				)				
			)
		) 
		
		on editMorphText changed text do
		(
			if text == "" or text == undefined do
			(
				text = "_"
			)
			if ActiveMorphKeyText != undefined do
			(
				value = "morph: " + text
				TempMorphKeys = GetMorphKey ActiveNoteTrack value 
				if TempMorphKeys != undefined and TempMorphKeys.count > 0 do
				(	
					for key in TempMorphKeys do
					(
						if key.value == value do
						(
							messageBox "Unable to set the input text on this key!\nA key with the same value already exists at this frame!"
							return ok
						)
					)
				)
				
				ActiveMorphKey = GetActiveMorphKey()
				ActiveMorphKeyText = value
				ActiveMorphKey.value = value
				UpdateSequenceTagsUI()
			)
		)
		
		on spnMorphTagFrame changed value do
		(
			bPassed = false
			if value  > ActiveSequence.time and value < ActiveSequenceEnd.time do
			(
				if ActiveMorphKeyText != undefined do
				(
					TempMorphKeys = GetMorphKey ActiveNoteTrack value 
					if TempMorphKeys != undefined and TempMorphKeys.count > 0 do
					(	
						for key in TempMorphKeys do
						(
							if key.value == ActiveMorphKeyText do
							(
								messageBox "Unable to move key to the selected frame!\nA key with the same value already exists at this frame!"
								return ok
							)
						)
					)
					
					bPassed = true
					seqIndex = GetStartKeyIndex ActiveNoteTrack ActiveSequence
					ActiveMorphKey = GetActiveMorphKey()
					ActiveMorphKey.time = value
					ActiveMorphKeyTime = value
				    ActiveSequence = GetStartKey ActiveNoteTrack seqIndex
				    ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
					UpdateSequenceTagsUI()
				)
			)
			
			if not bPassed do
			(
				messageBox "You cannot set the morph tag time to this value.\nThe time must be between the current sequence start and end times. " 
			)
			
		)
		
		on btnAddMorphTag pressed do
		(
			bPassed = false
			if sliderTime >= ActiveSequence.time and sliderTime <= ActiveSequenceEnd.time do
			(
				value = "unknown"
				TempMorphKeys = GetMorphKey ActiveNoteTrack sliderTime 
				if TempMorphKeys != undefined and TempMorphKeys.count > 0 do
				(	
					unknownCount = 0
					for key in TempMorphKeys do
					(
						foundUnknown = findstring key.value "unknown"
						if foundUnknown != undefined do
						(		
							unknownCount = unknownCount + 1					
						)
						value = value + (unknownCount as string)
					)
				)
				
				bPassed = true
				
				seqIndex = GetStartKeyIndex ActiveNoteTrack ActiveSequence
				ActiveMorphKey = CreateNoteKey ActiveNoteTrack slidertime
				ActiveSequence = GetStartKey ActiveNoteTrack seqIndex
				ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
				ActiveMorphKey.value = "morph: " + value
				ActiveMorphKeyTime = sliderTime
				ActiveMorphKeyText = ActiveMorphKey.value
				UpdateSequenceTagsUI()
			)

			if not bPassed do
			(
				messageBox "You cannot add a morph tag now.\nThe time slider must be between the current sequence start and end times. " 
			)
		)
		
		on btnRemMorphTag pressed do
		(
			nt = ActiveNoteTrack
			index = 0
			iCount = NiGetNoteKeyCount nt
			print iCount
			for i = 1 to iCount do
			(
				key = nt.keys[i]
				if key.time == ActiveMorphKeyTime and key.value == ActiveMorphKeyText do
				(
					foundMorph = findstring key.value "morph: "
					if foundMorph != undefined and foundMorph == 1 do
					(
						index = i
						exit
					)
				)
			)
			if index != 0 do
			(
    			seqIndex = GetStartKeyIndex ActiveNoteTrack ActiveSequence
				deletenotekey ActiveNoteTrack.keys index
				ActiveMorphKeyTime = undefined
				ActiveMorphKeyText = undefined
				ActiveSequence = GetStartKey ActiveNoteTrack seqIndex
				ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
				UpdateSequenceTagsUI()
			)
		)
		
		on editInfoText changed text do
		(
			if text == "" or text == undefined do
			(
				text = "_"
			)

			foundStart = findString text "start"
			if foundStart == 1 then
			(
				text = replace text 1 5 "begin"
			)
			
			foundMorph = findString text "morph: "
			if foundMorph == 1 then
			(
				text = replace text 1 7 "morph"
			)
			
			foundEnd = findString text "end"
			if foundEnd == 1 then
			(
				text = replace text 1 3 "finish"
			)
			
			if ActiveInfoKeyTime != undefined do
			(
				value = text
				TempInfoKeys = GetInfoKey ActiveNoteTrack value 
				if TempInfoKeys != undefined and TempInfoKeys.count > 0 do
				(	
					for key in TempInfoKeys do
					(
						if key.value == value do
						(
							messageBox "Unable to set the input text on this key!\nA key with the same value already exists at this frame!"
							return ok
						)
					)
				)
				ActiveInfoKey = GetActiveInfoKey()
				ActiveInfoKey.value = value
				ActiveInfoKeyText = value
				
				UpdateSequenceTagsUI()
			)
		)
		
		on spnInfoTagFrame changed value do
		(
			bPassed = false
			if value  > ActiveSequence.time and value < ActiveSequenceEnd.time do
			(
				if ActiveInfoKeyTime != undefined do
				(
					TempInfoKeys = GetInfoKey ActiveNoteTrack value 
					if TempInfoKeys != undefined and TempInfoKeys.count > 0 do
					(	
						for key in TempInfoKeys do
						(
							if key.value == ActiveInfoKeyText do
							(
								messageBox "Unable to move key to the selected frame!\nA key with the same value already exists at this frame!"
								return ok
							)
						)
					)
					bPassed = true
					seqIndex = GetStartKeyIndex ActiveNoteTrack ActiveSequence
				    ActiveInfoKey = GetActiveInfoKey()
					ActiveInfoKey.time = value
					ActiveInfoKeyTime = value
					ActiveSequence = GetStartKey ActiveNoteTrack seqIndex
				    ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
					UpdateSequenceTagsUI()
				)
			)
			
			if not bPassed do
			(
				messageBox "You cannot set the info tag time to this value.\nThe time must be between the current sequence start and end times. " 
			)
			
		)
		
		on btnAddInfoTag pressed do
		(
			bPassed = false
			if sliderTime >= ActiveSequence.time and sliderTime <= ActiveSequenceEnd.time do
			(
				keyvalue = "unknown"
				TempInfoKeys = GetInfoKey ActiveNoteTrack sliderTime 
				if TempInfoKeys != undefined and TempInfoKeys.count > 0 do
				(	
					unknownCount = 0
					for key in TempInfoKeys do
					(
						foundUnknown = findstring key.value "unknown"
						if foundUnknown != undefined do
						(		
							unknownCount = unknownCount + 1					
						)
					)
					keyvalue = keyvalue + (unknownCount as string)
				)
				
				bPassed = true
				seqIndex = GetStartKeyIndex ActiveNoteTrack ActiveSequence
				ActiveInfoKey = CreateNoteKey ActiveNoteTrack slidertime
				ActiveSequence = GetStartKey ActiveNoteTrack seqIndex
				ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
			    ActiveInfoKey.value = keyvalue
				ActiveInfoKeyTime = sliderTime
				ActiveInfoKeyText = ActiveInfoKey.value
				UpdateSequenceTagsUI()
			)
			
			if not bPassed do
			(
				messageBox "You cannot add an info tag now.\nThe time slider must be between the current sequence start and end times. " 
			)
		)
		
		on btnRemInfoTag pressed do
		(
			nt = ActiveNoteTrack
			index = 0
			iCount = NiGetNoteKeyCount nt
			print iCount
			for i = 1 to iCount do
			(
				key = nt.keys[i]
				if key.time == ActiveInfoKeyTime and key.value == ActiveInfoKeyText do
				(
					index = i
					exit
				)
			)
			if index != 0 do
			(
			    seqIndex = GetStartKeyIndex ActiveNoteTrack ActiveSequence
				deletenotekey ActiveNoteTrack.keys index
				ActiveSequence = GetStartKey ActiveNoteTrack seqIndex
				ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
				ActiveInfoKeyTime = undefined
				ActiveInfoKeyText = undefined
				UpdateSequenceTagsUI()
			)
		)

		on NiActorSeqTagsRollout open do
		(
			UpdateSequenceTagsUI()
		)
	)

	function IsTopLevelSequence =
	(
		if AccumRoot != undefined and LayerRoot1 == ActorRoot and ActorRoot != undefined do
		(
			return true
		)
			
		return false
	)
	
	rollout NiActorAccumulationRollout "Sequence Accumulation"
	(
		group "Sequence Accumulation"
		(
			checkbox cbAccumRots "Accumulate Rotations" offset:[0, 0] align:#left enabled:false
			dropdownlist ddAccumRots "" items:#("X Axis", "Y Axis", "Z Axis", "All Axes") offset:[15, 0] selection:4 enabled:false align:#left width:120
			dropdownlist ddFront "Actor Faces:" items:#("X Axis", "Negative X Axis", "Y Axis", "Negative Y Axis") selection:1 offset:[15,0] width:120 enabled:false
			checkbox cbAccumTrans "Accumulate Translations" offset:[0, 6] align:#left enabled:false
			checkbox cbAccumXTrans "X Axis" offset:[15, 0] align:#left enabled:false
			checkbox cbAccumYTrans "Y Axis" offset:[15, 0] align:#left enabled:false
			checkbox cbAccumZTrans "Z Axis" offset:[15, 0] align:#left enabled:false
			
		)
		
		function UpdateAccumulationGroupUI =
		(
			bFixed = false
			if IsTopLevelSequence() and ActiveSequence != undefined do
			(
				bFixed = true
	 			local strTrans = GetSequenceAccumTrans ActiveSequence 
				strTrans = uppercase strTrans
				local strRots = GetSequenceAccumRot ActiveSequence
				strRots = uppercase strRots
				local strFront = GetSequenceFront ActiveSequence
				strFront = uppercase strFront
				
				
				cbAccumRots.enabled = true
				if strRots == "NONE" then 
					cbAccumRots.checked = false 
				else 
					cbAccumRots.checked = true
				
				ddAccumRots.enabled = cbAccumRots.checked
				
				if strRots == "X" then ddAccumRots.selection = 1 
				if strRots == "Y" then ddAccumRots.selection = 2
				if strRots == "Z" then ddAccumRots.selection = 3
				if strRots == "ALL" then ddAccumRots.selection = 4
 
				cbAccumTrans.enabled = true
				if strTrans == "NONE" then 
					cbAccumTrans.checked = false 
				else 
					cbAccumTrans.checked = true
				
				foundX = findstring strTrans "X"
				foundY = findstring strTrans "Y"
				foundZ = findstring strTrans "Z"

				if foundX != undefined then 
					cbAccumXTrans.checked = true 
				else 
					cbAccumXTrans.checked = false
				if foundY != undefined then 
					cbAccumYTrans.checked = true 
				else 
					cbAccumYTrans.checked = false
				if foundZ != undefined then 
					cbAccumZTrans.checked = true 
				else 
					cbAccumZTrans.checked = false
				
				if strTrans == "ALL" do 
				(
					cbAccumXTrans.checked = true
					cbAccumYTrans.checked = true
					cbAccumZTrans.checked = true
				)
				
				if cbAccumTrans.checked do
				(
					cbAccumXTrans.enabled = true
					cbAccumYTrans.enabled = true
					cbAccumZTrans.enabled = true
				)
				if not cbAccumTrans.checked do
				(
					cbAccumXTrans.enabled = false
					cbAccumYTrans.enabled = false
					cbAccumZTrans.enabled = false
				)
				
				if strRots == "NONE" then ddFront.enabled = false
				if strRots == "X" then ddFront.enabled = false 
				if strRots == "Y" then ddFront.enabled = false
				if strRots == "Z" then ddFront.enabled = true 
				if strRots == "ALL" then ddFront.enabled = true
					
				if ddFront.enabled == true do
				(
					if strFront == "X" then ddFront.selection = 1
					if strFront == "NEGX" then ddFront.selection = 2
					if strFront == "Y" then ddFront.selection = 3
					if strFront == "NEGY" then ddFront.selection = 4
				)
			)	
			if bFixed == false do
			(
				cbAccumRots.enabled = false
				cbAccumRots.checked = false
				cbAccumTrans.enabled = false
				cbAccumTrans.checked = false
				cbAccumXTrans.enabled = false
				cbAccumXTrans.checked = false
				cbAccumYTrans.enabled = false
				cbAccumYTrans.checked = false
				cbAccumZTrans.enabled = false
				cbAccumZTrans.checked = false
				ddAccumRots.enabled = false
				ddFront.enabled = false	
			)
			
			
			NiActorSeqTagsRollout.UpdateSequenceTagsUI()
		)
					
		on cbAccumRots changed state do
		(
			print "cbAccumRots changed state..."
			items = filterstring ActiveSequence.value " "

			value = ""
			strRots = "none"
			if cbAccumRots.checked == true do
			(
				strRots = "all"
			)

			bAdded = false
			ignoreindex = 0
			for i = 1 to items.count do
			(
				item = items[i]
				bAppend = true
				if (EqualsNoCase item "-ar") do
				(
					bAppend = false 
					value = value + "-ar " + strRots + " "
					bAdded = true 
					ignoreindex = i + 1
				)
				if i == ignoreindex then continue

				if bAppend == true then value = value + item + " "
			)
			
			if bAdded == false then 
				value = value + "-ar " + strRots + " -front x "
			
			print value	
			ActiveSequence.value = value	
			UpdateAccumulationGroupUI()	
		)
		
		on ddAccumRots selected item do
		(
			items = filterstring ActiveSequence.value " "
			strRots = "none"
			
			if item == 1 then strRots = "x"
			if item == 2 then strRots = "y"
			if item == 3 then strRots = "z"			
			if item == 4 then strRots = "all"
			
			ignoreindex = 0
			value = ""
			for i = 1 to items.count do
			(
				item = items[i]
				bAppend = true
				if (EqualsNoCase item "-ar") do
				(
					bAppend = false 
					value = value + " -ar " + strRots + " "
					bAdded = true 
					ignoreindex = i + 1
				)
				if i == ignoreindex then continue
				if bAppend == true then value = value + item + " "
			)
			
			ActiveSequence.value = value
			UpdateAccumulationGroupUI()
		)
		
		on cbAccumTrans changed state do
		(
			print "cbAccumTrans changed state..."
			items = filterstring ActiveSequence.value " "

			value = ""
			strTrans = "none"
			if cbAccumTrans.checked == true do
			(
				strTrans = "xy"
			)
			print strTrans
			
			bAdded = false
			ignoreindex = 0
			for i = 1 to items.count do
			(
				item = items[i]
				bAppend = true
				if (EqualsNoCase item "-at") do
				(
					bAppend = false 
					value = value + " -at " + strTrans + " "
					bAdded = true 
					ignoreindex = i + 1
				)
				if i == ignoreindex then continue
				
				if bAppend == true then value = value + item + " "
			)
			
			if bAdded == false and cbAccumTrans.checked == false then 
				value = value + " -at none " 
			if bAdded == false and cbAccumTrans.checked == true then
				value = value + " -at " + strTrans + " "
			
			print value	
			ActiveSequence.value = value	
			UpdateAccumulationGroupUI()		
		)

		function UpdateTransAccumFlags =
		(
			items = filterstring ActiveSequence.value " "
			strTrans = ""
			
			if cbAccumXTrans.checked then strTrans = strTrans + "x"
			if cbAccumYTrans.checked then strTrans = strTrans + "y"
			if cbAccumZTrans.checked then strTrans = strTrans + "z"
			
			if strTrans == "" then strTrans = "none"
			
			ignoreindex = 0
			value = ""
			for i = 1 to items.count do
			(
				item = items[i]
				bAppend = true
				if (EqualsNoCase item "-at") do
				(
					bAppend = false 
					value = value + " -at " + strTrans + " "
					bAdded = true 
					ignoreindex = i + 1
				)
				if i == ignoreindex then continue
				if bAppend == true then value = value + item + " "
			)
			
			ActiveSequence.value = value
			UpdateAccumulationGroupUI()
		)
		
		on cbAccumXTrans changed state do
		(
			UpdateTransAccumFlags()
		)
		
		on cbAccumYTrans changed state do
		(
			UpdateTransAccumFlags()
		)
		
		on cbAccumZTrans changed state do
		(
			UpdateTransAccumFlags()
		)
		
		on ddFront selected item do
		(
			items = filterstring ActiveSequence.value " "
			strFront = ""
			
			if item == 1 then strFront = "x"
			if item == 2 then strFront = "negx"
			if item == 3 then strFront = "y"
			if item == 4 then strFront = "negy"
			
			ignoreindex = 0
			value = ""
			bAdded = false
			for i = 1 to items.count do
			(
				myitem = items[i]
				bAppend = true
				if (EqualsNoCase myitem "-front") do
				(
					bAppend = false 
					value = value + " -front " + strFront + " "
					bAdded = true 
					ignoreindex = i + 1
				)
				if i == ignoreindex then continue
				if bAppend == true then value = value + myitem + " "
			)


			if bAdded == false then value = value + " -front " + strFront + " "		
			ActiveSequence.value = value
		)
		
		on NiActorAccumulationRollout open do
		(
			UpdateAccumulationGroupUI()
		)
	)

	rollout NiActorSequenceRollout "Active Sequence" width:162 height:531
	(
		GroupBox grp1 "Sequence" pos:[1,-1] width:162 height:529
		button btnLoadAnimation "Load" pos:[5,44] width:40 height:21 enabled:false across:3
		button btnSaveAnimation "Save" pos:[48,44] width:40 height:21 enabled:false
		dropdownList cbPredefinedType "类型" pos:[91,25] width:68 height:41 items:#("英雄", "BOSS", "小怪", "宠物", "坐骑", "建筑", "树", "创建界面") selection:1
		--button btnAddName "<+" pos:[74,121] width:20 height:21 enabled:false
		button btnAddPredefinedSeq "<<" pos:[74,151] width:20 height:21 enabled:false
		listbox lbpredefinedSeq "预定义动作表: " pos:[96,73] width:64 height:9 enabled:true
--			dropdownlist  ddlSequences "Sequences:" align:#left enabled:false width:132 height:10
		label lblSeqName "Active Sequence Name:" pos:[13,229] width:116 height:13 enabled:false
		edittext editSeqName "" pos:[9,244] width:143 height:17 enabled:false
		label lblSeqCount "Sequence 0 of 0" pos:[13,275] width:79 height:13 enabled:false
		checkbox cbLooping "Loop Sequence" pos:[13,298] width:100 height:15 enabled:false
		spinner spnStartFrame "Start Frame: " pos:[20,317] width:140 height:16 enabled:false range:[-99999,99999,0] type:#integer
		spinner spnEndFrame "End Frame: " pos:[20,339] width:140 height:16 enabled:false range:[-99999,99999,0] type:#integer
			
		button btnRecordStartFrame "Start Now" pos:[15,360] width:65 height:21 enabled:false across:2
		button btnRecordEndFrame "End Now" pos:[83,360] width:65 height:21 enabled:false across:2

		button btnPrev "Previous" pos:[15,386] width:65 height:21 enabled:false across:2
		button btnNext "Next" pos:[83,386] width:65 height:21 enabled:false across:2
			
--			button btnMakeSpanFit "Make Time Range Fit" width:132 enabled:false
		button btnCreate "Append New Sequence" pos:[15,412] width:132 height:21 enabled:false
		button btnPrepend "Prepend New Sequence" pos:[15,438] width:132 height:21 enabled:false
		button btnDestroy "Delete Current Sequence" pos:[15,464] width:132 height:21 enabled:false
			
		label lblMovePre "平移选中动作时间:" pos:[5,492] width:58 height:28 enabled:false across:4
		edittext editMovePre "" pos:[66,492] width:35 height:17 enabled:false
		label lblMovePreFrame "帧" pos:[104,492] width:12 height:13 enabled:false
		button btnMovePre "确定" pos:[119,490] width:40 height:21 enabled:false 
 
 
 
 
 
 
		--MultiListBox lbactorSeq "动作列表: " across:4 items:#() height:10 width:70 enabled:false
		multiListBox lbactorSeq "动作列表" pos:[5,73] width:67 height:9 enabled:false across:4
 
				
		function InitPredefinedList = 
		(
			list = #()
			curSelect = cbPredefinedType.selection
			print cbPredefinedType.selected
			
--          英雄  	
			if curSelect == 1 do
			(
				append list "gStand"
				append list "gStand-1"
				append list "gStand-2"
				append list "gWalk"
				append list "gWalk-1"
				append list "Attack"
				append list "Attack-1"
				append list "Attack-slam"
				append list "gDeath"
				append list "Spell"
				append list "Spell-1"
				append list "Spell-2"
				append list "Spell-3"
				append list "tstand"
				append list "gtfly"
				append list "Tdance"
				append list "Back"
			)
			
--          BOSS  	
			if curSelect == 2 do
			(
				append list "gStand"
				append list "gStand-1"
				append list "Birth"
				append list "gWalk"
				append list "Attack"
				append list "Spell"
				append list "gDeath"
				append list "Cheer"
			)
--          小怪	
			if curSelect == 3 do
			(
				append list "gStand"
				append list "gStand-1"
				append list "gWalk"
				append list "Attack"
				append list "Spell"
				append list "gDeath"
				append list "Cheer"
			)
--          宠物	
			if curSelect == 4 do
			(
				append list "gStand"
				append list "gStand-1"
				append list "gStand-2"
				append list "gWalk"
				append list "Tdance"
				append list "gDeath"
			)
--          坐骑	
			if curSelect == 5 do
			(
				append list "gStand"
				append list "gWalk"
				append list "gtfly"
				append list "gDeath"
			)			
--          建筑  	
			if curSelect == 6 do
			(		
				append list "Stand"
				append list "Attack"
				append list "Broken"
				append list "BrokenStand-1"
				append list "BrokenAttack-1"
				append list "Broken-1"
				append list "BrokenStand-2"
				append list "BrokenAttack-2"
				append list "Death"
			)
--          树  	
			if curSelect == 7 do
			(		
				append list "Stand"
				append list "Attacked"
				append list "Death"
				append list "Death-1"
			)
--          创新角色界面  	
			if curSelect == 8 do
			(		
				append list "gStand"
				append list "tstand"
				append list "Birth"
				append list "Spell-1"
				append list "Spell-2"
				append list "Back"
				append list "Leave"
			)		
						
			lbpredefinedSeq.items = list
			lbpredefinedSeq.selection = 1
		)
		

		function UpdateSequenceUI =
		(
			print "Updating sequence UI..."
			print LayerRoot1

			if LayerRoot1 != undefined do
			(
				if ActiveNoteTrack == undefined do
				(
					print "Active Note Track is undefined.. getting from layer root"
					ActiveNoteTrack = GetActorNoteTrack LayerRoot1
				)
				print ActiveNoteTrack
				if ActiveSequence == undefined do
				(
					print "ActiveSequence == undefined"
					ActiveSequence = GetStartKey ActiveNotetrack 1
					ActiveInfoKeyTime = undefined
					ActiveInfoKeyText = undefined
					ActiveMorphKeyTime = undefined
					ActiveMorphKeyText= undefined
				)
				
				if ActiveSequenceEnd == undefined do
				(
					print "ActiveSequenceEnd == undefined"
					ActiveSequenceEnd = GetEndKey ActiveNotetrack ActiveSequence
					print "Active Sequence End:"
					print ActiveSequenceEnd
				)
				
				print "Active Sequence:"
				print ActiveSequence
				print "Active Sequence End:"
				print ActiveSequenceEnd

				list = #()
				listsize = GetSequenceCount ActiveNoteTrack
				if listsize != undefined do
				(
					for i = 1 to listsize do
					(
						startKey = GetStartKey ActiveNoteTrack i
						seqname = GetSequenceName startKey
						if seqname != undefined do
						(
							append list seqname
						)
					)
				)

				if listsize > 0 do
				(
--					ddlSequences.items = list
					lbactorSeq.items = list
				)
				if listsize == 0 do
				(
--					ddlSequences.items = #()
					lbactorSeq.items = #()
				)
			

			)

			if ActiveSequence != undefined do
			(
				lblSeqName.enabled = true
				lblSeqCount.enabled = true
				editSeqName.enabled = true				
				editSeqName.text = GetSequenceName ActiveSequence
				lblSeqCount.enabled = true
				seqCount = GetSequenceCount ActiveNoteTrack
				seqIndex = GetStartKeyIndex ActiveNoteTrack ActiveSequence
				strSeqCount = "Sequence " + seqIndex as string + " of " + seqCount as string
				lblSeqCount.caption = strSeqCount
				cbLooping.enabled = true
				cbLooping.checked = GetSequenceLoop ActiveSequence
				spnStartFrame.enabled = true
				spnEndFrame.enabled = true
				spnStartFrame.value = ActiveSequence.time
				spnEndFrame.value = ActiveSequenceEnd.time
				btnRecordStartFrame.enabled=true
				btnRecordEndFrame.enabled = true
				btnCreate.enabled = true
				btnAddPredefinedSeq.enabled = true
--				btnAddName.enabled = true
				btnPrepend.enabled = true
--				btnMakeSpanFit.enabled = true
				lblMovePre.enabled = true
				editMovePre.enabled = true
				lblMovePreFrame.enabled = true
				btnMovePre.enabled = true
--				btnLoadAnimation.enabled = true
				btnSaveAnimation.enabled = true

				if seqCount > 1 then 
					btnDestroy.enabled = true 
				else 
					btnDestroy.enabled = false
				
				if seqIndex == 1 then 
					btnPrev.enabled = false 
				else 
					btnPrev.enabled = true
					
				if seqIndex == seqCount then 
					btnNext.enabled = false 
				else 
					btnNext.enabled = true

--				ddlSequences.enabled = true
--				ddlSequences.selection = seqIndex
				lbactorSeq.enabled = true
--				lbactorSeq.selection = seqIndex
			)
			if ActiveSequence == undefined do
			(
				lblSeqName.enabled = false
				lblSeqCount.enabled = false
				editSeqName.enabled = false
				editSeqName.text = ""
				lblSeqCount.enabled = false
				seqCount = 0
				seqIndex = 0
				strSeqCount = "Sequence " + seqIndex as string + " of " + seqCount as string
				lblSeqCount.caption = strSeqCount
				cbLooping.enabled = false
				cbLooping.checked = false
				spnStartFrame.enabled = false
				spnEndFrame.enabled = false
				spnStartFrame.value = 0
				spnEndFrame.value = 0
				btnRecordStartFrame.enabled=false
				btnRecordEndFrame.enabled = false
				btnCreate.enabled = true	
				btnAddPredefinedSeq.enabled = true
--				btnAddName.enabled = false
				btnPrepend.enabled = true
				btnDestroy.enabled = false 
				btnPrev.enabled = false 
				btnNext.enabled = false 
--				btnMakeSpanFit.enabled = false
--				ddlSequences.items = #()
--				ddlSequences.enabled = false
				lbactorSeq.items = #()
				lbactorSeq.enabled = false
				lblMovePre.enabled = false
				editMovePre.enabled = false
				lblMovePreFrame.enabled = false
				btnMovePre.enabled = false
--				btnLoadAnimation.enabled = true
				btnSaveAnimation.enabled = true
			)
			
			if ActiveNoteTrack == undefined do
			(
				btnCreate.enabled = false	
				btnAddPredefinedSeq.enabled = false
				btnPrepend.enabled = false
				btnLoadAnimation.enabled = false
				btnSaveAnimation.enabled = false
			)
			
			NiActorAccumulationRollout.UpdateAccumulationGroupUI()

		)

--		on btnMakeSpanFit pressed do
--		(
--			print "Anim Range:"
--			print animationRange
--			animationRange = (interval ActiveSequence.time ActiveSequenceEnd.time)
--		)
		
		function HasSequence name = 
		(
			listsize = GetSequenceCount ActiveNoteTrack
			if listsize != undefined do
			(
				name1 = "+" + name
				name2 = name + "+"
				for i = 1 to listsize do
				(
					startKey = GetStartKey ActiveNoteTrack i
					seqname = GetSequenceName startKey
					if seqname == name do
					(
						return true
					)

					if findString seqname name1 != undefined do
					(
						return true
					)
					
					if findString seqname name2 != undefined do
					(
						return true
					)
				)
			)
			
			return false
		)
		
		function HasSequenceExclude name index =
		(
			listsize = GetSequenceCount ActiveNoteTrack
			if listsize != undefined do
			(
				name1 = "+" + name
				name2 = name + "+"
				for i = 1 to listsize do
				(
					if i == index then continue
					
					startKey = GetStartKey ActiveNoteTrack i
					seqname = GetSequenceName startKey
					if seqname == name do
					(
						return true
					)
					
					messagebox seqname "sd"
					
					if findString seqname name1 != undefined do
					(
						return true
					)
					
					if findString seqname name2 != undefined do
					(
						return true
					)
				)
			)
			
			return false
		)
		
		function AddSequence nt name start end bLooping = 
		(
			if nt == undefined then return undefined
			seqCount = GetSequenceCount nt
			NewSequence = SetSimpleStartKey nt name start bLooping
			NewSequenceEnd = SetSimpleEndKey nt end
			if seqCount == 0 do
			(
				SetSequenceData NewSequence "-GlobalRatio" 100
				SetSequenceData NewSequence "-GlobalCompressFloats" true
				SetSequenceData NewSequence "-GlobalDontCompress" false
			)
			return NewSequence
		)
		
		function RemoveSequence nt StartKey EndKey=
		(
			if nt == undefined then return undefined
			
			keyArray = #()
			for key in nt.keys do
			(
				if key.time < startKey.time or key.time > endkey.time do
				(
					append keyArray key
				)
			)
			
			ntnew = notetrack "ActorManager2"
			addNoteTrack LayerRoot1 ntnew
			for key in keyArray do
			(
				newKey = CreateNoteKey ntnew key.time
				newKey.value = key.value
			)

			deleteNoteTrack LayerRoot1 nt
			ActiveNoteTrack = ntnew
			ntnew.name = "ActorManager"
		)
		
		
--		on ddlSequences selected seqnum do
--		(
--			index = seqnum
--			ActiveSequence = GetStartKey ActiveNoteTrack index
--			ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
--			ActiveInfoKeyTime = undefined
--			ActiveInfoKeyText = undefined
--			ActiveMorphKeyTime = undefined
--			ActiveMorphKeyText = undefined
--			UpdateSequenceUI()
--		) 

		
		
		
		function IsLooped name = 
		(
			if findString name "Death" != undefined do
			(
				return false
			)
			if findString name "Attack" != undefined do
			(
				return false
			)
			if findString name "Spell" != undefined do
			(
				return false
			)
			if findString name "Birth" != undefined do
			(
				return false
			)
			if findString name "Back" != undefined do
			(
				return false
			)
			if findString name "Leave" != undefined do
			(
				return false
			)
			if findString name "Broken" != undefined do
			(
				return false
			)
			return true
		)
		
		
		
		
		
		
		
		
		function CanSetActiveSequenceTime start end =
		(
			if start > end then return false
			if start >= ActiveSequenceEnd.time then return false
			if end <= ActiveSequence.time then return false
			
			index = GetStartKeyIndex ActiveNoteTrack ActiveSequence
			if index > 1 do
			(
				PrevSequence = GetStartKey ActiveNoteTrack (index-1)
				PrevSequenceEnd = GetEndKey ActiveNoteTrack PrevSequence
				if PrevSequenceEnd.time >= start then return false
			)
			if index < GetSequenceCount ActiveNoteTrack do
			(
				NextSequence = GetStartKey ActiveNoteTrack (index+1)
				if NextSequence.time <= end then return false
			)
			return true
		)
		
		
		
--		on lbactorSeq selected nameIndex do 
--		(
--			if lbactorSeq.selection[nameIndex] == true do
--			(
--				message = nameIndex as string + "   " + lbactorSeq.selection[nameIndex] as string
--				messagebox message title:"Set End Frame failure"
--
--				index = nameIndex				
--				ActiveSequence = GetStartKey ActiveNoteTrack index
--				ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
--				ActiveInfoKeyTime = undefined
--				ActiveInfoKeyText = undefined
--				ActiveMorphKeyTime = undefined
--				ActiveMorphKeyText = undefined
--				UpdateSequenceUI()
--			)
--		)
		
		
		
		
		
		
		
--		on btnAddName pressed do
--		(
--			if lbpredefinedSeq.selected == undefined do
--			(
--				return ok
--			)
--			
--			if HasSequence lbpredefinedSeq.selected do
--			(
--				message = "名称" + lbpredefinedSeq.selected + "的动作已存在"
--				messagebox message title:"AddPredefinedSeq error!"
--				return ok
--			)
--			
--			strNewSeqName = lbpredefinedSeq.selected 
--			
--			if ActiveSequence == undefined then return true
--			items = filterstring ActiveSequence.value " "
--		
--			value = ""
--			bPreisName = false
--			for i = 1 to items.count do
--			(
--				item = items[i]
--				if bPreisName == false then value = value + item + " "
--				if bPreisName == true do
--				(
--					value = value + item + "+" + strNewSeqName + " "
--				)
--				
--				bPreisName = false
--				if (EqualsNoCase item "-name") then bPreisName = true
--			)
--			print value
--			ActiveSequence.value = value
--			
--			UpdateSequenceUI()
--		)
	
		on NiActorSequenceRollout open do
		(
			UpdateSequenceUI()
			InitPredefinedList()
		)
		on btnLoadAnimation pressed do
		(
			if ActiveNoteTrack == undefined do
			(
				message = "请先添加Actor Root"
				messagebox message title:"LoadAnimation error!"
				return ok
			)
			LoadAnimationFile ActiveNoteTrack
			UpdateSequenceUI()
		)
		on btnSaveAnimation pressed do
		(
			if ActiveNoteTrack == undefined do
			(
				message = "请先添加Actor Root"
				messagebox message title:"SaveAnimation error!"
				return ok
			)
			SaveAnimationFile ActiveNoteTrack
		)
		on cbPredefinedType selected curType do
		(
			InitPredefinedList()
		)
		on btnAddPredefinedSeq pressed do
		(
			if lbpredefinedSeq.selected == undefined do
			(
				return ok
			)
			
			if HasSequence lbpredefinedSeq.selected do
			(
				message = "名称" + lbpredefinedSeq.selected + "的动作已存在"
				messagebox message title:"AddPredefinedSeq error!"
				return ok
			)
			
			if ActiveNoteTrack == undefined do
			(
				message = "请先添加Actor Root"
				messagebox message title:"AddPredefinedSeq error!"
				return ok
			)
			
			index = 1;
			start = 0
			end = 10
		
			if ActiveSequence != undefined do
			(
				index = GetStartKeyIndex ActiveNoteTrack ActiveSequence
				index = index + 1
				
				nextSeq = GetStartKey ActiveNoteTrack index
				if nextSeq == undefined do
				(
					start = ActiveSequenceEnd.time+1
					end = ActiveSequenceEnd.time + 10
				)
				if nextSeq != undefined do
				(
					start = ActiveSequenceEnd.time + 1
					end = nextSeq.time - 1
					if nextSeq.time == (ActiveSequenceEnd.time+1) or (start == end) do
					(
						message = "There is a sequence already immediately following this sequence!"
						messagebox message title:"AddPredefinedSeq error!"
						return ok
					)
				)
			)
			
			strNewSeqName = lbpredefinedSeq.selected 
			bLooping = IsLooped strNewSeqName
			NewSequence = AddSequence ActiveNoteTrack strNewSeqName start end bLooping
			if NewSequence != undefined do
			(
				print "btnAddPredefinedSeq pressed..."
				ActiveSequence = NewSequence
				print ActiveSequence
				ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
				ActiveInfoKeyTime = undefined
				ActiveInfoKeyText = undefined
				ActiveMorphKeyTime = undefined
				ActiveMorphKeyText = undefined
				lbactorSeq.selection = index
				UpdateSequenceUI()
			)
		)
		on editSeqName changed text do
		(
			if ActiveSequence == undefined then return true
			name = GetSequenceName ActiveSequence
			if name == text then return true
			
		--			seqIndex = GetStartKeyIndex ActiveNoteTrack ActiveSequence
		--			if HasSequenceExclude text seqIndex do
		--			(
		--				message = "名称" + text + "的动作已存在"
		--				messagebox message title:"Create error!"
		--				editSeqName.text = name
		--				return ok
		--			)
			
			local finaltext = ""
			textwords = filterstring text " \t\n#@!%^&*()=[]{}\|:;\"'<>,.?/~`"
			print textwords
			bHadToReviseText = true
			if textwords.count == 1 then finaltext = textwords[1]
			if textwords.count > 1 do
			(			
				finaltext = ""
				for i = 1 to textwords.count do
				(
					if i == textwords.count then 
						finaltext = finaltext + textwords[i] 
					else
						finaltext = finaltext + textwords[i] + "_" 
				)
				print "Had to revise text: "
				print finaltext
				bHadToReviseText = true
			)
			if text[text.count-1] == ' ' then finaltext = finaltext + "_"
		
		--			ddlSequences.selected = finaltext
		--			if seqIndex > 1 do
		--			(
		--				lbactorSeq.items[seqIndex-1] = finaltext
		--			) 
			print finaltext
			items = filterstring ActiveSequence.value " "
		
			value = ""
			ignoreindex = 0
			for i = 1 to items.count do
			(
				item = items[i]
				bAppend = true
				if (EqualsNoCase item "-name") then bAppend = false
				if i == ignoreindex then continue 
				item = item + " "
				if bAppend == true then value = value + item
				if bAppend == false do
				(
					value = value + "-name " + finaltext + " "
					ignoreindex = i + 1
				)
			)
			print value
			ActiveSequence.value = value
			
			-- now find sequence tags in object's notetracks and rename
			ChildArray = #()
			GetAllChildren ActorRoot ChildArray
			-- replace name with finaltext
			for Child in ChildArray do
			(
				if hasNoteTracks Child then
				(
					for i = 1 to numNoteTracks Child do
					(
						Notes = getNoteTrack Child i
						if Notes != undefined then
						(
							for Key in Notes.keys do
							(
								searchString = "-" + name + "Ratio"
								oldLength = searchString.count
								-- find out if the old sequence name is in the key
								-- if it has a dash, it is a compression override
								index = findString Key.value searchString
								if index != undefined then
								(
									-- replace the sequence name
									value = replace Key.value index oldLength ("-" + finaltext + "Ratio")
									Key.value = value
								)
								searchString = "-" + name + "DontCompress"
								oldLength = searchString.count
								index = findString Key.value searchString
								if index != undefined then
									Key.value = replace Key.value index oldLength ("-" + finaltext + "DontCompress")
								searchString = "-" + name + "CompressFloats"
								oldLength = searchString.count
								index = findString Key.value searchString
								if index != undefined then
									Key.value = replace Key.value index oldLength ("-" + finaltext + "CompressFloats")
							)
						)
					)
				)
			)
		
			if bHadToReviseText then UpdateSequenceUI()
		)
		on cbLooping changed state do
		(
			name = GetSequenceName ActiveSequence		
			items = filterstring ActiveSequence.value " "
		
			value = ""
			bLoopAdded
			for i = 1 to items.count do
			(
				item = items[i]
				bAppend = true
				if (EqualsNoCase item "-loop") then bAppend = false 
			    item = item + " "
		
				if bAppend == true then value = value + item
			)
			
			if cbLooping.checked == true then 
				value = value + " -loop"
			ActiveSequence.value = value
		)
		on spnStartFrame changed frame do
		(
			bAdd = false
			if CanSetActiveSequenceTime frame ActiveSequenceEnd.time do
			(
				seqIndex = GetStartKeyIndex ActiveNoteTrack ActiveSequence
				ActiveSequence.time = frame
				ActiveSequence = GetStartKey ActiveNoteTrack seqIndex
				ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
				setsliderTime ActiveSequence.time
				ActiveMorphKeyTime = undefined
		        ActiveMorphKeyText = undefined
		        ActiveInfoKeyTime = undefined
		        ActiveInfoKeyText = undefined
				UpdateSequenceUI()
				NiActorSeqTagsRollout.UpdateSequenceTagsUI()
				bAdd = true
			)
			
			if bAdd == false do
			(
				message = "Cannot move the Start frame to the specified time.\nThe time either conflicts with a subsequent key or is later than the end key"
				messagebox message title:"Start Frame failure"
				spnStartFrame.value = ActiveSequence.time
				return true
			)
		)
		on spnEndFrame changed frame do
		(
			bAdd = false
			if CanSetActiveSequenceTime ActiveSequence.time frame do
			(
			    seqIndex = GetStartKeyIndex ActiveNoteTrack ActiveSequence
				ActiveSequenceEnd.time = frame
				ActiveSequence = GetStartKey ActiveNoteTrack seqIndex
				ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
				setsliderTime ActiveSequence.time
				bAdd = true
				ActiveMorphKeyTime = undefined
		        ActiveMorphKeyText = undefined
		        ActiveInfoKeyTime = undefined
		        ActiveInfoKeyText = undefined
				UpdateSequenceUI()
				NiActorSeqTagsRollout.UpdateSequenceTagsUI()
			)
			
			if bAdd == false do
			(
				message = "Cannot move the End frame to the specified time.\nThe time either conflicts with a subsequent key or is earlier than the start key"
				messagebox message title:"Set End Frame failure"
				spnEndFrame.value = ActiveSequenceEnd.time
				return true
			)
		)
		on btnRecordStartFrame pressed do
		(
			frame = slidertime 			
			bAdd = false
			if CanSetActiveSequenceTime frame ActiveSequenceEnd.time do
			(
			    seqIndex = GetStartKeyIndex ActiveNoteTrack ActiveSequence
				ActiveSequence.time = frame
				ActiveSequence = GetStartKey ActiveNoteTrack seqIndex
				ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
				setsliderTime ActiveSequence.time
				spnStartFrame.value = frame
				ActiveMorphKeyTime = undefined
		        ActiveMorphKeyText = undefined
		        ActiveInfoKeyTime = undefined
		        ActiveInfoKeyText = undefined
				UpdateSequenceUI()
				NiActorSeqTagsRollout.UpdateSequenceTagsUI()
				bAdd = true
			)
			
			if bAdd == false do
			(
				message = "Cannot move the Start frame to the specified time.\nThe time either conflicts with a subsequent key or is later than the end key"
				messagebox message title:"Start Frame failure"
				spnStartFrame.value = ActiveSequence.time
				return true
			)		
		)
		on btnRecordEndFrame pressed do
		(
			frame = sliderTime
			if frame == ActiveSequenceEnd.time then return true
			bAdd = false
			if CanSetActiveSequenceTime ActiveSequence.time frame do
			(
				seqIndex = GetStartKeyIndex ActiveNoteTrack ActiveSequence
				ActiveSequenceEnd.time = frame
				ActiveSequence = GetStartKey ActiveNoteTrack seqIndex
				ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
				setsliderTime ActiveSequence.time
				spnEndFrame.value = frame
				bAdd = true
				ActiveMorphKeyTime = undefined
		        ActiveMorphKeyText = undefined
		        ActiveInfoKeyTime = undefined
		        ActiveInfoKeyText = undefined
				UpdateSequenceUI()
				NiActorSeqTagsRollout.UpdateSequenceTagsUI()
			)
			
			if bAdd == false do
			(
				message = "Cannot move the End frame to the specified time.\nThe time either conflicts with a subsequent key or is earlier than the start key"
				messagebox message title:"Set End Frame failure"
				spnEndFrame.value = ActiveSequenceEnd.time
				return true
			)
		)
		on btnPrev pressed do
		(
			index = GetStartKeyIndex ActiveNoteTrack ActiveSequence
			if index > 1 do
			(
				index = index - 1
				ActiveSequence = GetStartKey ActiveNoteTrack index
				ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
				ActiveInfoKeyTime = undefined
				ActiveInfoKeyText = undefined
				ActiveMorphKeyTime = undefined
				ActiveMorphKeyText = undefined
				UpdateSequenceUI()
			)
		)
		on btnNext pressed do
		(
			index = GetStartKeyIndex ActiveNoteTrack ActiveSequence
			count = GetSequenceCount ActiveNoteTrack
			if index< count do
			(
				index = index + 1
				ActiveSequence = GetStartKey ActiveNoteTrack index
				ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
				ActiveInfoKeyTime = undefined
				ActiveInfoKeyText = undefined
				ActiveMorphKeyTime = undefined
				ActiveMorphKeyText = undefined
				UpdateSequenceUI()
			)
		)
		on btnCreate pressed do
		(
			if ActiveNoteTrack == undefined do
			(
				message = "请先添加Actor Root"
				messagebox message title:"Create error!"
				return ok
			)
			
			bLooping = cbLooping.enabled
			start = 0
			end = 10
			if ActiveSequence != undefined do
			(
				index = GetStartKeyIndex ActiveNoteTrack ActiveSequence
				index = index + 1				
				nextSeq = GetStartKey ActiveNoteTrack index
				if nextSeq == undefined do
				(
					start = ActiveSequenceEnd.time+1
					end = ActiveSequenceEnd.time + 10
				)
				if nextSeq != undefined do
				(
					start = ActiveSequenceEnd.time + 1
					end = nextSeq.time - 1
					if nextSeq.time == (ActiveSequenceEnd.time+1) or (start == end) do
					(
						message = "There is a sequence already immediately following this sequence!"
						messagebox message title:"Append error!"
						return ok
					)
				)
			)
			
			strNewSeqName = strBlankSeq + "_AT_" + (start as string) 
			NewSequence = AddSequence ActiveNoteTrack strNewSeqName start end bLooping
			if NewSequence != undefined do
			(
				print "btnCreate pressed..."
				ActiveSequence = NewSequence
				print ActiveSequence
				ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
				ActiveInfoKeyTime = undefined
				ActiveInfoKeyText = undefined
				ActiveMorphKeyTime = undefined
				ActiveMorphKeyText = undefined
				UpdateSequenceUI()
			)
		)
		on btnPrepend pressed do
		(
			if ActiveNoteTrack == undefined do
			(
				message = "请先添加Actor Root"
				messagebox message title:"Prepend error!"
				return ok
			)
			
			bLooping = cbLooping.enabled
			start = 0
			end = 10
			if ActiveSequence != undefined do
			(
				if ActiveSequence.time <= 0 do
				(
					message = "There cannot be a sequence earlier than this one!"
					messagebox message title:"Prepend error"
					return ok
				)
				
				index = GetStartKeyIndex ActiveNoteTrack ActiveSequence
				index = index - 1
				start = 0
				end = 0
				
				if index == 0 do
				(
					start = 0
					end = ActiveSequence.time - 1
				)
				if index > 0 do
				(
					nextSeq = GetStartKey ActiveNoteTrack index
					if nextSeq == undefined do
					(
						start = ActiveSequence.time - 1
						end = ActiveSequence.time - 10
					)
					if nextSeq != undefined do
					(
						prevEnd = GetEndKey ActiveNoteTrack nextSeq
						start = prevEnd.time + 1
						end = ActiveSequence.time - 1
						if (prevEnd.time == (ActiveSequence.time - 1)) or (start == end) do
						(
							message = "There is a sequence already immediately preceding this sequence!"
							messagebox message title:"Prepend error!"
							return ok
						)
					)
				)
			)
			strNewSeqName = strBlankSeq + "_AT_" + (start as string) 
			NewSequence = AddSequence ActiveNoteTrack strNewSeqName start end bLooping
			if NewSequence != undefined do
			(
				print "btnPrepend pressed..."
				ActiveSequence = NewSequence
				print ActiveSequence
				ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
				ActiveInfoKeyTime = undefined
				ActiveInfoKeyText = undefined
				ActiveMorphKeyTime = undefined
				ActiveMorphKeyText = undefined
				UpdateSequenceUI()
			)
		)
		on btnDestroy pressed do
		(
			RemoveSequence ActiveNoteTrack ActiveSequence ActiveSequenceEnd
			ActiveSequence = undefined 
			ActiveSequenceEnd = undefined
			ActiveInfoKeyTime = undefined
			ActiveInfoKeyText = undefined
			ActiveMorphKeyTime = undefined
			ActiveMorphKeyText = undefined
			lbactorSeq.selection = 1
			UpdateSequenceUI()
		)
		on btnMovePre pressed do
		(
			iFrame = editMovePre.text as Integer
			SeqCount = GetSequenceCount ActiveNoteTrack
												
			if iFrame > 0 do
			(
				i = lbactorSeq.selection.count
				while i > 0 do 
				(
					if lbactorSeq.selection[i] == true do
					(										
						startKey = GetStartKey ActiveNotetrack i
						endKey = GetEndKey ActiveNotetrack startKey
						
						startTime = startKey.time
						endTime = endKey.time
						
						if i < SeqCount do
						(
							NextSequence = GetStartKey ActiveNoteTrack (i+1)
							if NextSequence.time <= endTime+iFrame do
							(
								strName = GetSequenceName startKey
								message = strName + "时间移动覆盖后面动作，请检查"
								messagebox message title:"Move error!"
								i -= 1
								continue
							)
						)
						
						endKey.time += iFrame;
						startKey.time += iFrame;				
					)
					
					i -= 1
				)
			)
			
			if iFrame < 0 do
			(
				for i = 1 to lbactorSeq.selection.count do
				(
					if lbactorSeq.selection[i] == true do
					(
						startKey = GetStartKey ActiveNotetrack i
						endKey = GetEndKey ActiveNotetrack startKey
						
						startTime = startKey.time
						endTime = endKey.time
						
						if i > 1 do
						(
							PrevSequence = GetStartKey ActiveNoteTrack (i-1)
							PrevSequenceEnd = GetEndKey ActiveNoteTrack PrevSequence
							if PrevSequenceEnd.time >= startTime+iFrame do
							(
								strName = GetSequenceName startKey
								message = strName + "时间移动覆盖前面动作，请检查"
								messagebox message title:"Move error!"
								continue
							)
						)
						
						if startKey.time + iFrame < 0 then startKey.time = 0 else startKey.time += iFrame
						if endKey.time + iFrame	< 1 then endKey.time = 1 else endKey.time += iFrame				
					)
				)
			)
			
			UpdateSequenceUI()
		)
		on lbactorSeq doubleClicked sel do
		(
			print "Anim Range:"
			print animationRange
			animationRange = (interval ActiveSequence.time ActiveSequenceEnd.time)
		)
		on lbactorSeq selectionEnd do
		(
			ids = #{}
			bfirst = true
			for i = 1 to lbactorSeq.selection.count do
			(
				if lbactorSeq.selection[i] == true do
				(
					append ids i
					
					if bfirst == true do
					(
						bfirst = false
						ActiveSequence = GetStartKey ActiveNoteTrack i
						ActiveSequenceEnd = GetEndKey ActiveNoteTrack ActiveSequence
						ActiveInfoKeyTime = undefined
						ActiveInfoKeyText = undefined
						ActiveMorphKeyTime = undefined
						ActiveMorphKeyText = undefined
						UpdateSequenceUI()
					)
				)
			)
						
			if ids != undefined do
			(
				lbactorSeq.selection = ids
			)
		)
	)
	
	rollout NiActorLayerRollout "Active Layer"  
	(
		group "Layer"
		(
			dropdownlist ddLayerRoot "Known Layer Roots:" items:#("NONE") selection:1 width:120 align:#center  enabled:false
			pickbutton btnAddLayerRoot "Add" align:#center width:55 across:2 enabled:false
			button btnRemLayerRoot "Remove" align:#center width:55 enabled:false
		)
		
		function RefreshLayerRoots obj=
		(
			nt = GetActorNoteTrack obj
			if nt != undefined do
			(
				append AllLayerRoots obj
			)
			
			for child in obj.children do 			(
				RefreshLayerRoots child
			)
		)
		
		function UpdateLayerGroupUI =
		(
			if LayerRoot1 == undefined and ActorRoot != undefined then
				LayerRoot1 = ActorRoot
		
			if LayerRoot1 != undefined do
			(
				AllLayerRoots = #()
				RefreshLayerRoots ActorRoot
				print AllLayerRoots
				ddLayerRoot.items = GetNameArrayFromObjArray AllLayerRoots
				
				index = 1
				for layer in AllLayerRoots do
				(
					if layer == LayerRoot1 then ddLayerRoot.selection = index
					index = index + 1
				)
				
				print "Updating layer UI..."
				ddLayerRoot.enabled = true
				btnAddLayerRoot.enabled = true
				btnRemLayerRoot.enabled = true
				select LayerRoot1
				NiActorSequenceRollout.UpdateSequenceUI()
				
			)	
			
			if LayerRoot1 == undefined do
			(
				AllLayerRoots = #()
				ddLayerRoot.items = #("None")
				ddLayerRoot.enabled = false
				btnAddLayerRoot.enabled = false
				btnRemLayerRoot.enabled = false
				ActiveSequence = undefined
				ActiveSequenceEnd = undefined
				ActiveInfoKeyTime = undefined
				ActiveInfoKeyText = undefined
				ActiveMorphKeyTime = undefined
				ActiveMorphKeyText = undefined
				ActiveNoteTrack = undefined
				NiActorSequenceRollout.UpdateSequenceUI()					
			)
		)
		
		
		on btnAddLayerRoot picked obj do
		(
			bCanDo = ParentIsActor ActorRoot obj
			if bCanDo == true do
			(
				nt = MakeActorNoteTrack obj
				LayerRoot1 = obj
				ActiveSequence = undefined
				ActiveSequenceEnd = undefined
				ActiveInfoKeyTime = undefined
				ActiveInfoKeyText = undefined
				ActiveMorphKeyTime = undefined
				ActiveMorphKeyText = undefined
				ActiveNoteTrack = undefined
				UpdateLayerGroupUI()
				select LayerRoot1
			)
			if bCanDo == false do
			(
				message = "Object \"" + obj.name + "\" does not have Actor \"" + ActorRoot.name + "\" as a parent!"
				messagebox message title:"Add Layer Root Error!"
			)
		)
		
		on btnRemLayerRoot pressed do
		(
			if LayerRoot1 == ActorRoot do
			(
				message = "Cannot remove the topmost layer root!\nTo do this, you must remove the Actor root."
				messagebox message title:"Remove Layer Root Error!"
				return true
			)
			
			RemoveActorNoteTrack LayerRoot1
			LayerRoot1 = ActorRoot
			ActiveSequence = undefined
			ActiveSequenceEnd = undefined
			ActiveNoteTrack = undefined
			UpdateLayerGroupUI()
		)
		
		on ddLayerRoot selected item do
		(
			name = ddLayerRoot.items[item]
			for obj in AllLayerRoots do
			(
				if obj.name == name do
				(
					LayerRoot1 = obj
					str = "layer root: " + obj.name
					print str
					ActiveSequence = undefined
					ActiveSequenceEnd = undefined
					ActiveNoteTrack = undefined
					ActiveInfoKeyTime = undefined
					ActiveInfoKeyText = undefined
					ActiveMorphKeyTime = undefined
					ActiveMorphKeyText = undefined
					
					NiActorSequenceRollout.UpdateSequenceUI()
					select LayerRoot1
					return true
				)
			)
		)
		
		on NiActorLayerRollout open do
		(
			UpdateLayerGroupUI()
		)
	)		
	
	rollout NiActorManagerRollout "Actors"  
	(
		button btnRefreshAll "Refresh All" width:150
			
		group "Actor"
		(
			dropdownlist ddActorRoot "Known Actor Roots:" items:#("NONE") selection:1 width:120 align:#center 
			pickbutton btnAddActorRoot "Add" align:#center width:55 across:2 
			button btnRemActorRoot "Remove" align:#center width:55
			
			label lblAccumRoot "Accumulation Root:" width:120 align:#left enabled:false
			label lblAccumRootName "NONE" width:120 align:#center  enabled:false
			pickbutton btnSetAccumRoot "Pick" align:#center width:55 across:2 enabled:false
			button btnResetAccumRoot "Default" align:#center width:55 enabled:false
			
		)
			
		function MakeAccumRoot obj =
		(
			setUserProp obj strAccum ""
			AccumRoot = obj
		)
		
		function IsAccumRoot obj =
		(
			str = GetUserProp obj strAccum
			if str != undefined do
			(
				message =  "Is Accum Root :" + obj.name + " str: \"" + str + "\""
				print message
			)
			if str == undefined then return false else return true
		)
		
		function FindAccumRoot obj =
		(
			bIsAccum = IsAccumRoot obj
			if bIsAccum == true then return obj
			
			for child in obj.children do
			(
				result = FindAccumRoot child
				if result != undefined then return child
			)
			return undefined
		)
		
		
		
		function RemoveAccumRoot obj =
		(
			print "RemoveAccumRoot"
			str = getUserPropBuffer obj
			foundstring = findstring str strAccum
			
			if foundstring == undefined then 
				return undefined
			print foundstring
			print str.count
			str = replace str foundstring (strAccum.count+2) " "
			print str
			setUserPropBuffer obj str
			b = IsAccumRoot obj
			if b == true then print "Uh-oh in RemoveAccumRoot!!!!"
				
			return obj
		)
		
		function UpdateActorGroupUI =
		(
			if ActorRoot != undefined do
			(
				ddActorRoot.items = GetNameArrayFromObjArray AllActorRoots
				index = 1;
				for actor in AllActorRoots do
				(
					if actor == ActorRoot do
					(
						ddActorRoot.selection = index
					)
					index = index + 1
				)
				
				AccumRoot = FindAccumRoot ActorRoot
				if AccumRoot == undefined then MakeAccumRoot ActorRoot
				lblAccumRootName.caption = AccumRoot.name
				lblAccumRootName.enabled = true
				lblAccumRoot.enabled = true
				btnSetAccumRoot.enabled = true
				btnResetAccumRoot.enabled = true
				
				NiActorLayerRollout.UpdateLayerGroupUI()
			)
			if ActorRoot == undefined do
			(
				ddActorRoot.items = #("None")
				AccumRoot = undefined
				lblAccumRootName.caption = "None"
				lblAccumRootName.enabled = false
				lblAccumRoot.enabled = false
				btnSetAccumRoot.enabled = false
				btnResetAccumRoot.enabled = false
				
				NiActorLayerRollout.UpdateLayerGroupUI()
			)
		)
		
		
		function RefreshAll =
		(
			AllActorRoots = #()
			GetActorRoots rootNode AllActorRoots
			if AllActorRoots.count == 0 then 
				ActorRoot = undefined
			else
				ActorRoot = AllActorRoots[1]
			LayerRoot1 = undefined
			AllLayerRoots = #()
			ActiveSequence = undefined
			ActiveSequenceEnd = undefined
			ActiveNoteTrack = undefined
			ActiveInfoKeyTime = undefined
			ActiveInfoKeyText = undefined
			ActiveMorphKeyTime = undefined
			ActiveMorphKeyText = undefined
			UpdateActorGroupUI()
		)

		on btnRefreshAll pressed do
		(
			RefreshAll()
		)

		function CanCreateActorRoot obj =
		(
			bCanAdd = true
			for actor in AllActorRoots do
			(
				if actor == obj then bCanAdd = false
			)
			parent = obj.parent
			
			while parent != undefined do
			(
				nt = GetActorNoteTrack parent
				if nt != undefined then bCanAdd = false	
				parent = parent.parent
			)
			
			return bCanAdd
		) 
		
		function MakeActorRoot obj = 
		(
			MakeActorNoteTrack obj
			select obj
			append AllActorRoots obj
			MakeAccumRoot obj
			b = IsAccumRoot obj
			ActorRoot = obj
			LayerRoot1 = obj
			ActiveSequence = undefined
			ActiveSequenceEnd = undefined
			ActiveNoteTrack = undefined
			ActiveInfoKeyTime = undefined
			ActiveInfoKeyText = undefined
			ActiveMorphKeyTime = undefined
			ActiveMorphKeyText = undefined
			if b == false then print "Error in MakeActorRoot: Object is not an AccumRoot."
			-- set a key at time zero with the global compression values stored
			nt = GetActorNoteTrack obj
			if nt != undefined then
			(
				index = getNoteKeyIndex nt 0
				if index == undefined then
				(
--					Key = addNewNoteKey nt.keys 0
--					SetSequenceData Key "-GlobalRatio" 100
--					SetSequenceData Key "-GlobalCompressFloats" true
--					SetSequenceData Key "-GlobalDontCompress" false
				)
				else
				(
					Key = nt.keys[Index]
					ratio = GetSequenceData Key "-GlobalRatio"
					compressFloats = GetSequenceData Key "-GlobalCompressFloats"
					dontCompress = GetSequenceData Key "-GlobalDontCompress"
					
					if ratio == undefined then
						SetSequenceData Key "-GlobalRatio" 100
					if compressFloats == undefined then
						SetSequenceData Key "-GlobalCompressFloats" true
					if dontCompress == undefined then
						SetSequenceData Key "-GlobalDontCompress" false
				)
			)
		)
		
		on ddActorRoot selected itemnumber do
		(
			name = ddActorRoot.items[itemnumber]
			for root in AllActorRoots do
			(
				if root.name == name do
				( 
					ActorRoot = root
					str =  "Actor Root: " + ActorRoot.name
					print str
					AccumRoot = FindAccumRoot ActorRoot
					if AccumRoot == undefined then MakeAccumRoot ActorRoot
					str = "Accum Root: "+ AccumRoot.name
					print str
					LayerRoot1 = ActorRoot
					ActiveSequence = undefined
					ActiveSequenceEnd = undefined
					ActiveNoteTrack = undefined
					ActiveInfoKeyTime = undefined
					ActiveInfoKeyText = undefined
					ActiveMorphKeyTime = undefined
					ActiveMorphKeyText = undefined
					UpdateActorGroupUI()
					select ActorRoot
				)
			)
		)
		
		on btnAddActorRoot picked obj do
		(
			bResult = CanCreateActorRoot obj
			if bResult == true do
			(
				print "Creating actor root!"
				print obj.name

				MakeActorRoot obj
				UpdateActorGroupUI()
				select ActorRoot
			)
			if bResult == false do
			(

				str = "Cannot add \"" + obj.name + "\" as an actor root.\nThis is because the object has a parent that is an actor root or it is already an actor root\n"
				messagebox str title:"Add Actor Root Error"
			)
		)
		
		on btnRemActorRoot pressed do
		(
			if ActorRoot != undefined do
			(
				nt = GetActorNoteTrack ActorRoot

				if nt != undefined do
				(
					print "Deleting note track"
					deletenotetrack ActorRoot nt
				)
				RefreshAll()
			)
		)
		
		on btnSetAccumRoot picked obj do
		(
			parent = obj

			bCanAdd = false	
			bFoundCurrentActorRoot = false		
			while parent != undefined do
			(
				nt = GetActorNoteTrack parent
				if nt != undefined then bCanAdd = true
				if parent == ActorRoot then bFoundCurrentActorRoot = true		
				parent = parent.parent
			)

			if bCanAdd == true and bFoundCurrentActorRoot == true do
			(
				RemoveAccumRoot AccumRoot
				MakeAccumRoot obj
				UpdateActorGroupUI()
			)
			
			if bCanAdd == false do
			(
				str = "Cannot add \"" + obj.name + "\" as an accumulation root.\nThis is because the object isn't the current Actor Root or it is not a child of the Actor Root!\n"
				messagebox str title:"Add Accumulation Root Error"
			)
		)
		
		on btnResetAccumRoot pressed do
		(
			RemoveAccumRoot AccumRoot
			MakeAccumRoot ActorRoot
			UpdateActorGroupUI()
		)

		on NiActorManagerRollout open do
		(
			RefreshAll()
		)

        on NiActorManagerRollout close do
        (
            try(callbacks.removeScripts #filePreOpen id:#ActorManagerUtilPreOpen);catch()
	        try(callbacks.removeScripts #filePostOpen id:#ActorManagerUtilPostOpen);catch()	
            try(callbacks.removeScripts #systemPreReset id:#ActorManagerUtilPreReset);catch()
	            
        )
		
	)
	
	
	utility ActorManagerUtil "Gamebryo Animation Manager"  -- define the utility name and description string 
	(	 
		global ActorManagerUtility
		label ActorManagerUtilVersion "Version: 1.0.0" align:#center

		on  ActorManagerUtil open do 
		( 
			-- ActorManagerRollout = newRolloutFloater "Gamebryo ActorManager Util" 220 560
			addRollout NiActorManagerRollout rolledUp:false
			addRollout NiActorLayerRollout rolledUp:true
			-- addRollout NiActorSeqPredefineRollout rolledUp:true
			addRollout NiActorSequenceRollout rolledUp:false
			addRollout NiActorAccumulationRollout rolledUp:true
			addRollout NiActorSeqTagsRollout rolledUp:true
			ActorManagerUtility = NiActorManagerRollout
			callbacks.addScript #filePostOpen "try(ActorManagerUtility.RefreshAll());catch()" id:#ActorManagerUtilPostOpen
		) 

		on  ActorManagerUtil close do 
		( 
			callbacks.removeScripts #filePostOpen id:#ActorManagerUtilPostOpen
			ActorManagerUtility = undefined
			removeRollout NiActorManagerRollout 
			removeRollout NiActorLayerRollout
			removeRollout NiActorAccumulationRollout
			removeRollout NiActorSeqTagsRollout
			removeRollout NiActorSequenceRollout
			-- removeRollout NiActorSeqPredefineRollout
		) 
	)
	