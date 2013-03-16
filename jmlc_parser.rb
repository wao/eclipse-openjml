class JmlcParser
    def initialize
        @status = :wait_dash
    end

    def parse(line)
        #puts "status: #{@status}, line #{line}"
        case @status
        when :wait_dash
            if line =~ /^-*\s*$/
                @status = :wait_position
            end

        when :wait_position
            if line =~ /(\d*)\. ERROR in (.*) \(at line (\d*)\)/
                @status = :wait_message
                @message = []
                @error_file = $2
                @error_line = $3
            else
                @status = :wait_dash
            end

        when :wait_message
            if line =~ /^-+\s*$/
                #puts "file %s, line %s\n%s" % [ @error_file, @error_line, @message.join("\n") ]
                yield @error_file, @error_line, @message.slice(2,@message.length-2).join("\n")
                @status = :wait_position
            else
                @message << line
            end
        end
    end
end

class XmlErrorBuilder
    def initialize(output_stream)
        @parser = JmlcParser.new
        @output_stream = output_stream
    end

    def emit(line)
        @output_stream.puts line
    end

    def head
        emit( '<?xml version="1.0" encoding="UTF-8"?>' )
        emit( "<errors>" )
        self
    end

    def tail
        emit( "</errors>" )
        self
    end

    def process( input_stream )
        while line = input_stream.gets
            puts line
            @parser.parse(line) do |errorfile, errorline, message|
                puts "file errorfile: #{errorfile} at #{errorline}:\n #{message}"
                emit( "<error>" )
                emit( "   <file>#{errorfile.encode(:xml => :text)}</file>");
                emit( "   <line>#{errorline}</line>");
                emit( "   <message>#{message.encode(:xml => :text)}}</message>");
                emit( "</error>" )
            end
        end
        self
    end
end
