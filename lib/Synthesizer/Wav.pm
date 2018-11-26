package Synthesizer::Wav {

  use v5.28;
  use Moo;
  use utf8;
  use Types::Standard qw( :types );
  use Type::Utils qw( class_type );
  use Function::Parameters qw( :std );
  use Function::Return;

  # 1byte = 8bit
  use constant ONE_BYTE_BIT_NUM => 8;

  has sound => (
    is       => 'ro',
    isa      => class_type(+{ class => 'Synthesizer::Sound' }),
    required => 1,
  );

  has channel => (
    is      => 'ro',
    isa     => Int,
    default => 1,
  );

  has bits_per_sample => (
    is      => 'ro',
    isa     => Int,
    default => 16,
  );

  has samples_per_sec => (
    is      => 'ro',
    isa     => Int,
    default => 44100,
  );
  
  # 次に鳴るサンプルまでのバイト数，チャンネル数 * 1サンプルあたり1ビット数
  method block_size() :Return(Int) {
    ( $self->channel * $self->bits_per_sample ) / ONE_BYTE_BIT_NUM;
  }

  method size() :Return(Int) {
    $self->sound->data_num * $self->block_size;
  }

  method bytes_per_sec() :Return(Int) {
    $self->block_size * $self->samples_per_sec;
  }

  method header_chunk() :Return(Str) {
    'RIFF'                          # ChunkID
      . pack('L', $self->size + 36) # ChunkSize
      . 'WAVE';                     # FormType
  }

  method fmt_chunk() :Return(Str) {
    'fmt '                                 # ChunkID
      . pack('L', 16)                      # ChunkSize
      . pack('S', 1)                       # WaveFormatType
      . pack('S', $self->channel)          # Channel
      . pack('L', $self->samples_per_sec)  # SamplesPerSec
      . pack('L', $self->bytes_per_sec)    # BytesPerSec
      . pack('S', $self->block_size)       # BlockSize
      . pack('S', $self->bits_per_sample); # BitsPerSample
  }

  method sample_normalize_coef() :Return(Int) {
    2 ** $self->bits_per_sample / 2 - 1;
  }

  method data_chunk() :Return(Str) {
    my $coef = $self->sample_normalize_coef;
    'data'
      . pack('L', $self->size)
      . join('', map { pack('s', int $_ * $coef) } $self->sound->data->@*);
  }

  method chunk() :Return(Str) {
    $self->header_chunk . $self->fmt_chunk . $self->data_chunk;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

wavファイルクラス
