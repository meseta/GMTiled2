/// @description  DerpXmlRead_CloseFile()
//
//  Closes the currently open XML file.

file_text_close(global.DerpXmlRead[? "xmlFile"])

ds_map_destroy(global.DerpXmlRead)