#!/usr/bin/env ruby
#------------------------------------------------------------------------------
#  2022-09-12 P.Murat : convert .fcl files into .lua format
#  example: 
#  --------
#           fcl_to_lua.rb  --file=a.fcl
#
# for each .fcl file produces a lua 
#------------------------------------------------------------------------------
# puts "starting ---"

require 'find'
require 'fileutils'
require 'getoptlong'

# puts " emoe"
#-----------------------------------------------------------------------
def usage
  puts "usage: fcl_to_lua --input_dir input_dir"
  exit(-1)
end
#------------------------------------------------------------------------------
# specify defaults for the global variables and parse command line options
#------------------------------------------------------------------------------
$input_dir  = nil
$input_file = nil
$output_dir = nil
#------------------------------------------------------------------------------
class FclToLua
#------------------------------------------------------------------------------
  def verbose() return @verbose ; end

  def parse_command_line()
    
    opts = GetoptLong.new(
      [ "--file"          , "-f",        GetoptLong::REQUIRED_ARGUMENT ],
      [ "--input-dir"     , "-i",        GetoptLong::REQUIRED_ARGUMENT ],
      [ "--output_dir"    , "-o",        GetoptLong::REQUIRED_ARGUMENT ],
      [ "--verbose"       , "-v",        GetoptLong::NO_ARGUMENT       ]
    )

    opts.each do |opt, arg|
    if    (opt == "--verbose"       ) then @verbose        = 1
    elsif (opt == "--file"          ) then $input_file     = arg
    elsif (opt == "--input_dir"     ) then
#-----------------------------------------------------------------------
#  input directory
#-----------------------------------------------------------------------
      if (arg.split("@")[1] != nil) then
        $iuser     = arg.split("@")[0];
        x          = arg.split("@")[1];
      else
        x          = arg;
      end
    elsif (opt == "--output_dir"   ) 
#-----------------------------------------------------------------------
#  output directory
#-----------------------------------------------------------------------
      if ( arg.split("@")[1] != nil ) then
        $ouser     = arg.split("@")[0].strip;
        x          = arg.split("@")[1].strip;
      else
        x          = arg.strip;
      end
      if ( x.split(":")[1] != nil )   then ; #  host and directory are specified
        $ohost      = x.split(":")[0].strip;
        $output_dir = x.split(":")[1].strip;
      else                            ; #  host is not specified
        $output_dir = x.strip;
      end
    elsif (opt == "--output_tcl") then
      $output_tcl=arg
    end

    if (@verbose) ; puts "Option: #{opt}, arg #{arg.inspect}" ; end

    usage if ($list_of_files == nil) && ($pattern == "")
    end
  end
#------------------------------------------------------------------------------
# constructor
#------------------------------------------------------------------------------
  def initialize()
    @verbose    = nil
    parse_command_line();
  end

  def is_number?(obj)
    obj = obj.to_s unless obj.is_a? String
    if (obj[obj.length-1] == '.') then obj = obj+'0'; end
    return /\A[+-]?\d+(\.[\d]+)?\z/.match(obj)
  end 

#------------------------------------------------------------------------------
  def do_per_line_substitutions(line)
    # 1: make sure '=' are space-separated
    # avoid substituions in strings

    q = /".*:.*"/.match(line)

    if (q) then
      q1 = q.to_s
      q2 = q1.gsub(':','^^^')
      line = line.gsub(q1,q2)
    end
    newline =    line.gsub(' : ' ,' = ');
    newline = newline.gsub(': '  ,' = ');
    newline = newline.gsub(' :'  ,' = ');
    
    newline = newline.gsub('::','@@' );
    
    newline = newline.sub(':' ,' = ');

    newline = newline.gsub('[' ,'{'  );
    newline = newline.gsub(']' ,'}'  );
    newline = newline.gsub('}' ,' } '  );
    newline = newline.gsub('{' ,' { '  );
    newline = newline.gsub('//' ,'#' );

    newline = newline.gsub('^^^',':');
    return newline
  end
  
#------------------------------------------------------------------------------  
  def parse_simple(text)
    if (@verbose) ;  puts ">>> parse_simple_1: text:\'#{text}\'" ; end

    # make sure I'm not splitting string values with spaces in them
    q = /".* .*"/.match(text)
    if (q) then
      if (@verbose) ; puts "q:\'#{q.string}\'" ; end
      # replace ' ' with '^^^' within the string
      q1 = q.to_s
      q2 = q1.gsub(' ','^^^')
      if (@verbose) ; puts "q1:#{q1} q2:#{q2}"; end
      
      text = text.gsub(q1,q2)
    end

    w3  = text.gsub(',',' , ').split;

    if (w3[0] == "BEGIN_PROLOG") or (w3[0] == "END_PROLOG") then
      return "-- # "+text;
    end
    
    nw3 = w3.length
    if (@verbose) ;  puts ">>> 130 w3 = #{w3} nw3=#{nw3}" ; end
    outp = ''
    for ind in 0..nw3-1
      w = w3[ind]

      if (w != '{') and (w != '}') and (w != ',') and (! is_number? w) then
        
        if    (w.index('@local@@')   ) then w = w.gsub('@local@@','');
        elsif (w.index('@sequence@@')) then w = w.gsub('@sequence@@','');
        elsif (w.index('@table@@')   ) then w = w.gsub('@table@@','');
        else
          # check for 'true' / 'false'
          if ((w != 'true') and (w != 'false')) then
            w = '"'+w.delete('"')+'"';
          end
        end
      end

      if (ind < nw3-1) then
        if (w != '{') and (w != ',') and (w != ';') then 
          if ((w3[ind+1] != ',') and (w3[ind+1] != ';') and (w3[ind+1] != '}')) then
            w = w+';' ;
          end
        end
      else
        # last word
        # if previous word is not a delimitor, add ';'
        if (w != ',') and (w != ';') and (w != '{') then 
          w = w + ' ; '
        end
      end
      
      if (w == '{') then w = 'new {' end
      
      if (@verbose) then puts ">>> parse_simple 2.0: w: "+w ; end
      outp = outp+w
    end
    
    outp = outp.gsub('^^^',' ');
    if (@verbose) ;  puts ">>> parse_simple_3: outp:\'#{outp}\'" ; end
    return outp;
  end
  
#------------------------------------------------------------------------------
  def parse_assignment(text,comment)

    words = text.split('=')
    if (@verbose) ; puts ">>>> parse_assignment: text:\'#{text}\' comment:\'#{comment}\' nw = #{words.length}" ; end

    if (words.length == 2) then
#------------------------------------------------------------------------------
# one '=' sign
# ww[1] could be more than a number
# check for the presence of an opening bracket '{'
#------------------------------------------------------------------------------
      if (words[1].index('{')) then
        if (words[1].strip == '{') then
#------------------------------------------------------------------------------
# the line ends with '{'
#------------------------------------------------------------------------------
          line = text.gsub('{','new {');
          if (comment) then line = line + ' -- # '+comment; end
          if (@verbose) ; puts "00101 returning: line:#{line}" ; end
          return line;
        else
#------------------------------------------------------------------------------
# the line does have a '{' but doesn't end with it - check for the rest 
#------------------------------------------------------------------------------
          ww2 = words[1].gsub('{',' { ').gsub('}',' } ');
          if (@verbose) ; puts ">>> 0:ww2:#{ww2}" ; end

#          # make sure commas are space-separated from the rest
#          q = /".* .*"/.match(ww2)
#          if (q) then
#            if (@verbose) ; puts "q:\'#{q.string}\'" ; end
#            # replace ' ' with '^^^' within the string
#            q1 = q.to_s
#            q2 = q1.gsub(' ','^^^')
#            if (@verbose) ; puts "q1:#{q1} q2:#{q2}"; end
#            
#            ww2 = ww2.gsub(q1,q2)
#          end

          outp = parse_simple(ww2)
          
          if (@verbose) ; puts "outp:"+outp ; end
          line = words[0] + ' = '+outp ;
          # line = line.gsub('{','new {');
          # line = line.gsub('^^^',' ');
          if (line.strip[-1] == '}') then line = line+';'; end
          if (@verbose) ; puts "001 returning: line:#{line}" ; end
          return line 
        end
      else
#------------------------------------------------------------------------------
# text after '=' doesn't have a '{', suspect a simple number or a string 
#------------------------------------------------------------------------------
        w1 = words[1].strip
        if (@verbose) ; puts "--- w1:#{w1} is_number:#{is_number?w1}" ; end
        if    (w1 == '') then
          line = text ;
          if (comment) ; line = line + ' -- # ' + comment; end
          return line;
        elsif (is_number?w1) then
          line = text + ';';
          if (comment) ; line = line + ' -- # ' + comment; end
          return line
        elsif (w1 == 'true') then
          line = text + ';';
          if (comment) ; line = line + ' -- # ' + comment; end
          return line
        elsif (w1 == 'false') then
          line = text + ';';
          if (comment) ; line = line + ' -- # ' + comment; end
          return line
        elsif (w1.index('@local@@'   )) then
          line = words[0] + '= '+w1.gsub('@local@@','')+' ; '
          if (comment) ; line = line + ' -- # ' + comment; end
          return line;
        elsif (w1.index('@table@@'   )) then
          line = words[0]+'= '+w1.gsub('@table@@','') +' ; '
          if (comment) ; line = line + ' -- # ' + comment; end
          return line
        elsif (w1.index('@sequence@@')) then
          line = words[0]+'= '+w1.gsub('@sequence@@','') +' ; '
          if (comment) ; line = line + ' -- # ' + comment; end
          return line
        else
#-----------------------------------------------------------------------
#  need to check if it is a number on the right
#-----------------------------------------------------------------------
          x1 = words[1].rstrip.lstrip
          # puts ">>> x1:#{x1}"
          if (is_number? x1) then
            newline=words[0] + " = " +x1+';'
          else
            newline = words[0] + " = " + "\""+x1.delete('"')+"\" ;"
          end
          return newline
        end
        # what is this ???
        return "ERROR:"+newline+';'
      end
    elsif (words.length == 3) then
#------------------------------------------------------------------------------
# two '=' signs, first go the 'easy' way
#------------------------------------------------------------------------------
      if (@verbose) ; puts " >>> 3 words[2]:\'#{words[2]}\'" ; end
      # if the last character is not '{', append ';'
      
      if (words[2].strip()[-1] != '{') then
        words[2] = words[2]+' ;'
      end
      # join back
      line = words.join(' = ');
      
      if    (line.index('@local@@')   ) then line = line.gsub('@local@@','');
      elsif (line.index('@sequence@@')) then line = line.gsub('@sequence@@','');
      elsif (line.index('@table@@')   ) then line = line.gsub('@table@@','');
      else
      end

      last = line.strip()[-1]
      if (@verbose)  then puts " >>> 6.90 last:\'#{last}\'" ; end
      if (@verbose) ; puts " >>> 6.91 line:#{line}" ; end
      if ( last != '{') then
        if ((last != ',') and (last != ';')) then line = line+' ;'; end
      end
      if (@verbose) ; puts " >>> 6.92 line:#{line}" ; end
      if (comment) ; line = line + ' -- # ' + comment; end
      line = line.gsub('{','new {')
      if (@verbose) ; puts " >>> 7 returning line:#{line}" ; end
      return line;
    else
#------------------------------------------------------------------------------
# words.length > 3: 
# at least three '=' signs don't know what to do
# correct FCL  manually , typically, need to split the line
#------------------------------------------------------------------------------
     
      return ">>> ERROR (4) -- text:#{text} comment:#{comment}";
    end
  end

#------------------------------------------------------------------------------
# process a single file
#------------------------------------------------------------------------------
  def convert_file(filename)
    if (@verbose) then ; puts "[convert_file] : @verbose = #{@verbose} START" ; end

    ifile = File.open(filename) ; 
#------------------------------------------------------------------------------
# scan lines
#------------------------------------------------------------------------------
    ifile.each_line { |line|
      line = line.delete("\a\n").rstrip;
      if (@verbose) ;  puts "[convert_file] -------------------- line=#{line}" ; end
      newline = '???' + line
      if (line.length() == 0) then puts line; next ; end
#------------------------------------------------------------------------------
# the line is not empty .
# Step 1: assume the #include statements start from the first position
#------------------------------------------------------------------------------
      if (line.index('#include') == 0) then 
        line    = line.gsub('#include','require')
        newline = line.gsub('"','\'').gsub('.fcl','')
        puts newline; next
      end
#------------------------------------------------------------------------------
# not an include
# step 2: perform per-line substitutions
#------------------------------------------------------------------------------
      if (@verbose) ;  puts "[convert_file] before substitution line=#{line}" ; end
      line = do_per_line_substitutions(line);
      if (@verbose) ;  puts "[convert_file] after substitution line=#{line}" ; end
#------------------------------------------------------------------------------
# step 3: handle lines which are nothing but comments
#------------------------------------------------------------------------------
      if (line.lstrip()[0] == '#') then puts line.gsub('#','-- #') ; next ; end

      
      words   = line.split('#');
      text    = words[0];
      comment = ''
      if (words.length > 1) then comment = words[1]; end
#------------------------------------------------------------------------------
# need to parse 'text', then, if comment != '',
# merge the result of parsing with ' # '+ comment'
# step 3.1 : exclude trivial case : a closing bracket followed by a comment
#------------------------------------------------------------------------------
      l2    = words[0].strip
      if ( l2 == '}' ) then
        # a closing bracket plus a comment : '} # .....'
        line = line.gsub('#','-- #').gsub('}','};')
        if (@verbose) ;  puts "[convert_file] 11 write out line=#{line}" ; end
        puts line ; next
      else
        # check for the presense of '='
        comment = nil;
        if (l2.index('=')) then
          words[0] = words[0].gsub('=',' = ').gsub('#',' # ');
          comment  = words[1];
          newline  = parse_assignment(words[0],comment) ;
          if (@verbose) ;  puts "[convert_file] 12 write out newline=#{newline}" ; end
          puts newline; next
        else
#------------------------------------------------------------------------------
# no assignments on the line
#------------------------------------------------------------------------------
          line = parse_simple(words[0])

          if (words.length > 1) then line = line + '-- #'+words[1]; end
          if (@verbose) ;  puts "[convert_file] 139 write out line=#{line}" ; end
          puts line; next
        end
      end
    }
#-----------------------------------------------------------------------
#  make sure output directory exists and write njobs
#-----------------------------------------------------------------------
#    @tmp_file   = File.open(@tmp_fn,"r");
#    output_file = File.open(@tmp_fn+".1","w");
#-----------------------------------------------------------------------
#  copy to a remote node
#-----------------------------------------------------------------------
  end
#------------------------------------------------------------------------------
#  end of class definition
#------------------------------------------------------------------------------
end

if __FILE__ == $PROGRAM_NAME

  x = FclToLua.new();

  # puts "emoe! #{$PROGRAM_NAME}"
  if (x.verbose) then puts(">>>>>>>>>>>>>> converting FCL to LUA ..."); end

  if ($input_file) then x.convert_file($input_file);
  else                  x.convert();
  end
  
  exit(0)
end

