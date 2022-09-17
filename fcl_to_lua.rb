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
    newline = newline.gsub('//' ,'#' );

    newline = newline.gsub('^^^',':');
    return newline
  end
  
#------------------------------------------------------------------------------
# process many files
#------------------------------------------------------------------------------
  def convert()
  end

#------------------------------------------------------------------------------
  def parse_assignment(text,comment)
    if (@verbose) ; puts ">>>> parse_assignment: text:\'#{text}\' comment:\'#{comment}\'" ; end

    words = text.split('=')
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
          if (comment) then line = line + ' # '+comment; end
          return line;
        else
#------------------------------------------------------------------------------
# the line does have a '{' but doesn't end with it - check for the rest 
#------------------------------------------------------------------------------
          ww2 = words[1].gsub('{',' { ').gsub('}',' } ');
          if (@verbose) ; puts ">>> 0:ww2:#{ww2}" ; end
          # make sure commas are space-separated from the rest
          q = /".* .*"/.match(ww2)
          if (q) then
            if (@verbose) ; puts "q:\'#{q.string}\'" ; end
            # replace ' ' with '^^^' within the string
            q1 = q.to_s
            q2 = q1.gsub(' ','^^^')
            if (@verbose) ; puts "q1:#{q1} q2:#{q2}"; end
            
            ww2 = ww2.gsub(q1,q2)
          end
                              
          ww2 = ww2.gsub(',',' , ');
          # ww2 = ww2.gsub(' ,',' , ');
          if (@verbose) ;  puts ">>> 1: ww2:\'#{ww2}\'" ; end
          w3  = ww2.split
          if (@verbose) ;  puts ">>> 1: w3:\'#{w3}\'" ; end
          outp = ''
          for w in w3
            if (w == '{') then
              outp = outp+w
            elsif (w == '}') then
              outp = outp+w
            elsif (w == ',') then
              outp = outp+w
            else 
              if (@verbose) ;  puts ">>> 1: w:\'#{w}\'" ; end
              # w could be a comma-separated list
              if (w.index(',') == nil) then
                if (is_number? w) then
                else
                  w = '"'+w.delete('"')+'"' ;
                end
                if (@verbose) ;  puts ">>> 2: w: "+w ; end
                outp = outp+' '+w
              else
                wa = w.split(',')
                for i in 0..wa.length-1 do
                  wb = wa[i]
                  if (is_number? wa[i]) then
                  else
                    wb = '"'+wa[i].delete('"')+'"' ;
                  end
                  if (i < wa.length-1) then wb = wb+','; end
                  outp = outp+' '+wb
                end
              end
            end
          end
          if (@verbose) ; puts "outp:",outp ; end
          line = words[0] + ' = '+outp ;
          line = line.gsub('{','new {');
          line = line.gsub('^^^',' ');
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
      # 2 '=' signs, first go the 'easy' way
      if (@verbose) ; puts " >>> 3 line:#{line}" ; end
      # if the last character is not '{', append ';'

      # split into words
      ww = text.split();
      nw = ww.length
      ww1 = []

      i = 0;
      while (i < nw) do
        ww1.append(ww[i])
        i = i+1
        if (ww[i-1] == '=') then
          if (i < nw) then 
            ww1.append(ww[i])
            i=i+1
            # chunk of an assignment, make sure word[i+2]
            if (i < nw) then
              if ((ww[i] != ',') and (ww[i] != ';')) then
                ww1.append(';')
              else
                ww1.append(ww[i])
                i = i+1
              end
            end
          end
        end
      end
      # join back
      line = ww1.join(' ');
      
      if    (line.index('@local@@')   ) then line = line.gsub('@local@@','');
      elsif (line.index('@sequence@@')) then line = line.gsub('@sequence@@','');
      elsif (line.index('@table@@')   ) then line = line.gsub('@table@@','');
      else
      end

      last = line.strip[-1]
      if ( last != '{') then
        if ((last != ',') and (last != ';')) ; line = line+' ;'; end
      end
      if (comment) ; line = line + ' -- # ' + comment; end
      line = text.gsub('{','new {')
      return line;
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
# step 2: perform per-line substitutions
#------------------------------------------------------------------------------
      if (@verbose) ;  puts "before substitution line=#{line}" ; end
      line = do_per_line_substitutions(line);
      if (@verbose) ;  puts "after substitution line=#{line}" ; end
#------------------------------------------------------------------------------
# step 3: handle lines which are nothing but comments
#------------------------------------------------------------------------------
      if (line.lstrip()[0] == '#') then puts line.gsub('#','-- #') ; next ; end

      if (line.index('#')) then
#------------------------------------------------------------------------------
# comment sign on the line, but after smth else
# step 3.1 : exclude trivial case : a closing bracket followed by a comment
#------------------------------------------------------------------------------
        words = line.split('#');
        l2    = words[0].strip
        if ( l2 == '}' ) then
          # a '}' plus a comment
          puts line.gsub('#','-- #').gsub('}','};') ; next
        end

        # check for the presense of '='
        comment = nil;
        if (l2.index('=')) then
          words[0] = words[0].gsub('=',' = ').gsub('#',' # ');
          comment  = words[1];
          newline  = parse_assignment(words[0],comment) ;
          puts newline; next
        else
          puts '(1)---'+line; next
        end
      end
#------------------------------------------------------------------------------
# line w/o a comment
# 1. check for just a closing bracket on the line
#------------------------------------------------------------------------------
      if (line.strip == '}') then puts line+';' ; next ; end
      if (line.strip == '{') then puts line.gsub('{',' new {') ; next ; end
#------------------------------------------------------------------------------
# test for 'a = b' pattern
#------------------------------------------------------------------------------
      ww = line.split('=')
      nw = ww.length
      if    (nw == 1) then
#------------------------------------------------------------------------------
# no comment signs, no '=' signs, test teh rest
#------------------------------------------------------------------------------
        if    (line.strip == 'BEGIN_PROLOG') then puts '-- '+line; next
        elsif (line.strip == 'END_PROLOG'  ) then puts '-- '+line; next
        else
          line = line.gsub('{','new {');
          line = line.gsub('}','};');
          
          line = line.gsub('@table@@','');
          #         line = line.delete('@local@@');
          #         line = line.delete('@sequence@@');
          x = line.rstrip
          if ((x[x.length-1] != ';') and (x[x.length-1] != ',')) then
            line = line+' ;'
          end
          puts line; next
        end
      elsif (nw == 2) then
        newline = parse_assignment(line,nil);
        puts newline; next
      elsif (nw == 3) then
        newline = parse_assignment(line,nil);
        puts newline; next
        
        # puts line.gsub('{','new {').gsub('}','};') ; next
      else
#------------------------------------------------------------------------------
# more than one '=' sign on the line, investigate        
#------------------------------------------------------------------------------
        puts "ERROR (4) nw=#{nw} --"+line;
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

