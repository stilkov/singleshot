# Singleshot  Copyright (C) 2008-2009  Intalio, Inc
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


class BasePresenter < Presenter::Base # Shared by Task and Template.
  # Returns authenticated user. Use this to determine which attributes to update/show.
  def authenticated
    controller && controller.send(:authenticated)
  end

  def update!(attrs)
    object.modified_by = authenticated
    object.singular_roles.each do |role|
      attrs[role] = Person.identify(attrs[role]) if attrs[role]
    end
    if webhooks = attrs.delete('webhooks')
      webhooks = [webhooks.first] unless Array === webhooks
      attrs['webhooks'] = webhooks.map { |attr| Webhook.new attr }
    end
    if form = attrs.delete('form')
      attrs['form'] = Form.new(form)
    end
    object.update_attributes! attrs
  end

  module StringArrayToXML
    def to_xml(options)
      xml = options[:builder]
      xml.tag! options[:root] do
        singular = options[:root].singularize
        each do |item|
          xml.tag! singular, item.to_s
        end
      end
    end
  end

  def to_hash
    super do |hash|
      object.singular_roles.each do |role|
        if person = object.send(role)
          hash[role] = person.to_param
        end
      end
      object.plural_roles.each do |role|
        role = role.pluralize
        if people = object.send(role)
          hash[role] = people.map(&:to_param).extend(StringArrayToXML)
        end
      end
      hash['links'] = [ link_to('self', href) ]
      hash['actions'] = []
      yield hash if block_given?
    end
  end

end
