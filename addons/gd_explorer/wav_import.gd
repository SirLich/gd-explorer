extends RefCounted
class_name WavImporter

#Take a Packed Byte Array and reverse it to read little endian data to an integer
static func read_le_int(file:FileAccess, byte_size:int):
	var file_buffer:PackedByteArray = file.get_buffer(byte_size)
	file_buffer.reverse()
	return file_buffer.hex_encode().hex_to_int()

static func load_wav(path:String):
	var wav_file:AudioStreamWAV = AudioStreamWAV.new()
	var file:FileAccess = FileAccess.open(path, FileAccess.READ)
	
	#CHUNK ID
	var file_buffer:PackedByteArray = file.get_buffer(4)
	if(file_buffer.get_string_from_ascii() != "RIFF"):
		push_error("[load_wav] Invalid file type - not RIFF")
		return false
	#CHUNK SIZE - Full byte size minus first 8 bytes
	var chunk_size:int = read_le_int(file, 4)
	var real_size:int = file.get_length()-8
	if(chunk_size != real_size):
		push_error("[load_wav] Chunk size does not match. Chunk: ", chunk_size,". Expected: ",real_size)
		return false
	#FORMAT
	file_buffer = file.get_buffer(4)
	if(file_buffer.get_string_from_ascii() != "WAVE"):
		push_error("[load_wav] Invalid file type - not WAVE")
		return false
	#SUB CHUNK1 ID
	file_buffer = file.get_buffer(4)
	if(file_buffer.get_string_from_ascii() != "fmt "):
		push_error("[load_wav] Invalid file type - not fmt")
		return false
	#SUB CHUNK1 SIZE
	var s_chunk1_size:int = read_le_int(file, 4)
	if(s_chunk1_size != 16):
		push_error("[load_wav] Unsupported type. Only supports PCM.")
		return false
	#AUDIO FORMAT
	var audio_format:int = read_le_int(file, 2)
	if(audio_format != 1):
		push_error("[load_wav] Unsupported type. Only supports PCM.")
		return false
	#NUMBER OF CHANNELS
	var channels:int = read_le_int(file, 2)
	if(channels > 2):
		push_error("[load_wav] Unsupported channel amount. Only supports Mono or Stereo.")
		return false
	#SAMPLE RATE
	var sample_rate:int = read_le_int(file, 4)
	#BYTE RATE = SampleRate*NumChannels*BitsPerSample/8
	var byte_rate:int = read_le_int(file, 4)
	#Block Align = NumChannels*BitsPerSample/8
	var block_align:int = read_le_int(file, 2)
	#BITS PER SAMPLE
	var bit_rate:int = read_le_int(file, 2)
	#"DATA" TEXT
	file_buffer = file.get_buffer(4)
	if(file_buffer.get_string_from_ascii() != "data"):
		push_error("[load_wav] Invalid file type - not 'data'")
		return false
	#AUDIO DATA SIZE
	var audio_data_size:int = read_le_int(file, 4)
	
	
	#Confirming values
	var expected_byte_rate:float = sample_rate * channels * bit_rate / 8.0
	if(byte_rate != expected_byte_rate):
		push_error("[load_wav] Invalid formatting, byte rate incorrect.")
		return false
	
	var expected_block_align:float = channels * bit_rate / 8.0
	if(block_align != expected_block_align):
		push_error("[load_wav] Invalid formatting, block align incorrect.")
		return false
	####Adding Data to AudioStreamWAV####
	match(bit_rate):
		8:
			wav_file.format = AudioStreamWAV.FORMAT_8_BITS
		16:
			wav_file.format = AudioStreamWAV.FORMAT_16_BITS
		_:
			push_error("[load_wav] Unsupported bit rate")
			return false
	
	wav_file.mix_rate = sample_rate
	if(channels == 2):
		wav_file.stereo = true
	else:
		wav_file.stereo = false
	
	#Audio Data's starting offset is the full file size minus the difference between chunk size and audio data size, minus 8 for the 8 bytes not included in chunk size
	wav_file.data = file.get_buffer(file.get_length()-(chunk_size-audio_data_size)-8)
	
	return wav_file
