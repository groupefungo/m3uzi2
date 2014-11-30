# ==== Description
# We have some split 'edge cases' e.g.
#
#   METHOD=NONE                                  - single value
#   IV=blah,CODECS="first,second,etc"            - splitting by ',' fails
#   URI="https://priv.example.com/key.php?r=52"  - splittng by '=' fails
#
#   1 method to split them all
module SafeSplit

  private

  # TODO: Nicer method which doesnt split incorrectly in the first place
  def safe_split(str)
    return [] if str.size == 0

    # does the str contain a "? if not do a simple split.
    return str.split(',').map { | arr | arr.split('=') } unless str
      .include?('"')

    # split by comma first, restoring mistakenly split strings,
    # then split by equals (=)
    restore_split(str, ',').map { | arr | restore_split(arr, '=') }
  end

  # reassemble strings which have been split within quotation marks
  def restore_split(string, chr)
    result, tmp = [], ''

    # Hideous code follows
    string.split(chr).each do | attr |
      if attr.count('"') == 1 || tmp.count('"') == 1
        tmp << attr << chr
        next unless tmp.count('"') == 2
      end

      result << attr if tmp.size == 0

      if tmp.count('"') == 2
        result << tmp[0..-2]
        tmp = ''
      end
    end
    result
  end
end
