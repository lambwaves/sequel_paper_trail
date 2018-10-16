module Sequel
  module Plugins
    # Add Paper Trail versioning callbacks to model.
    #
    # Usage:
    #
    #   # Enable versioning for all models.
    #   Sequel::Model.plugin :has_paper_trail
    #
    #   # Make the Album class be able to versioning.
    #   Album.plugin :has_paper_trail, item_class_name: Album, class_name: 'Album::Version'
    #
    module HasPaperTrail
      # rubocop:disable Metrics/MethodLength
      def self.configure(model, opts = {})
        paper_trail_item_class_name = opts.fetch(:item_class_name) do
          model.name
        end
        paper_trail_version_class_name = opts.fetch(:class_name) do
          'SequelPaperTrail::Version'
        end
        paper_trail_ignore_attributes = opts.fetch(:ignore) { [] }

        model.plugin :dirty
        model.one_to_many :versions,
                          class: paper_trail_version_class_name,
                          key: :item_id,
                          conditions: { item_type: paper_trail_item_class_name }

        model.instance_eval do
          @paper_trail_item_class_name = paper_trail_item_class_name
          @paper_trail_version_class_name = paper_trail_version_class_name
          @paper_trail_ignore_attributes = paper_trail_ignore_attributes
        end
      end
      # rubocop:enable Metrics/MethodLength

      # rubocop:disable Style/Documentation
      module ClassMethods
        Sequel::Plugins.inherited_instance_variables(
          self,
          :@paper_trail_item_class_name => :dup,
          :@paper_trail_version_class_name => :dup,
          :@paper_trail_ignore_attributes => :dup
        )

        # The class name of item for versioning
        attr_reader :paper_trail_item_class_name

        # The version class name
        attr_reader :paper_trail_version_class_name

        # Attributes to ignore in version table
        attr_reader :paper_trail_ignore_attributes
      end
      # rubocop:enable Style/Documentation

      # rubocop:disable Style/Documentation
      module InstanceMethods
        def after_create
          super

          return unless SequelPaperTrail.enabled?

          attrs = {
            item_id: id,
            event: :create,
            object: nil
          }

          PaperTrailHelpers.create_version(model, attrs)
        end

        def after_update
          super

          return unless SequelPaperTrail.enabled?
          return if column_changes.empty?
          return if (column_changes.keys - model.paper_trail_ignore_attributes)
            .empty?

          attrs = {
            item_id: id,
            event: :update,
            object: PaperTrailHelpers.to_yaml(values.merge(initial_values))
          }

          PaperTrailHelpers.create_version(model, attrs)
        end

        def after_destroy
          super

          return unless SequelPaperTrail.enabled?

          attrs = {
            item_id: id,
            event: :destroy,
            object: PaperTrailHelpers.to_yaml(values)
          }

          PaperTrailHelpers.create_version(model, attrs)
        end

        def current_version_id
          versions.any? ? versions.first.id : nil
        end
      end
      # rubocop:enable Style/Documentation

      # rubocop:disable Style/Documentation
      module PaperTrailHelpers
        def self.create_version(model, attrs)
          default_attrs = {
            item_type: model.paper_trail_item_class_name.to_s,
            whodunnit: SequelPaperTrail.whodunnit,
            created_at: Time.now.utc.iso8601
          }

          create_attrs = default_attrs
                         .merge(SequelPaperTrail.info_for_paper_trail)
                         .merge(attrs)

          version_class(model.paper_trail_version_class_name).create(create_attrs)
        end

        private_class_method

        def self.version_class(class_name)
          if class_name.is_a?(String)
            Kernel.const_get(class_name)
          else
            class_name
          end
        end

        def self.to_yaml(hash)
          YAML.dump(hash).gsub("\n:", "\n")
        end
      end
      # rubocop:enable Style/Documentation
    end
  end
end
