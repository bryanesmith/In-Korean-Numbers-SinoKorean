use Test::More;
use utf8;
use FindBin;
use lib "$FindBin::Bin/../lib";
use In::Korean::Numbers::SinoKorean;

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Source: http://stackoverflow.com/questions/492838/why-do-my-perl-tests-fail-with-use-encoding-utf8
my $builder = Test::More->builder;
binmode $builder->output,         ":utf8";
binmode $builder->failure_output, ":utf8";
binmode $builder->todo_output,    ":utf8";

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

my %tests = (
  0 => "\x{C601}",
  1 => "\x{C77C}",
  2 => "\x{C774}",
  3 => "\x{C0BC}",
  4 => "\x{C0AC}",
  5 => "\x{C624}",
  6 => "\x{C721}",
  7 => "\x{CE60}",
  8 => "\x{D314}",
  9 => "\x{AD6C}",
  10 => "\x{C2ED}" ,
  11 => "\x{C2ED}\x{C77C}" ,
  12 => "\x{C2ED}\x{C774}" ,
  13 => "\x{C2ED}\x{C0BC}" ,
  14 => "\x{C2ED}\x{C0AC}" ,
  15 => "\x{C2ED}\x{C624}" ,
  16 => "\x{C2ED}\x{C721}" ,
  17 => "\x{C2ED}\x{CE60}" ,
  18 => "\x{C2ED}\x{D314}" ,
  19 => "\x{C2ED}\x{AD6C}" ,
  20 => "\x{C774}\x{C2ED}" ,
  21 => "\x{C774}\x{C2ED}\x{C77C}" ,
  22 => "\x{C774}\x{C2ED}\x{C774}" ,
  23 => "\x{C774}\x{C2ED}\x{C0BC}" ,
  24 => "\x{C774}\x{C2ED}\x{C0AC}" ,
  25 => "\x{C774}\x{C2ED}\x{C624}" ,
  26 => "\x{C774}\x{C2ED}\x{C721}" ,
  27 => "\x{C774}\x{C2ED}\x{CE60}" ,
  28 => "\x{C774}\x{C2ED}\x{D314}" ,
  29 => "\x{C774}\x{C2ED}\x{AD6C}" ,
  30 => "\x{C0BC}\x{C2ED}" ,
  31 => "\x{C0BC}\x{C2ED}\x{C77C}" ,
  40 => "\x{C0AC}\x{C2ED}" ,
  41 => "\x{C0AC}\x{C2ED}\x{C77C}" ,
  50 => "\x{C624}\x{C2ED}" ,
  51 => "\x{C624}\x{C2ED}\x{C77C}" ,
  60 => "\x{C721}\x{C2ED}" ,
  61 => "\x{C721}\x{C2ED}\x{C77C}" ,
  70 => "\x{CE60}\x{C2ED}" ,
  71 => "\x{CE60}\x{C2ED}\x{C77C}" ,
  80 => "\x{D314}\x{C2ED}" ,
  81 => "\x{D314}\x{C2ED}\x{C77C}" ,
  90 => "\x{AD6C}\x{C2ED}" ,
  91 => "\x{AD6C}\x{C2ED}\x{C77C}" ,
  100 => "\x{BC31}" ,
  1000 => "\x{CC9C}" ,
  1111=>"\x{CC9C}\x{BC31}\x{C2ED}\x{C77C}",
  5231 => "\x{C624}\x{CC9C}\x{C774}\x{BC31}\x{C0BC}\x{C2ED}\x{C77C}",
  11000=>"\x{B9CC}\x{CC9C}",
  100000=>"\x{C2ED}\x{B9CC}",
  500000=>"\x{C624}\x{C2ED}\x{B9CC}",
  692824=>"\x{C721}\x{C2ED}\x{AD6C}\x{B9CC}\x{C774}\x{CC9C}\x{D314}\x{BC31}\x{C774}\x{C2ED}\x{C0AC}",
);

my $test_count = 4 + 4 * scalar keys %tests;
plan tests => $test_count;

my $sk = In::Korean::Numbers::SinoKorean->new;

for my $int ( keys %tests ) {
  
  my $hangul = $tests{ $int };

  is( $sk->getHangul( $int ), $hangul, "Testing object-oriented: " . $int . " => " . $hangul );

  is( In::Korean::Numbers::SinoKorean::getHangul( $int ), $hangul, "Testing procedural: " . $int . " => " . $hangul );

  is( $sk->getInt( $hangul ), $int, "Testing object-oriented: " . $hangul . " => " . $int );

  is( In::Korean::Numbers::SinoKorean::getInt( $hangul ), $int, "Testing procedural: " . $hangul . " => " . $int );
}

# Silently ignore too many args
is( $sk->getHangul( 1, 2 ), "\x{C77C}", "Should ignore exessive arguments." );

# Undef if no args
is( $sk->getHangul(), undef, "Should be undefined if no arguments." );

# Undef if not positive integer
is( $sk->getHangul( -1), undef, "Should be undefined if negative argument." );
is( $sk->getHangul( 1.5), undef, "Should be undefined if not an integer." );

done_testing();
