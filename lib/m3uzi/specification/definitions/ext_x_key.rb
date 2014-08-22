module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13#section-3.4.4
  def define_ext_x_key(kn = 'EXT-X-KEY')
    create_ts(kn) do | ts |
      ts.add_constraint do | tag |
        # METHOD is required
        tag.attributes['METHOD'].nil? == false
      end

      ts.add_constraint do | tag |
        # value must be nil
        tag.value.nil? == true
      end

      ts.add_attribute('METHOD') do | attr |
        # Valid values
        %w(NONE AES-128 SAMPLE-AES).include?(attr.value)
      end

      # Untested - exclusive - not working at 2:12am
      #ts['METHOD'].add_constraint do | attr |
        #%w(URI IV KEYFORMAT KEYFORMATVERSIONS).each do | k |
          ##valid_attribute?('METHOD', k) ? false : true
        #end unless val == 'NONE'
      #end

      ts.add_attribute('URI') do | attr |
        # must only be present if the METHOD is AES-128 or SAMPLE-AES
        %w(AES-128 SAMPLE-AES)
          .include?(attr.parent_tag.attributes['METHOD'].value)
      end

      #ts['URI'].add_constraint do | attr |
        ## must be a valid uri
      #end

      ts['URI'].add_constraint do | attr |
        # must NOT be present if METHOD == NONE
        (attr.parent_tag.attributes['METHOD'].value != 'NONE') &&
          !attr.parent_tag.attributes['URI'].nil?
      end

      ts.add_attribute('IV') do | attr |
      end

      ts.add_attribute('KEYFORMAT') do | attr |
      end

      ts.add_attribute('KEYFORMATVERSIONS') do | attr |
      end
    end
  end
end
