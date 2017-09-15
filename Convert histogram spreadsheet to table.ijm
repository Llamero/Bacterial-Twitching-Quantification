image = getTitle();
directory = getDirectory("Choose input directory");
fileList = getFileList(directory);
dataArray = newArray(115);
for(a=0; a<fileList.length; a += 3){
	sampleID = replace(fileList[a], ".tif", "");
	sampleID = replace(sampleID, "STD_", "");
	selectWindow(image);
	for(b=0; b<dataArray.length; b++){
		dataArray[b] = getPixel(b,a/3);
	}
	for(b=0; b<dataArray.length; b++){
		setResult(sampleID, b, dataArray[b]);
	}
}
