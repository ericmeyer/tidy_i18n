require "i18n"

module TidyI18n
  class ProjectRootNotConfigured < StandardError; end
  class RaiseAllErrors

    def call(exception, locale, key, options)
      raise exception.to_exception
    end

  end

  def self.project_root=(path)
    @project_root = path
  end

  def self.project_root
    @project_root
  end

  def self.raise_error_on_missing_translation=(raise_error)
    if raise_error
      I18n.exception_handler = RaiseAllErrors.new
    else
      I18n.exception_handler = I18n::ExceptionHandler.new
    end
  end

  def self.translate(key, options={})
    raise ProjectRootNotConfigured if project_root.nil?
    if key[0] == "."
      key_prefix = caller[0].
        gsub("#{project_root}/", "").
        split(".").
        first.
        gsub("/", ".")
      I18n.translate("#{key_prefix}.#{key}", **options)
    else
      I18n.translate(key, **options)
    end
  end

  class << self
    alias :t :translate
  end

end
