#!/usr/bin/env ruby
#------------------------------------------------------------------------------
#  2022-09-12 P.Murat : convert .fcl files into .lua format
#  example: 
#  --------
#           fcl_to_lua.rb  --input=
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
$verbose    = nil
#------------------------------------------------------------------------------
class FclToLua
#------------------------------------------------------------------------------
# constructor
#------------------------------------------------------------------------------
  def initialize()
    if ($verbose) then ; puts "format : #{format} max_size=#{max_size}" ; end
    parse_command_line();
  end

  def is_number?(obj)
    
    obj = obj.to_s unless obj.is_a? String
    if (obj[obj.length-1] == '.') then obj = obj+'0'; end
    return /\A[+-]?\d+(\.[\d]+)?\z/.match(obj)
  end 

#------------------------------------------------------------------------------
  def parse_command_line()
    
    opts = GetoptLong.new(
      [ "--input-file"    , "-f",        GetoptLong::REQUIRED_ARGUMENT ],
      [ "--input-dir"     , "-i",        GetoptLong::REQUIRED_ARGUMENT ],
      [ "--output_dir"    , "-o",        GetoptLong::REQUIRED_ARGUMENT ],
      [ "--verbose"       , "-v",        GetoptLong::NO_ARGUMENT       ]
    )

    opts.each do |opt, arg|
    if    (opt == "--verbose"       ) then $verbose        = 1
    elsif (opt == "--input-file"    ) then $input_file     = arg
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

    if ($verbose) ; puts "Option: #{opt}, arg #{arg.inspect}" ; end

    usage if ($list_of_files == nil) && ($pattern == "")
    end
  end

#------------------------------------------------------------------------------
# process many files
#------------------------------------------------------------------------------
  def convert()
  end

#------------------------------------------------------------------------------
  def parse_assignment(text,comment)
    # puts ">>>> parse_assignment: text:\'#{text}\' comment:\'#{comment}\'"
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
# the line doesn't end with '{' - check for the rest 
#------------------------------------------------------------------------------
          ww2 = words[1].gsub('{',' { ').gsub('}',' } ');
          ww2 = ww2.gsub(', ',' , ');
          ww2 = ww2.gsub(' ,',' , ');
          # puts ">>> 1: ww2:\'#{ww2}\'"
          w3  = ww2.split
          # puts ">>> 1: w3:\'#{w3}\'"
          outp = ''
          for w in w3
            if (w == '{') then
              outp = outp+w
            elsif (w == '}') then
              outp = outp+w
            elsif (w == ',') then
              outp = outp+w
            else 
              # puts ">>> 1: w:\'#{w}\'"
              # w could be a comma-separated list
              if (w.index(',') == nil) then
                if (is_number? w) then
                else
                  w = '"'+w.delete('"')+'"' ;
                end
                # puts ">>> 2: w: "+w
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
          # puts "outp:",outp
          line = words[0] + ' = '+outp ;
          return line.gsub('{','new {').gsub('}','};') 
        end
      else
#------------------------------------------------------------------------------
# text after '=' doesn't have a '{', suspect a simple number or a string 
#------------------------------------------------------------------------------
        w1 = words[1].strip
        # puts "--- w1:#{w1} is_number:#{is_number?w1}"
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
      line = text.gsub('{','new {').gsub('}','};') ;
      if (line.index('@local@@')) then
        line = line.gsub('@local@@','');
        if (comment) ; line = line + ' -- # ' + comment; end
        return line;
      elsif (line.index('@sequence@@')) then
        line = line.gsub('@sequence@@','');
        if (comment) ; line = line + ' -- # ' + comment; end
        return line;
      elsif (line.index('@table@@')) then
        line = line.gsub('@table@@','');
        if (comment) ; line = line + ' -- # ' + comment; end
        return line;
      else
        return line;
      end
    end
  end

  
#------------------------------------------------------------------------------
# process a single file
#------------------------------------------------------------------------------
  def convert_file(filename)
    if ($verbose) then ; puts "[convert_file] : $verbose = #{$verbose} START" ; end

    ifile = File.open(filename) ; 

    ifile.each_line { |line|
      line = line.delete("\a\n").rstrip;
      newline = '???' + line
      if (line.length() == 0) then puts line; next ; end
#------------------------------------------------------------------------------
# the line is not empty 
#------------------------------------------------------------------------------
      if (line.index('#include') == 0) then 
#------------------------------------------------------------------------------
# an #include statement
#------------------------------------------------------------------------------
        line    = line.gsub('#include','require')
        newline = line.gsub('"','\'').gsub('.fcl','')
        puts newline; next
      end
      
      line = line.gsub(' : ' ,' = ');
      line = line.gsub(': '  ,' = ');
      line = line.gsub(' :'  ,' = ');
      line = line.gsub('::','@@' );
      line = line.sub(':' ,' = ');
      line = line.gsub('[' ,'{'  );
      line = line.gsub(']' ,'}'  );
      line = line.gsub('//' ,'#' );

      if (line.index('#')) then
#------------------------------------------------------------------------------
# comment sign on the line, it could be in the beginning , or not
#------------------------------------------------------------------------------
        if (line.lstrip()[0] == '#') then
          # nothing except the comment
          puts line.gsub('#','-- #') ; next
        end
        #------------------------------------------------------------------------------
        # check for closing bracket and a comment
        #------------------------------------------------------------------------------
        loc = line.index('#');
        # l1 is the part before the comment
        l1 = line[0,loc]
# 
        l2 = l1.strip
        if ( l2 == '}' ) then
          # '}' plus a comment
          puts line.gsub('#','-- #').gsub('}','};') ; next
        end

        # check for the presense of '='
        comment = nil;
        if (line.index('=')) then
          line    = line.gsub('=',' = ').gsub('#',' # ');
          ww      = line.split('#');
          comment = ww[1];
        # ww[0] : expect assignment 'a = b'
          newline = parse_assignment(ww[0],comment) ;
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
        if    (ww[0] == 'BEGIN_PROLOG') then puts '-- '+line; next
        elsif (ww[0] == 'END_PROLOG'  ) then puts '-- '+line; next
        else
          # unknown structure 
          puts "(ERROR 1.1) --"+line; next
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
  # puts "emoe! #{$PROGRAM_NAME}"
  if ($verbose) then puts(">>>>>>>>>>>>>> converting ..."); end

  x = FclToLua.new();

  if ($input_file) then x.convert_file($input_file);
  else                  x.convert();
  end
  
  exit(0)
end

