#!/bin/perl

#  Mini Daemon NetSoul Avec Automessage
#  Pour acces interieur/exterieur au reseau Epita/Epitech/Ipsa/Etna
#
#  Par Psykokwak (mamman_j)
#

use strict;

use IO::Socket::INET;
use IO::Select;
use FileHandle;
use Digest::MD5  qw(md5 md5_hex md5_base64);

start:

my $username = 'login_x';
my $location = 'At Home (Daemon)';
my $data     = 'Psykokwak NS v0.2';
my $password = 'mdp socks';
my $automessage = "Desol�, je suis un daemon netsoul et je ne gere pas les messages...";
my $verbose = 0;
my $timeout = 120;



autoflush STDOUT 1;

my $buf_r = '';
my $buf_w = '';
my @fifo = ();


my %key_word = (
	       '^salut' => \&fct_salut,
	       '^rep' => \&fct_reponse,
	       '^ping' => \&fct_ping,
	       '^user_cmd' => \&fct_user_cmd,
	       );



my $socket = new IO::Socket::INET->new( PeerPort=>4242,
                                Proto=>'tcp',
                                PeerAddr=>'ns-server.epita.fr') or retrying(10);

print "Successfuly connected...\n";

loop_select();

sub retrying() {
        my $s = shift;
        print STDERR "Unable to connect. Retrying in ".$s." seconds...\n";
        sleep($s);
        goto start;
        exit(0); 
}

###################################################


sub loop_select()
{
    my $rin;
    my $win;
    my $rout;
    my $wout;

    while (1)
    {
	$rin = '';
	$win = '';
	vec($rin, fileno($socket), 1) = 1;
	vec($win, fileno($socket), 1) = 1 if (length($buf_w));
	select($rout=$rin, $wout=$win, undef, $timeout);
	write_socket() if (vec($wout,fileno($socket),1));
	read_socket() if (vec($rout,fileno($socket),1));
	alive() if (!(vec($wout,fileno($socket),1)) && !(vec($rout,fileno($socket),1)));
    }
}

sub read_socket()
{
    my $buf;
    my $len;

    $len = sysread($socket, $buf, 64);
    if (!$len || $len <= 0)
    {
	print STDERR "L'hote a coupe la connexion (1).\nRestarting...\n";
	goto start;
	exit(0);
    }
    $buf_r = $buf_r.$buf;
    $buf_r =~ s/^[\r\n]+//;
    while ($buf_r =~ m/[\r\n]+/)
    {
	my $line = $`;
	$buf_r = $';
	$line = lc($line);
	print "<< ".$line."\n" if ($verbose);
	parse_cmd($line);
    }
}

sub write_to_socket_buf($)
{
    my $line = shift;

    push(@fifo, $line);
    $buf_w = $buf_w.$line."\r\n";
    print ">> ".$line."\n" if ($verbose);
}

sub write_socket()
{
    my $buf;
    my $len;

    $len = syswrite($socket, $buf_w);
    if (!$len || $len <= 0)
    {
	print STDERR "L'hote a coupe la connexion (2).\nRestarting...\n";
	goto start;
	exit(0);
    }
    $buf_w = substr($buf_w, $len);
}

sub parse_cmd($)
{
    my $line = shift;

    $line =~ s/^[ \t]+//;
    $line =~ s/[ \t]+$//;

    return if ($line eq '');

    foreach my $key (keys(%key_word))
    {
	if ($line =~ $key)
	{
	    my $fct = $key_word{$key};
	    &$fct($line);
	    return ;
	}
    }
    print STDERR "Unknow commande : '".$line."'\n";
}

sub urlEncode
{
    my ($string) = @_;
    $string =~ s/(\W)/"%" . unpack("H2", $1)/ge;
    return $string;
 }

sub urlDecode
{
    my ($string) = @_;
    $string =~ tr/+/ /;
    $string =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    return $string;
}

################################################################

my $fct_salut_hash;
my $fct_salut_host;
my $fct_salut_port;
sub fct_salut($)
{
        if ((my $socket, $fct_salut_hash, $fct_salut_host, $fct_salut_port, my $timestamp) = ($_[0] =~ /^\w+ (\d+) ([0-9abcdef]+) ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+) (\d+) (\d+)/i))
        {
                write_to_socket_buf "auth_ag ext_user none none";
        }
        else
        {
                print STDERR "Command Unreconized...\n";
        }
}

sub fct_ping($)
{
        write_to_socket_buf shift;
        shift(@fifo);
}

sub fct_user_cmd($)
{
        #user_cmd <socket>:user:<trust level>:<login>@<user host>:<workstation type>:<location>:<groupe> | <command> <command extension>
        #user_cmd 525:user:1/3:mycroft@195.220.50.8:~:paul%2Dsud%2Easso%2Eups%2Dtlse%2Efr%20:ext | msg test
        my $line = shift;
        (my $login, my $cmd, my $params) = ($line =~ /^user_cmd \d+:user:\d\/\d:([a-z0-9_]+)@[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[^:]+:[^:]+:[a-z0-9]+ \| (\w+) (.*)/i );
        automsg($login) if ($cmd eq "msg");
}

sub fct_reponse($)
{
        my $cmdline = shift(@fifo);
        (my $cmd) = ($cmdline =~ /(^\w+)/i);
        (my $code) = ($_[0] =~ /^rep (\d+)/);
        res_auth_ag ($code) if ($cmd eq "auth_ag");
        res_alive ($code) if ($cmd eq "alive");
        res_ext_user_log ($code) if ($cmd eq "ext_user_log");
}


################################################################

sub res_auth_ag($)
{
        if (shift eq "002")
        {
                write_to_socket_buf "ext_user_log ".$username." ".md5_hex($fct_salut_hash."-".$fct_salut_host."/".$fct_salut_port.$password)." ".urlEncode($data)." ".urlEncode($location);
        }
        else
        {
                print "Auth Type Error...\n";
                write_to_socket_buf "exit";
                push(@fifo);
                exit(0);
        }
}

sub res_alive($)
{
        # Do some stuff
}

sub res_ext_user_log($)
{
        if (shift eq "002")
        {
                print "Auth Successfully...\n";
                setstate("actif");
        }
        else
        {
                print "Auth Error...\n";
                write_to_socket_buf "exit";
                push(@fifo);
                exit(0);
        }
}

################################################################

sub alive()
{
        write_to_socket_buf "alive";
        if (scalar @fifo > 2)
        {
                print STDERR "Server Not Responding.\nDisconnecting...\n";
                write_to_socket_buf "exit";
        }
}


sub automsg($)
{
        #(cmd|user_cmd) msg_user <login / liste login> msg <message>
        write_to_socket_buf "user_cmd msg_user ".shift(@_)." msg ".urlEncode($automessage);
        shift(@fifo);
}


sub setstate($)
{
        write_to_socket_buf "user_cmd state ".shift;
        shift(@fifo);
}
