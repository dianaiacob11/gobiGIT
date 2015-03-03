package MODULES::Functions;

use strict;
use warnings;
use diagnostics;
use LWP::Simple;
use Digest::MD5;

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

1;

__END__



