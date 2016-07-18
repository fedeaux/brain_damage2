# -*- coding: utf-8 -*-
module BrainDamage
  module BrainDamageHelper
    def r(partial, locals = {})
      render :partial => partial, :locals => locals
    end

    def bd(partial, locals = {})
      r "brain_damage/#{partial}", :locals => locals
    end

    def bd_id(prefix = nil)
      prefix = "#{prefix}-" if prefix
      "#{prefix}brain-damage-#{(0...16).map { (65 + rand(26)).chr }.join.downcase}"
    end

    def bd_actions(locals = {}, &block)
      locals = {:show => false, :delete => true, :edit => true, :block => block}.merge(locals)
      render :partial => 'brain_damage/shared/actions', :locals => locals
    end

    def ajax_sensible_field_wrapper(object, method, show = true, html = {})
      html[:tag] ||= 'tr'
      html[:class] ||= ''
      html[:class] += ' sensible-to-ajax'

      content_tag(html[:tag], { :class => html[:class], :data => { :ajax_sensibility_field => method }}) do
        yield if block_given? and show
      end
    end

    def name_for_input_tag(attribute_name, prefix = nil)
      if prefix
        return "#{prefix}[#{attribute_name}]"
      end

      attribute_name
    end

    def t_or_c(string)
      return t string if I18n.exists? string

      common = "common.#{string.split('.').last}"
      return t common if I18n.exists? common

      entities = "entities.#{string.split('.').last}"
      return t entities if I18n.exists? entities

      t string
    end

    def ct(string)
      string = t_or_c(string)

      if string == string.upcase
        string
      else
        string.capitalize
      end
    end

    def cet(string)
      string = t_or_c(string)
      if string == string.upcase
        string
      else
        string.capitalize
      end
    end

    def T(string)
      t_or_c(string).upcase
    end
  end
end
