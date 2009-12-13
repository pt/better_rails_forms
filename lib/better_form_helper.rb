module BetterFormHelper

  def better_form_for(obj, opts={}, &block)
    opts[:html] ||= {}
    opts[:html].merge!({:class => 'better'})

    concat("<div class='form-top'></div>")
    form_for(obj, opts, &block)
    concat("<div class='form-bottom'></div>")
  end

  def better_select(form, obj, field, options, label, required=true)
    standard_form_field(form, obj, field, label, colonize(label), required) do
      form.select(field, options)
    end
  end

  def better_text_field(form, obj, field, label, required=false, help_text='')
    better_form_field(form, obj, field, :text_field, colonize(label), required, help_text)
  end

  def better_text_area(form, obj, field, label, required=false)
    better_form_field(form, obj, field, :text_area, colonize(label), required)
  end

  def better_password_field(form, obj, field, label, required=true, options = {})
    better_form_field(form, obj, field, :password_field, colonize(label), required, '', options)
  end

  def better_form_field(form, obj, field, field_type, label, required=false, help_text='', options = {})
    content_tag('fieldset', :class => field_type) do
      content_tag('span', help_text, :class => 'help-text') +
        form.label(field, label + required(required)) +
        form.send(field_type, field, options) +
        better_error_message_for(obj, field)
    end
  end

  def cancel_and_submit(form, cancel_path, submit_text="Save")
    link_to('Cancel', cancel_path, :class => 'cancel') +
      form.submit(submit_text, :id => 'commit')
  end

  def colonize(label)
    label =~ /[:\?]$/ ? label : "#{label}:"
  end

  def required(required=true)
    required ? content_tag('span', '*', :class => 'required-field') : ''
  end

  def better_error_message_for(object, method, *args)
    options = args.extract_options!
    options.reverse_merge!(:prepend_text => '', :append_text => '', :css_class => 'formError')

    if (obj = (object.respond_to?(:errors) ? object : instance_variable_get("@#{object}"))) &&
      (errors = obj.errors.on(method))
      error_to_display = errors.is_a?(Array) ? errors.first : errors
      error_to_display.gsub!(/^\^/, '')
      content_tag("span",
                  "#{options[:prepend_text]}#{ERB::Util.html_escape(error_to_display)}#{options[:append_text]}",
                  :class => options[:css_class]
      )
    else
      ''
    end
  end
end
