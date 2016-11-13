#!/usr/bin/perl

# Name: MicroarrayAnnotation2Fasta.pl
# Author: Tovah Markowitz
# Date: 2/24/13
# Description: convert a microarray annotation file into a fastA file
# Input: name of annotation file
# Output: Probe sequences in fastA format

use strict;
use Data::Dumper;
use Getopt::Long;
use Pod::Usage;

my ($annotFile, $outputFile);
my $help=0;

# set commandline options. "s" indicates that commandline output is a string
GetOptions ("help" => \$help,
	    "input=s" => \$annotFile,
	    "output=s" => \$outputFile) or pod2usage(2);
pod2usage(1) if $help;

################################################################

# ensure annotation file exists else die
open (IN, "<$annotFile") or die ("Can not find your input file $annotFile: No such file or directory\n");

# set up necessary arrays
my @names;
my @sequences;
my $seqCounter=0;

# for as long as the file has more data:
while (<IN>){
    chomp;
# place every line in one of two arrays

    my @line=split("\t");
# only if row maps to the genome
    if ($line[2] !~ /^0$/) {
# get description and remove quotes
	$names[$seqCounter]=$line[5];
	$names[$seqCounter] =~ s/\"//g;
# get sequence and remove quotes
	$sequences[$seqCounter]=$line[10];
	$sequences[$seqCounter] =~ s/\"//g;
	$seqCounter++;
    }
}

# write FASTA to file
    if ($outputFile) {
	open OUT, ">$outputFile" or die ("Can not open $outputFile for writing.\n");
	for (my $x=1; $x<scalar(@names); $x++) {
	    print OUT 
		">$names[$x]\n$sequences[$x]\n";
	}
	close OUT;
    } else {
	print Dumper (\@sequences);
    }

################################################################

__END__

=head1 SYNOPSIS

MicroarrayAnnotation2Fasta.pl [Options]

Purpose: Use this function to convert a microarray platform file
into a fasta file. The output file will only include sequences
that are designed against a portion of the genome of interest.
This function assumes that the sequence information is located
within the input file and just needs to be extracted.

Example: "perl MicroarrayAnnotation2Fasta.pl -i 'SK1rosetta.txt' 
-o 'SK1rosetta.fa'"

Options:

    -h, --help        brief help message
    -i, --input       input annotation/platform file
    -o, --output      name of the output fasta file

=cut
