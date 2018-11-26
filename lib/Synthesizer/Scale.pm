package Synthesizer::Scale {

  use Moo;
  use utf8;
  use Types::Standard qw( :types );
  use Function::Parameters qw( :std );

  extends 'Synthesizer::Frequency';

  use constant +{
    # ラ の周波数
    LA_HZ     => 440,
    # 音階の数 (ド ~ シ まで, 半音含む)
    SCALE_NUM => 12,
  };

  has index => (
    is       => 'ro',
    isa      => Int,
    required => 1,
  );

  has '+value' => (
    init_arg => undef,
    lazy     => 1,
    builder  => '_index_to_frequency',
  );

  method _index_to_frequency() {
    $self->LA_HZ * ( 2.0 ** ( $self->index / $self->SCALE_NUM ) );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

音階クラス
