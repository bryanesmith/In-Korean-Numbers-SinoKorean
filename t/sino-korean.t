use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";
use In::Korean::Numbers::SinoKorean;

my %tests = (
  0 => '공',
  1 => '일' ,
  2 => '이' ,
  3 => '삼' ,
  4 => '사' ,
  5 => '오' ,
  6 => '육' ,
  7 => '칠' ,
  8 => '팔' ,
  9 => '구' ,
  10 => '십' ,
  11 => '십일' ,
  12 => '십이' ,
  13 => '십삼' ,
  14 => '십사' ,
  15 => '십오' ,
  16 => '십육' ,
  17 => '십칠' ,
  18 => '십팔' ,
  19 => '십구' ,
  20 => '이십' ,
  21 => '이십일' ,
  22 => '이십이' ,
  23 => '이십삼' ,
  24 => '이십사' ,
  25 => '이십오' ,
  26 => '이십육' ,
  27 => '이십칠' ,
  28 => '이십팔' ,
  29 => '이십구' ,
  30 => '삼십' ,
  31 => '삼십일' ,
  40 => '사십' ,
  41 => '사십일' ,
  50 => '오십' ,
  51 => '오십일' ,
  60 => '육십' ,
  61 => '육십일' ,
  70 => '칠십' ,
  71 => '칠십일' ,
  80 => '팔십' ,
  81 => '팔십일' ,
  90 => '구십' ,
  91 => '구십일' ,
  100 => '백' ,
  1000 => '천' ,
  1111=>'천백십일',
  5231 => '오천이백삼십일',
  11000=>'만천',
  100000=>'십만',
  500000=>'오십만',
  692824=>'육십구만이천팔백이십사',
);

plan tests => 2 * scalar keys %tests ;

my $sk = In::Korean::Numbers::SinoKorean->new;

for my $key ( keys %tests ) {
  my $expected = $tests{ $key };

  is( $sk->getHangul( $key ), $expected, 'Testing object-oriented: ' . $key . ' => ' . $expected );

  is( In::Korean::Numbers::SinoKorean::getHangul( $key ), $expected, 'Testing procedural: ' . $key . ' => ' . $expected );
}


