package MODULES::Functions;

use strict;
use warnings;
use diagnostics;
use LWP::Simple;
use Digest::MD5;
use Data::Dumper;

sub                 saveAnnotationToFile {
    my $id      = $_[0];
    my $dir     = $_[1];
    my $url = 'http://www.informatics.jax.org/allele/report.txt?phenotype=Full+Mammalian+Phenotype+%28MP%29+Ontology+&nomen=' . $id;
    chomp $url;
    $url   .= '&chromosome=any&cm=&coordinate=&coordUnit=bp';
    
    my $content = get $url;
    if(defined $content)
    {
        print "Success: ".$url."\n";
        my $fastaFile   = $dir."/".$id.".txt";
        open( FILE, '>', $fastaFile) or die("Could not open file ".$fastaFile." !");
        print FILE $content."\n";
        close (FILE);
    }
    else
    {
        print "Couldn't get ".$url." \n";
    }
}

sub                 generateMD5 {
    my $string = $_[0];
    
    my $ctx = Digest::MD5->new;
    $ctx->add($string);
    my $digest = $ctx->hexdigest;
    
    return $digest;
}

my @matrix     = ();

sub                 toMatrix {
    
    my $phenotypes = $_[0];
    my $nr         = $_[1];
    my $count      = $_[2];
    my $csvFile    = $_[3];
   
    open(my $fh, '>', $csvFile) or die "Cannot open $csvFile!";

    my @phenotypes_array = "";
    my @nr_array = "";
    my $value;
    my @aux = "";

    my @phenotypes_aux = split(/,/,$phenotypes);
    my @nr_aux = split(/,/,$nr);
    my @count_aux = split(/,/, $count);

    @aux = split(/,/,$phenotypes);
    foreach $value (@aux){
        push(@phenotypes_array,$value) unless grep{$_ eq $value} @phenotypes_array;
    }

    @aux = split(/,/,$nr);
    foreach $value (@aux){
        push(@nr_array,$value) unless grep{$_ eq $value} @nr_array;
    }

    @aux = split(/,/,$count);

    my $len_col = scalar(@phenotypes_array);
    my $len_row = scalar(@nr_array);

    for (my $i=0; $i < $len_col; $i++){
        $matrix[0][$i] = $phenotypes_array[$i];
    }

    for (my $j = 0; $j < $len_row; $j++){
        $matrix[$j][0] = $nr_array[$j];
    }

    for (my $u = 0; $u < scalar(@phenotypes_aux); $u++){
        my $pheno = $phenotypes_aux[$u];
        my $nr = $nr_aux[$u];
        my $cnt = $count_aux[$u];

        fillMatrix($pheno,$nr,$cnt,$len_col,$len_row);

    }

    open($fh, '>>', $csvFile) or die "Cannot open $csvFile!";
    for (my $q=0; $q < $len_row; $q++){
            my $line = '';
            for (my $p = 0; $p < $len_col; $p++){
                if(!defined $matrix[$q][$p]){
                    $matrix[$q][$p] = 0;
                }
                $line .= ','.$matrix[$q][$p];
            }
            $line =~ s/.//;
            print $fh $line."\n";
        
    }
    close $fh;
}

sub fillMatrix{

    my $pheno = $_[0];
    my $nr = $_[1];
    my $cnt = $_[2];
    my $len_col = $_[3];
    my $len_row = $_[4];
    my $index_col = "";
    my $index_row = "";

    for (my $i=0; $i < $len_col; $i++){
        if($matrix[0][$i] eq $pheno){
            $index_col = $i;
            for (my $j = 0; $j < $len_row; $j++){
                if($matrix[$j][0] eq $nr){
                    $index_row = $j;
                }
            }
        }
    }
    if (defined $index_row && defined $index_col){
        $matrix[$index_row][$index_col] = $cnt;
    }
    

}

1;

__END__



