################################################################################
#
#            !!!!!   Do NOT edit this file directly!   !!!!!
#
#            Edit mktests.PL and/or parts/inc/variables instead.
#
#  This file was automatically generated from the definition files in the
#  parts/inc/ subdirectory by mktests.PL. To learn more about how all this
#  works, please read the F<HACKERS> file that came with this distribution.
#
################################################################################

use FindBin ();

BEGIN {
  if ($ENV{'PERL_CORE'}) {
    chdir 't' if -d 't';
    unshift @INC, '../lib' if -d '../lib' && -d '../ext';
    require Config; Config->import;
    use vars '%Config';
    if (" $Config{'extensions'} " !~ m[ Devel/PPPort ]) {
      print "1..0 # Skip -- Perl configured without Devel::PPPort module\n";
      exit 0;
    }
  }

  use lib "$FindBin::Bin";
  use lib "$FindBin::Bin/../parts/inc";

  die qq[Cannot find "$FindBin::Bin/../parts/inc"] unless -d "$FindBin::Bin/../parts/inc";

  sub load {
    require 'testutil.pl';
    require 'inctools';
  }

  if (52) {
    load();
    plan(tests => 52);
  }
}

use Devel::PPPort;
use strict;
BEGIN { $^W = 1; }

package Devel::PPPort;
use vars '@ISA';
require DynaLoader;
@ISA = qw(DynaLoader);
Devel::PPPort->bootstrap;

package main;

ok(Devel::PPPort::compare_PL_signals());

ok(!defined(&Devel::PPPort::PL_sv_undef()));
ok(&Devel::PPPort::PL_sv_yes());
ok(!&Devel::PPPort::PL_sv_no());
is(&Devel::PPPort::PL_na("abcd"), 4);
is(&Devel::PPPort::PL_Sv(), "mhx");
ok(defined &Devel::PPPort::PL_tokenbuf());
ok("$]" >= 5.009005 || &Devel::PPPort::PL_parser());
ok(&Devel::PPPort::PL_hexdigit() =~ /^[0-9a-zA-Z]+$/);
ok(defined &Devel::PPPort::PL_hints());
is(&Devel::PPPort::PL_ppaddr("mhx"), "MHX");

for (&Devel::PPPort::other_variables()) {
  ok($_ != 0);
}

{
  my @w;
  my $fail = 0;
  {
    local $SIG{'__WARN__'} = sub { push @w, @_ };
    ok(&Devel::PPPort::dummy_parser_warning());
  }
  if ("$]" >= 5.009005) {
    ok(@w >= 0);
    for (@w) {
      print "# $_";
      unless (/^warning: dummy PL_bufptr used in.*module3.*:\d+/i) {
        warn $_;
        $fail++;
      }
    }
  }
  else {
    ok(@w == 0);
  }
  is($fail, 0);
}

ok(&Devel::PPPort::no_dummy_parser_vars(1) >= ("$]" < 5.009005 ? 1 : 0));

eval { &Devel::PPPort::no_dummy_parser_vars(0) };

if ("$]" < 5.009005) {
  is($@, '');
}
else {
  if ($@) {
    print "# $@";
    ok($@ =~ /^panic: PL_parser == NULL in.*module2.*:\d+/i);
  }
  else {
    ok(1);
  }
}
