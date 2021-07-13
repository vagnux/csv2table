#!/usr/bin/perl;
use strict;
use warnings;

my ($file, $table) = @ARGV;

if (not defined $file) {
  die "Need file\n";
}
if (  $file =~ "--help") {
  die "USE: perl csv2table.pl file.csv  tableName\n";
} 
if (not  defined $table) {
  die "Need table Name\n";
}

my $fileOutput = $table . ".sql";
open(FW, '>' , $fileOutput) or die $!;
open(FH, '<', $file) or die $!;

my $lineNumber = 0;
my @line;
my $size = 0;
my $insert;
while(<FH>){
  my $insert = ",(\"";
  $insert = "\ninsert into $table values("  if ( $lineNumber <= 1 );
  if ( $lineNumber == 0 ){
    print FW queryHead($table,$_);
  }else{
   
   
    my $line = $_;
    $line =~  s/\r\n//g;
    $line =~  s/\"//g;
    $line =~  s/;/\",\"/g;
    $line =~  s/,/\",\"/g;
    $line =~  s/\|/\",\"/g;
    $line =~  s/\t/\",\"/g;
    $insert .=  $line . "\",now())";  
    $lineNumber = 1 if $lineNumber > 500;
    print FW $insert;
  }
  $lineNumber++;
  $insert = '';
}
print FW ";\n";
print FW queryFoot($table);
close(FW); 
close(FH);

sub queryHead {
  my ($table,$line) = @_;

  my $output = "/*!40103 SET TIME_ZONE='+00:00' */;
  --
  -- Table structure for table `$table`
  --

  DROP TABLE IF EXISTS `$table`;
  /*!50503 SET character_set_client = utf8mb4 */;
  CREATE TABLE `$table` (\"";
  $line =~  s/\r\n//g;
  $line =~  s/"//g;
  $line =~  s/ //g;
  $line =~  s/;/\" text,\n"/g;
  $line =~  s/,/\" text,\n"/g;
  $line =~  s/\|/\" text,\n"/g;
  $line =~  s/\t/\" text,\n"/g;
  $output .= $line . "\" text, \n`created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP";
  $output .= ") ENGINE=myisam DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
  LOCK TABLES `$table` WRITE;
  /*!40000 ALTER TABLE `$table` DISABLE KEYS */;
  ";
  return $output;
}

sub queryFoot {
  my ($table) = @_;
  my $output = "/*!40000 ALTER TABLE `$table` ENABLE KEYS */;
  UNLOCK TABLES;";
  return $output;
}
