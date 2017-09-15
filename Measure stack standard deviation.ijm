close("*");

//Choose the input and output directories
inputDirectory = getDirectory("Choose the input directory");
fileList = getFileList(inputDirectory);
outputDiretory = getDirectory("Choose the output directory");

minStdDev = getNumber("Enter the desired minimum standard deviation cutoff:", 5);
maxStdDev = getNumber("Enter the desired maximum standard deviation cutoff:", 120);
nBins = maxStdDev - minStdDev;

//Count the number of files in the directory that end in *.nd2
nd2Count = 0;
for(a=0; a<fileList.length; a++){
	//open the file if it is a *.nd2 file
	if(endsWith(fileList[a], ".nd2")){
		nd2Count += 1;
	}
}

//Create an image to store the histograms
newImage("Sample Histograms", "32-bit black", nBins, nd2Count, 1);

//Initialize the sample counter
sampleCounter = 0;

for(a=0; a<fileList.length; a++){
	//open the file if it is a *.nd2 file
	if(endsWith(fileList[a], ".nd2")){
		//Open the file and count up one on the sample counter
		run("Bio-Formats Importer", "open=" + inputDirectory + fileList[a] + " autoscale color_mode=Default view=[Standard ImageJ] stack_order=Default");
		selectWindow(fileList[a]);
		sampleCounter += 1;

		//Convert to 8-bit
		run("8-bit");

		//Run 2x2 median to remove outliers (hot pixels, etc.)
		run("Median...", "radius=2 stack");

		//Run bandpass filter to normalize contrast
		run("Bandpass Filter...", "filter_large=40 filter_small=2 suppress=None tolerance=5 autoscale saturate process");

		//Create a stdev stack
		run("Z Project...", "start=1 stop=31 projection=[Standard Deviation]");

		//close the original image
		close(fileList[a]);
		selectWindow("STD_" + fileList[a]);

		//Select regions of image above min cutoff
		//getStatistics(dummy, dummy, dummy, max, dummy, dummy);
		//setThreshold(minStdDev, max);
		//run("Create Selection");

		//Create a histogram of the selected area
		getHistogram(values, counts, nBins, minStdDev, maxStdDev);
		Array.print(values);

		//Normalize and print the histogram to the storage image
		arraySum = 0;
		for(b=0; b<counts.length; b++){
			arraySum = arraySum + counts[b];
		}
		for(b=0; b<counts.length; b++){
			counts[b] = counts[b]/arraySum;
		}
		selectImage("Sample Histograms");
		for(b=0; b<counts.length; b++){
			setPixel(b,(sampleCounter-1),counts[b]);
		}
		
		close("STD_" + fileList[a]);
		
	}
}

