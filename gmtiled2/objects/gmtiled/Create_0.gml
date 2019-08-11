tilesets = ds_map_create();
layers = ds_list_create();

// Cleanup DerpXml, we don't want to use them
with (objDerpXmlRead) instance_destroy();
with (objDerpXmlWrite) instance_destroy();

DerpXml_Init();

DerpXmlRead_OpenFile(tmx_file)
tiled_parse_root()
DerpXmlRead_CloseFile()

// Cleanup DerpXml
with (objDerpXmlRead) instance_destroy();
with (objDerpXmlWrite) instance_destroy();
