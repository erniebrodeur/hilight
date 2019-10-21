module Hilight
  # simple manager for the collection of loaded quilts.
  module Quilts
    module_function

    def collection
      @collection ||= []
    end

    def load_quilts_from_gem
      files = Dir.glob(Hilight.gem_dir + '/data/quilts/*')
      files.each do |filename|
        collection.push Hilight::Quilt.load_from_ruby_file filename
      end
    end

    def match_quilt(pattern)
      collection.each { |quilt| return quilt if quilt.match? pattern }
      nil
    end
  end
end
