#!/usr/bin/perl;
use strict;
use warnings;
use Data::Dumper qw(Dumper);

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
while(<FH>){
  if ( $lineNumber == 0 ){
     @line = getLineCollumns(detectFieldsSeparator($_),$_);
     print FW queryHead($table,@line);
     $size =  scalar @line;
  }else{
    @line = getLineCollumns(detectFieldsSeparator($_),$_);
    my $insert = "insert into $table values(";
    $insert = ",(" if ($lineNumber > 1);
    @line = getLineCollumns(detectFieldsSeparator($_),$_);
    for (my $i=0; $i < $size ; $i++) {
       $insert .= "," if ($i > 0);
       $insert .= "'" . $line[$i] . "'";
    } 
    $insert .= ",now())";
    print FW $insert;
  }
 $lineNumber++;
}
print FW ";\n";
print FW queryFoot($table);
close(FW); 
close(FH);

sub detectFieldsSeparator {
     my ($param) = @_;
     my $resp;
     my $size =0;
      my $anterior =0;
    foreach (',',';','|',"/t") {
        $size = split($_,$param);
        $resp = $_ if $size > $anterior;
        $anterior = $size;
    }
    return "\\" . $resp;
   
}

sub getLineCollumns{
      my ($separator,$line) = @_;
    $line  =~  s/\r\n//g;
    my @result = +(split( $separator, $line));
    return @result;
}

sub queryHead {
  my ($table,@fieldsArray) = @_;

  my $output = "/*!40103 SET TIME_ZONE='+00:00' */;
--
-- Table structure for table `$table`
--

DROP TABLE IF EXISTS `$table`;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `$table` (";

  foreach (@fieldsArray) {
    $output .= $_ . " text,";
  }
  $output .= "`created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP";
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