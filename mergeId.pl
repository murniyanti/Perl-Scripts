
#more than one line have same id but different info. 
#we want to merge the info for the same id.
#to use it: perl mergeId.pl <file>

my $ofile = $ARGV[0];
open FH, $ofile;
$file = "result.murni";
open WFH, '>', $file;
my $line = <FH>;
my $repeat = 0;
my $merge='';


print $lastline;
while ($line) {

chomp $line;
my $nextline = <FH>;
print "\nthe last currentline : $line\n";
print "the last nextline: $nextline\n";
if ( !$nextline ) {
	print "OK";
	if ($repeat==0) {
		print WFH "$line";
	}
	else {
		print WFH "@cl[0]\t@cl[1]\t$merge\n";
		print "MERGE : $merge\n";
		$repeat = 0;
		$merge =undef;
	}
	last;
}

else {
	
	#print "MY line : $line";
	#print "Next line : $nextline\n";

	@cl = split(/\t/, $line);
	@nl = split(/\t/, $nextline);

	if ( @cl[0] =~ @nl[0] ) {
		#print "R : $repeat\n";
		chomp @cl[2];
		chomp @nl[2];

		if ($repeat == 0) {

			if (@cl[2]) {
			#print "CL : @cl[2], nl : @nl[2]";
				$merge = @cl[2].'|'.@nl[2]; 
			}
			else {
				$merge = @cl[2].@nl[2];
			}
			#print "MERGE : $merge\n";
			#$merge = join('|', @cl[2], @nl[2]);
		}
		else {
			chomp $merge;
			$merge.'|'.@nl[2];
		}
		$repeat++;
	}
	else {
		if ($repeat == 0) {
			print WFH "@cl[0]\t@cl[1]\t@cl[2]\n";

			
		}
		else {
			print WFH "@cl[0]\t@cl[1]\t$merge\n";
			print "MERGE : $merge\n";
			$repeat = 0;
			$merge =undef;
		}
	}

	$line = $nextline;
}
}
close FH;
close WFH;
