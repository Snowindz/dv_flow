use strict;
use warnings;
use File::Basename;
use File::Slurp;
my $scriptName="CheckSignature";

my $g_max_history = 50;
my $g_time_str = localtime; $g_time_str =~ s/\s+/_/g;
my $g_user = $ENV{'USER'} || '';
my $g_lsf_jobid = $ENV{'LSB_BATCH_JID'} || '';
my $g_submit_host = $ENV{'HOST'} || '';
my $g_exec_host = $ENV{'LSF_HOSTS'} ||$ENV{'HOST'} || '';


# saveSignature write the signature to the signature file
sub saveSignature{
    my $h = shift(@_);
    my $s = shift(@_);
    my $history_str;

    if ( ! -d dirname($h)) {
        !system('\\mkdir -p ' . dirname($h)) or die("$!\n");
    }

    my @lines = ();
    if (! -z $h && -f $h) {
        @lines = read_file($h) or die("\n\n$scriptName Error: Cannot open file $h: $!. \n\n");
    }

    $history_str = "time=$g_time_str;user=$g_user;submit_host=$g_submit_host;exec_host=$g_exec_host;lsf_job=$g_lsf_jobid";
    $history_str =~ s/\s+/_/g;
    unshift (@lines, "$history_str, " . $s . "\n");
    if (scalar(@lines) > $g_max_history) {
        pop @lines;
    }

    write_file($h, @lines) or die("\n\n$scriptName Error: Cannot write to signature recored $h.\n\n");
}

#======================
# MAIN
#======================
my $history = shift(@ARGV);
my @input_data = @ARGV;

# step1: create signature
my $sig = "";
my $x;
foreach $x (@input_data) {
    $sig .= $x . " ";
}
$sig =~ s/\s+$//g;

# step2: check and update the signature record file
my $create
if (! -z $history && -f $history) {
    my @lines = read_file($history) or die("\n\n$scriptName Error: Cannot open file $history.\n\n");
    my $old_sig = $lines[0] || '';
    chomp($old_sig);
    $old_sig =~ s/^\S+\s//g;

    # write out the new sig if it's different w/ old one
    saveSignature($history, $sig) if ($old_sig ne $sig);
}
else {
    # create sig if it doesn't exist
    saveSignature($history, $sig);
}

exit(0);
