use strict;
use warnings;
use ExtUtils::MakeMaker;
use Devel::CallChecker;
use Devel::CallParser;

sub write_header {
    my ($h, $src) = @_;
    open my $fh, '>', $h or die $!;
    print { $fh } $src or die $!;
    close $fh or die $!;
}

write_header 'callchecker0.h', Devel::CallChecker::callchecker0_h();
write_header 'callparser.h', Devel::CallParser::callparser1_h();

WriteMakefile(
    NAME => 'Map::Functional',
);
