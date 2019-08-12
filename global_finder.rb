class GlobalFinder
  # Needs to be pointed to the filename of the original .42m file
  # It pulls data from that file that is not presented in the 
  # `fglrun -r` output
  def initialize(filename)
    @filename = filename
  end

  def data
    @data ||= File.open(@filename,'rb').read
  end

  def get_global_type_index(global_name)
    len = global_name.length + 1
    search_pattern = [len].pack('S<') + global_name + "\x00"
    location = data.index(search_pattern)
    return nil unless location

    location += search_pattern.length
    index, nulls = data[location .. location+3].unpack('S<2')
    return nil unless nulls == 0

    return index
  end
end