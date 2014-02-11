module Jekylll
  class Collection
    attr_accessor :name

    def initialize(site, collection_name)
      @name = collection_name
    end

    def documents
      @documents ||= read_documents
    end

    def directory
      "_#{name}"
    end

    def read_documents
      entries = []
      within(directory) do
        Dir['**/*.*'].each do |filename|
          if klass_for_collection.valid_filename?(filename)
            entries << klass_for_collection.new(site, directory, filename)
          else
            Jekyll.logger.debug("#{directory}:", "'#{filename}' is an invalid filename. Skipping.")
          end
        end
      end
      entries
    end

    def within(dir)
      return unless File.exists?(dir)
      Dir.chdir(dir) { yield }
    end

    def klass_for_collection
      raise NotImplementedError
    end

  end
end
