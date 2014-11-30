require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # section-4.3.2.4
  #
  #
  # Media Segments MAY be encrypted.  The EXT-X-KEY tag specifies how to
  # decrypt them.  It applies to every Media Segment that appears between
  # it and the next EXT-X-KEY tag in the Playlist file with the same
  # KEYFORMAT attribute (or the end of the Playlist file).  Two or more
  # EXT-X-KEY tags with different KEYFORMAT attributes MAY apply to the
  # same Media Segment if they ultimately produce the same decryption
  # key.  The format is:

  # #EXT-X-KEY:<attribute-list>

  # The following attributes are defined:

  # METHOD

  # The value is an enumerated-string that specifies the encryption
  # method.  This attribute is REQUIRED.

  # The methods defined are: NONE, AES-128, and SAMPLE-AES.

  # An encryption method of NONE means that Media Segments are not
  # encrypted.  If the encryption method is NONE, other attributes MUST
  # NOT be present.

  # An encryption method of AES-128 signals that Media Segments are
  # completely encrypted using the Advanced Encryption Standard [AES_128]
  # with a 128-bit key, Cipher Block Chaining, and PKCS7 padding
  # [RFC5652].  CBC is restarted on each segment boundary, using either
  # the IV attribute value or the Media Sequence Number as the IV; see
  # Section 5.2.  The URI attribute is REQUIRED for this METHOD.

  # An encryption method of SAMPLE-AES means that the Media Segments
  # contain media samples, such as audio or video, that are encrypted
  # using the Advanced Encryption Standard [AES_128].  How these media
  # streams are encrypted and encapsulated in a segment depends on the
  # media encoding and the media format of the segment.  The encryption
  # format for H.264 [H_264], AAC [ISO_14496] and AC-3 [AC_3] media
  # streams is described by [SampleEnc].  The IV attribute MAY be
  # present; see Section 5.2.

  # URI

  # The value is a quoted-string containing a URI that specifies how to
  # obtain the key.  This attribute is REQUIRED unless the METHOD is
  # NONE.

  # IV

  # The value is a hexadecimal-sequence that specifies a 128-bit unsigned
  # integer Initialization Vector to be used with the key.  Use of the IV
  # attribute REQUIRES a compatibility version number of 2 or greater.
  # See Section 5.2 for when the IV attribute is used.

  # KEYFORMAT

  # The value is a quoted-string that specifies how the key is
  # represented in the resource identified by the URI; see Section 5 for
  # more detail.  This attribute is OPTIONAL; its absence indicates an
  # implicit value of "identity".  Use of the KEYFORMAT attribute
  # REQUIRES a compatibility version number of 5 or greater.

  # KEYFORMATVERSIONS

  # The value is a quoted-string containing one or more positive integers
  # separated by the "/" character (for example, "1/3").  If more than
  # one version of a particular KEYFORMAT is defined, this attribute can
  # be used to indicate which version(s) this instance complies with.
  # This attribute is OPTIONAL; if it is not present, its value is
  # considered to be "1".  Use of the KEYFORMATVERSIONS attribute
  # REQUIRES a compatibility version number of 5 or greater.

  # If the Media Playlist file does not contain an EXT-X-KEY tag then
  # Media Segments are not encrypted.

  # See Section 5 for the format of the key file, and Section 5.2,
  # Section 6.2.3 and Section 6.3.6 for additional information on Media
  # Segment encryption.
  class EXT_X_KEY < AttributeTag
    def initialize(tags, tn = 'EXT-X-KEY')
      @min_version = 1
      @playlist_compatability = PlaylistCompatability::MEDIA

      super(tags, tn)
    end

    def define_attributes
      @_ts.create_attributes(%w(METHOD URI IV KEYFORMAT KEYFORMATVERSIONS))
    end

    def define_constraints
      required_attribute_constraint('METHOD')
      nil_value_constraint
    end

    def define_attribute_constraints
      restricted_attribute_value_constraint('METHOD', %w(NONE AES-128 SAMPLE-AES))
      value_excludes_attribute_constraint('METHOD', 'NONE', 'URI')
      value_excludes_attribute_constraint('METHOD', 'NONE', 'IV')
      value_excludes_attribute_constraint('METHOD', 'NONE', 'KEYFORMAT')
      value_excludes_attribute_constraint('METHOD', 'NONE', 'KEYFORMATVERSIONS')

      value_requires_attribute_constraint('METHOD', 'AES-128', 'URI')
      value_requires_attribute_constraint('METHOD', 'SAMPLE-AES', 'URI')

      quoted_string_value_constraint('KEYFORMAT')

      @_ts['IV'] << AttributeConstraint.new('IV is invalid') do | attr |
        _all_int?([attr.value]) && attr.value.to_s[0..1] == '0x'
      end

      quoted_string_value_constraint('KEYFORMATVERSIONS')

      @_ts['KEYFORMATVERSIONS'] << AttributeConstraint.new('KEYFORMATVERSIONS is invalid') do | attr |
        _all_int?(attr.value.tr('"','').split('/'))
      end

      uri_value_constraint('URI')
    end
  end
end
