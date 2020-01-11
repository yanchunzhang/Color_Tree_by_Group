#! perl -w
use strict;
use Getopt::Long;
##assign color of edge of phylogenetic tree based on tiplabels group;
my ($tiplabel, $edge, $grp, $out, $basecolor);

GetOptions  (
    "tiplabel=s"         => \$tiplabel,
    "out=s"         => \$out,
    "edge=s"         => \$edge,
    "grp=s"         => \$grp,
    "basecolor=s"         => \$basecolor,
);

unless ($tiplabel && $edge && $grp && $out) {
	die "Specify the tiplabel file, edge file, grp file and out filename";
}

unless ($basecolor) {$basecolor = "gray"}

my %tip;
open(TIP, $tiplabel) or die;
while (<TIP>) {
    chomp;
    next unless (/"/);
    $_ =~ s/ "/\t/g;
    $_ =~ s/ +//g;
    $_ =~ s/"//g;
    $_ =~ s/\[//g;
    $_ =~ s/\]//g;
    $_ =~ s/,//g;
    my @l = split /\s+/;
    $tip{$l[0]} = $l[1];
    #print "$l[0]\t$l[1]\n";
}
close TIP;
print scalar localtime;
print ":\tRead tiplabel file done!\n";

my %grp;
open(GRP, $grp) or die;
while (<GRP>) {
    chomp;
    next if (/SAMPLE/);
    $_ =~ s/"//g;
    my @l = split /\s+/;
    $grp{$l[0]} = $l[1];
}
close GRP;
print scalar localtime;
print ":\tRead group file done!\n";

my %edge;
open(EDGE, $edge) or die;
while (<EDGE>) {
    chomp;
    next if (/,\d+/);
    $_ =~ s/ +\[//g;
    $_ =~ s/\[//g;
    $_ =~ s/\]//g;
    $_ =~ s/\,//g;
    my @l = split /\s+/;
    $edge{"info"}{$l[0]} = [$l[1], $l[2]];
    $edge{"sub"}{$l[1]}{$l[2]} = 1;
    $edge{"sup"}{$l[2]}{$l[1]} = 1;
}
close EDGE;
print scalar localtime;
print ":\tRead tre.edge file done!\n\n";


my %color;
my $tipnum = keys %tip;
print "Tipnum: $tipnum\n";
for my $node (sort {$b <=> $a} keys %{$edge{"sup"}}) {
    next if ($node > $tipnum);
    $color{$node} = $grp{$tip{$node}};
}

for my $node (sort {$b <=> $a} keys %{$edge{"sub"}}) {
    print scalar localtime;
    print "\tnode color\tcalc $node";
    my $color = &nodecolor($node);
    $color{$node} = $color;
    print "\t$color\n";
}

open(OUT, "> $out");

for my $line (sort {$a <=> $b} keys %{$edge{"info"}}) {
    my $one = $edge{"info"}{$line}[0];
    my $two = $edge{"info"}{$line}[1];
    
    if ($two <= $tipnum) {
        $edge{"color"}{$line} = $color{$two};
    }
    elsif ($one == ($tipnum+1)) {
        $edge{"color"}{$line} = $color{$two};
    }
    elsif ($color{$one} eq $color{$two}) {
        $edge{"color"}{$line} = $color{$one};
    }
    else {$edge{"color"}{$line} = $basecolor;}
    
    print OUT "$edge{\"color\"}{$line}\n";
}
close OUT;


sub nodecolor {
    my $tip = shift;
    my $tmpcolor;
    
    if ($color{$tip}) {
        $tmpcolor = $color{$tip};
    }
    elsif ($tip <= $tipnum) {
        $tmpcolor = $grp{$tip{$tip}};
    }
    else {
        my @sub = keys %{$edge{"sub"}{$tip}};
        
        my $initial = &nodecolor($sub[0]);
        $tmpcolor = &nodecolor($sub[0]);
        for (my $i=1;$i<@sub;$i++) {
            my $tmp = &nodecolor($sub[$i]);
            $tmpcolor = $basecolor if ($initial ne $tmp);
        }
    }    
    return $tmpcolor;
}
