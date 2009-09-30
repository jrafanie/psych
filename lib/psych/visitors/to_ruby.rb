module Psych
  module Visitors
    ###
    # This class walks a YAML AST, converting each node to ruby
    class ToRuby < Psych::Visitors::Visitor
      def initialize
        super
        @st = {}
      end

      def visit_Psych_Nodes_Scalar o
        @st[o.anchor] = o.value if o.anchor
        case o.tag
        when 'tag:yaml.org,2002:null'
          nil
        else
          o.value
        end
      end

      def visit_Psych_Nodes_Sequence o
        o.children.map { |c| c.accept self }
      end

      def visit_Psych_Nodes_Mapping o
        Hash[*o.children.map { |c| c.accept self }]
      end

      def visit_Psych_Nodes_Document o
        o.root.accept self
      end

      def visit_Psych_Nodes_Stream o
        o.children.map { |c| c.accept self }
      end

      def visit_Psych_Nodes_Alias o
        @st[o.anchor]
      end
    end
  end
end
