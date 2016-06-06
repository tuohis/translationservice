class FileParser
  def parse_each(data)
    text_type = ""
    text_id = ""
    translation_language_matcher = "(#{Translation.languages.collect{|l| "(#{l.upcase})"}.join('|')})"
    translations = []
    data.force_encoding('UTF-8').lines.each do |line|
      if line =~ /__TEXT_([A-Z0-9_]+)/
        text_type = $1
      elsif line =~ /__TAG__\(([A-Za-z0-9_-]+)\)/
        text_id = $1
        p text_id
      elsif line =~ /(.*), +\/\* #{translation_language_matcher} \*\//
        t = {}
        t[:text_id] = text_id
        t[:text] = format_translation_from_res($1)
        t[:language] = $2.downcase
        yield t
      end
    end
  end
  
  private
  def format_translation_from_res(text, is_inside_quotes=false)
    return "" if text.empty?
    pieces = text.partition('"')
    if is_inside_quotes
      forepart = pieces[0]
    else
      forepart = pieces[0].strip.split(' ').collect{|p| "{#{p}}"}.join('')
    end
    forepart + format_translation_from_res(pieces[2], !is_inside_quotes)
  end
end
