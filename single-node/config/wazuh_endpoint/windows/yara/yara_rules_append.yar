// Custom config, append this file to the updated file from download_yara_rules.py

rule M_AES_Encrypted_payload {
   meta:
      author = "MAS"
      reference = "https://www.mandiant.com/"
      description = "This rule is desgined to detect on events that exhibits indicators of utilizing AES encryption for payload obfuscation."
      target_entity = "Process"
  strings:
    $a = /(\$\w+\.Key(\s|)=((\s|)(\w+|));|\$\w+\.Key(\s|)=(\s|)\w+\('\w+'\);)/
    $b = /\$\w+\.IV/
    $c = /System\.Security\.Cryptography\.(AesManaged|Aes)/
  condition:
    all of them
}

rule M_Downloader_PEAKLIGHT_1 {
   meta:
      author = "MAS"
      reference = "https://www.mandiant.com/"
      description = "This rule is designed to detect events related to Peaklight. PEAKLIGHT is an obfuscated PowerShell-based downloader which checks for the presence of hard-coded filenames and downloads files from a remote CDN if the files are not present."
      category = "Malware"
   strings:
      $str1 = /function\s{1,16}\w{1,32}\(\$\w{1,32},\s{1,4}\$\w{1,32}\)\{\[IO\.File\]::WriteAllBytes\(\$\w{1,32},\s{1,4}\$\w{1,32}\)\}/ ascii wide 
      $str2 = /Expand-Archive\s{1,16}-Path\s{1,16}\$\w{1,32}\s{1,16}-DestinationPath/ ascii wide
      $str3 = /\(\w{1,32}\s{1,4}@\((\d{3,6},){3,12}/ ascii wide
      $str4 = ".DownloadData(" ascii wide
      $str5 = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12" ascii wide
      $str6 = /\.EndsWith\(((["']\.zip["'])|(\(\w{1,32}\s{1,16}@\((\d{3,6},){3}\d{3,6}\)\)))/ ascii wide
      $str7 = "Add -Type -Assembly System.IO.Compression.FileSystem" ascii wide
     $str8 = "[IO.Compression.ZipFile]::OpenRead"
   condition:
     4 of them and filesize < 10KB         
}