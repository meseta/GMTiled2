/// @description  DerpXmlRead_OpenFile(global.DerpXmlRead[? "xmlFile"]Path)
/// @param global.DerpXmlRead[? "xmlFile"]Path
//
//  Opens an XML file for reading. Be sure to call DerpXmlRead_CloseFile when you're done.
//  Returns whether load was successful.

var xmlFilePath = argument0

var file = file_text_open_read(xmlFilePath)
if file == -1 {
    return false
}

#macro DerpXmlType_StartOfFile "StartOfFile"
#macro DerpXmlType_OpenTag "OpenTag"
#macro DerpXmlType_CloseTag "CloseTag"
#macro DerpXmlType_Text "Text"
#macro DerpXmlType_Whitespace "Whitespace"
#macro DerpXmlType_EndOfFile "EndOfFile"
#macro DerpXmlType_Comment "Comment"

#macro DerpXmlReadMode_File 1
#macro DerpXmlReadMode_String 0

global.DerpXmlRead = ds_map_create();
ds_map_add_map(global.DerpXmlRead, "attributeMap", ds_map_create())

global.DerpXmlRead[? "xmlFile"] = file
global.DerpXmlRead[? "readMode"] = DerpXmlReadMode_File
global.DerpXmlRead[? "xmlString"] = file_text_read_string(global.DerpXmlRead[? "xmlFile"])
    
global.DerpXmlRead[? "stringPos"] = 0
global.DerpXmlRead[? "currentType"] = DerpXmlType_StartOfFile
global.DerpXmlRead[? "currentValue"] = ""
global.DerpXmlRead[? "currentRawValue"] = ""
global.DerpXmlRead[? "lastReadEmptyElement"] = false
global.DerpXmlRead[? "lastNonCommentType"] = DerpXmlType_StartOfFile

return true
