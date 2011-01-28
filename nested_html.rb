module Differ
  module Format
    module NestedHTMLClassMethods
      def format(change)
        (change.change? && as_change(change)) ||
        (change.delete? && as_delete(change)) ||
        (change.insert? && as_insert(change)) ||
        ''
      end

    private
      def as_insert(change)
        %Q{<ins class="#{class_attrib}">#{inner_insert(change)}</ins>}
      end

      def as_delete(change)
        %Q{<del class="#{class_attrib}">#{inner_delete(change)}</del>}
      end

      def as_change(change)
        as_delete(change) << as_insert(change)
      end
    end

    module NestedHTML
      extend Differ::Format::NestedHTMLClassMethods

      class << self
        def class_attrib
          'differ'
        end

        def inner_diff(change)
          Differ.diff_by_word(change.insert, change.delete)
        end

        def inner_insert(change)
          return change.insert unless change.change?
          inner_diff(change).format_as(Differ::Format::NestedHTMLInnerInsert)
        end

        def inner_delete(change)
          return change.delete unless change.change?
          inner_diff(change).format_as(Differ::Format::NestedHTMLInnerDelete)
        end
      end
    end

    module NestedHTMLInnerInsert
      extend Differ::Format::NestedHTMLClassMethods

      class << self
        def class_attrib
          'differ_inner'
        end

        def inner_insert(change)
          change.insert
        end

        def as_delete(change)
          ''
        end
      end
    end

    module NestedHTMLInnerDelete
      extend Differ::Format::NestedHTMLClassMethods

      class << self
        def class_attrib
          'differ_inner'
        end

        def inner_delete(change)
          change.delete
        end

        def as_insert(change)
          ''
        end
      end
    end
  end
end
