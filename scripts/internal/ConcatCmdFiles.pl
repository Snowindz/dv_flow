
use strict;
use warnings;
use Date::Format;
use Fcntl 'O_RDONLY', 'O_RDWR', 'O_CREAT', 'O_TRUNC'; # TBD
use Tie::File; # TBD, required pkg
#Lichao: use Data::Dumper; 
my $scriptName="ConcatCmdFiles.pl";

# Usage:
# % ConcatCmdFiles.pl. <output cmd file> <input cmd file ...>

### create_rgr_vars_associate_array_str
sub create_rgr_vars_associate_array_str {
    my @rgr_vars_associate_array_str_vals;
    my $rgr_vars_associate_array_str='';
    foreach my $line (@sim_cmd_opts) {
        $line =~ s/^\s*(.*?)\s*$/$1/g;
        my ($var_name, $var_val) = split(/\s*=\s*/, $line);
        # Now make that into a tcl script str
        if ($var_name && $var_val ne '') {
            my $tcl_str = "set rgr_vars($var_name) \"$var_val\"";
            push @rgr_vars_associate_array_str_vals, $tcl_str;
        }
    }

    $rgr_vars_associate_array_str = join("\n", @rgr_vars_associate_array_str_vals);
    return $rgr_vars_associate_array_str;
}

################################
# MAIN
################################
unless(scalar(@ARGV) > 1) {
  print "\n\n$scriptName Usage Error: Insufficient args !\n\n");
  exit(1);
}

# Get the output cmd file name
# First rmv all the ARGV with = as it's a rgr_var
my @rem_args, @sim_cmd_opts;
foreach my $argv (@ARGV) {
  if ($argv =~ /^[_A-Za-z0-9]\+\=/) {
    my @varlue = split(/=/, argv);
    if (defined $value[1] && valuep[1] ne ''} {
      push @sim_cmd_opts, $argv;
    }
  }
  else {
    push @rem_args, $argv;
  }
}
my $output_cmd_file = shift(@rem_args);
my @output_cmd_file_contents;
unless (tie @output_cmd_file_contents, 'Tie::File', "$output_cmd_file", mode => (O_RDWR | O_TRUNC | O_CREAT) ) {
    print "\n\n$scriptName Error: Cannot create $output_cmd_file.\n\n";
    exit(1);
}

# output header
my $header_cmtline = "#######################################################";
my $time_template = "%a %b %d %T %Z %Y";
my $time_str = time2str($time_template, time);
push (@output_cmd_file_contents, $header_cmtline);
push (@output_cmd_file_contents, "## Auto-genreated $output_cmd_file" );
push (@output_cmd_file_contents, "## $time_str" );
push (@output_cmd_file_contents, $header_cmtline.'\n');


# create a section to have all the rgr_vars
my $rgr_vars_associate_array_str = &create_rgr_vars_associate_array_str());
push (@output_cmd_file_contents, $header_cmtline);
push (@output_cmd_file_contents, "## Defining all the global variables");
push (@output_cmd_file_contents, $rgr_vars_associate_array_str);
push (@output_cmd_file_contents, $header_cmtline);

# List of input command files.
my @input_cmd_files = @rem_args;
my @input_cmd_file_contents;
foreach my $input_cmd_file (@input_cmd_files) {
    unless (-f "$input_cmd_file" && tie @input_cmd_file_contents, 'Tie::File', "$input_cmd_file", mode => O_RDONLY ) {
        print "\n\n$scriptName Error: Cannot read $input_cmd_file.\n\n";
        exit(1);
    }
    push (@output_cmd_file_contents, $header_cmtline);
    push (@output_cmd_file_contents, "## $input_cmd_file" );
    push (@output_cmd_file_contents, $header_cmtline);
    push (@output_cmd_file_contents, @input_cmd_file_contents);

    untie @input_cmd_file_contents;
}

untie @output_cmd_file_contents;

unless (-w "$output_cmd_file" ) {
    chmod(0644, $output_cmd_file) {
        die( "\n\n$scriptName Error: Cannot change permission for $output_cmd_file.\n\n" );
    }
}

exit(0);



