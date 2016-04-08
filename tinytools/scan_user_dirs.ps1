$computerNameArray = Get-Content computernames.txt
for ($i=0; $i -lt $computerNameArray.length; $i++) {
	$scanFolder = "\\" + $computerNameArray[$i] + "\c$\users"
	$scanResult = $computerNameArray[$i] + " weighs {0:0,0.00} GB" -f ((Get-ChildItem -R $scanFolder | measure-object length -Sum).Sum / 1GB)
	echo $scanResult | Tee-Object -file user_dir_sizes.txt
  scanResult >> user_dir_sizes-backup.txt
}
