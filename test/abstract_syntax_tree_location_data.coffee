# Astract Syntax Tree location data
# ---------------------------------

testAstLocationData = (code, expected) ->
  testAstNodeLocationData getAstExpression(code), expected

testAstNodeLocationData = (node, expected, path = '') ->
  extendPath = (additionalPath) ->
    return additionalPath unless path
    "#{path}.#{additionalPath}"
  ok node?, "Missing expected node at '#{path}'"
  testSingleNodeLocationData node, expected, path if expected.range?
  for own key, expectedChild of expected when key not in ['start', 'end', 'range', 'loc']
    if Array.isArray expectedChild
      ok Array.isArray(node[key]), "Missing expected array at '#{extendPath key}'"
      for expectedItem, index in expectedChild
        testAstNodeLocationData node[key][index], expectedItem, extendPath "#{key}[#{index}]"
    else if typeof expectedChild is 'object'
      testAstNodeLocationData node[key], expectedChild, extendPath(key)

testSingleNodeLocationData = (node, expected, path = '') ->
  # Even though it’s not part of the location data, check the type to ensure
  # that we’re testing the node we think we are.
  if expected.type?
    eq node.type, expected.type, \
      "Expected AST node type #{reset}#{node.type}#{red} to equal #{reset}#{expected.type}#{red}"

  eq node.start, expected.start, \
    "Expected #{path}.start: #{reset}#{node.start}#{red} to equal #{reset}#{expected.start}#{red}"
  eq node.end, expected.end, \
    "Expected #{path}.end: #{reset}#{node.end}#{red} to equal #{reset}#{expected.end}#{red}"
  arrayEq node.range, expected.range, \
    "Expected #{path}.range: #{reset}#{JSON.stringify node.range}#{red} to equal #{reset}#{JSON.stringify expected.range}#{red}"
  eq node.loc.start.line, expected.loc.start.line, \
    "Expected #{path}.loc.start.line: #{reset}#{node.loc.start.line}#{red} to equal #{reset}#{expected.loc.start.line}#{red}"
  eq node.loc.start.column, expected.loc.start.column, \
    "Expected #{path}.loc.start.column: #{reset}#{node.loc.start.column}#{red} to equal #{reset}#{expected.loc.start.column}#{red}"
  eq node.loc.end.line, expected.loc.end.line, \
    "Expected #{path}.loc.end.line: #{reset}#{node.loc.end.line}#{red} to equal #{reset}#{expected.loc.end.line}#{red}"
  eq node.loc.end.column, expected.loc.end.column, \
    "Expected #{path}.loc.end.column: #{reset}#{node.loc.end.column}#{red} to equal #{reset}#{expected.loc.end.column}#{red}"


test "AST location data as expected for NumberLiteral node", ->
  testAstLocationData '42',
    type: 'NumericLiteral'
    start: 0
    end: 2
    range: [0, 2]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 2

test "AST location data as expected for InfinityLiteral node", ->
  testAstLocationData 'Infinity',
    type: 'Identifier'
    start: 0
    end: 8
    range: [0, 8]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 8

test "AST location data as expected for NaNLiteral node", ->
  testAstLocationData 'NaN',
    type: 'Identifier'
    start: 0
    end: 3
    range: [0, 3]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 3

test "AST location data as expected for IdentifierLiteral node", ->
  testAstLocationData 'id',
    type: 'Identifier'
    start: 0
    end: 2
    range: [0, 2]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 2

test "AST location data as expected for StatementLiteral node", ->
  testAstLocationData 'break',
    type: 'BreakStatement'
    start: 0
    end: 5
    range: [0, 5]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 5

  testAstLocationData 'continue',
    type: 'ContinueStatement'
    start: 0
    end: 8
    range: [0, 8]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 8

  testAstLocationData 'debugger',
    type: 'DebuggerStatement'
    start: 0
    end: 8
    range: [0, 8]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 8

test "AST location data as expected for ThisLiteral node", ->
  testAstLocationData 'this',
    type: 'ThisExpression'
    start: 0
    end: 4
    range: [0, 4]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 4

test "AST location data as expected for UndefinedLiteral node", ->
  testAstLocationData 'undefined',
    type: 'Identifier'
    start: 0
    end: 9
    range: [0, 9]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 9

test "AST location data as expected for NullLiteral node", ->
  testAstLocationData 'null',
    type: 'NullLiteral'
    start: 0
    end: 4
    range: [0, 4]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 4

test "AST location data as expected for BooleanLiteral node", ->
  testAstLocationData 'true',
    type: 'BooleanLiteral'
    start: 0
    end: 4
    range: [0, 4]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 4

test "AST location data as expected for Access node", ->
  testAstLocationData 'obj.prop',
    type: 'MemberExpression'
    object:
      start: 0
      end: 3
      range: [0, 3]
      loc:
        start:
          line: 1
          column: 0
        end:
          line: 1
          column: 3
    property:
      start: 4
      end: 8
      range: [4, 8]
      loc:
        start:
          line: 1
          column: 4
        end:
          line: 1
          column: 8
    start: 0
    end: 8
    range: [0, 8]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 8

  testAstLocationData 'a::b',
    type: 'MemberExpression'
    object:
      object:
        start: 0
        end: 1
        range: [0, 1]
        loc:
          start:
            line: 1
            column: 0
          end:
            line: 1
            column: 1
      property:
        start: 1
        end: 3
        range: [1, 3]
        loc:
          start:
            line: 1
            column: 1
          end:
            line: 1
            column: 3
    property:
      start: 3
      end: 4
      range: [3, 4]
      loc:
        start:
          line: 1
          column: 3
        end:
          line: 1
          column: 4
    start: 0
    end: 4
    range: [0, 4]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 4

  testAstLocationData '''
    (
      obj
    ).prop
  ''',
    type: 'MemberExpression'
    object:
      start: 4
      end: 7
      range: [4, 7]
      loc:
        start:
          line: 2
          column: 2
        end:
          line: 2
          column: 5
    property:
      start: 10
      end: 14
      range: [10, 14]
      loc:
        start:
          line: 3
          column: 2
        end:
          line: 3
          column: 6
    start: 0
    end: 14
    range: [0, 14]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 3
        column: 6

test "AST location data as expected for Index node", ->
  testAstLocationData 'a[b]',
    type: 'MemberExpression'
    object:
      start: 0
      end: 1
      range: [0, 1]
      loc:
        start:
          line: 1
          column: 0
        end:
          line: 1
          column: 1
    property:
      start: 2
      end: 3
      range: [2, 3]
      loc:
        start:
          line: 1
          column: 2
        end:
          line: 1
          column: 3
    start: 0
    end: 4
    range: [0, 4]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 4

  testAstLocationData 'a?[b][3]',
    type: 'MemberExpression'
    object:
      object:
        start: 0
        end: 1
        range: [0, 1]
        loc:
          start:
            line: 1
            column: 0
          end:
            line: 1
            column: 1
      property:
        start: 3
        end: 4
        range: [3, 4]
        loc:
          start:
            line: 1
            column: 3
          end:
            line: 1
            column: 4
      start: 0
      end: 5
      range: [0, 5]
      loc:
        start:
          line: 1
          column: 0
        end:
          line: 1
          column: 5
    property:
      start: 6
      end: 7
      range: [6, 7]
      loc:
        start:
          line: 1
          column: 6
        end:
          line: 1
          column: 7
    start: 0
    end: 8
    range: [0, 8]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 8

test "AST location data as expected for Parens node", ->
  testAstLocationData '(hmmmmm)',
    type: 'Identifier'
    start: 1
    end: 7
    range: [1, 7]
    loc:
      start:
        line: 1
        column: 1
      end:
        line: 1
        column: 7

  testAstLocationData '(((1)))',
    type: 'NumericLiteral'
    start: 3
    end: 4
    range: [3, 4]
    loc:
      start:
        line: 1
        column: 3
      end:
        line: 1
        column: 4

test "AST location data as expected for Op node", ->
  testAstLocationData '1 <= 2',
    type: 'BinaryExpression'
    left:
      start: 0
      end: 1
      range: [0, 1]
      loc:
        start:
          line: 1
          column: 0
        end:
          line: 1
          column: 1
    right:
      start: 5
      end: 6
      range: [5, 6]
      loc:
        start:
          line: 1
          column: 5
        end:
          line: 1
          column: 6
    start: 0
    end: 6
    range: [0, 6]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 6

  testAstLocationData '!x',
    type: 'UnaryExpression'
    argument:
      start: 1
      end: 2
      range: [1, 2]
      loc:
        start:
          line: 1
          column: 1
        end:
          line: 1
          column: 2
    start: 0
    end: 2
    range: [0, 2]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 2

  testAstLocationData 'not x',
    type: 'UnaryExpression'
    argument:
      start: 4
      end: 5
      range: [4, 5]
      loc:
        start:
          line: 1
          column: 4
        end:
          line: 1
          column: 5
    start: 0
    end: 5
    range: [0, 5]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 5

  testAstLocationData 'x++',
    type: 'UpdateExpression'
    argument:
      start: 0
      end: 1
      range: [0, 1]
      loc:
        start:
          line: 1
          column: 0
        end:
          line: 1
          column: 1
    start: 0
    end: 3
    range: [0, 3]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 3

  testAstLocationData '(x + y) * z',
    type: 'BinaryExpression'
    left:
      left:
        start: 1
        end: 2
        range: [1, 2]
        loc:
          start:
            line: 1
            column: 1
          end:
            line: 1
            column: 2
      right:
        start: 5
        end: 6
        range: [5, 6]
        loc:
          start:
            line: 1
            column: 5
          end:
            line: 1
            column: 6
      start: 1
      end: 6
      range: [1, 6]
      loc:
        start:
          line: 1
          column: 1
        end:
          line: 1
          column: 6
    right:
      start: 10
      end: 11
      range: [10, 11]
      loc:
        start:
          line: 1
          column: 10
        end:
          line: 1
          column: 11
    start: 0
    end: 11
    range: [0, 11]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 11

test "AST location data as expected for Call node", ->
  testAstLocationData 'fn()',
    type: 'CallExpression'
    start: 0
    end: 4
    range: [0, 4]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 4
    callee:
      start: 0
      end: 2
      range: [0, 2]
      loc:
        start:
          line: 1
          column: 0
        end:
          line: 1
          column: 2

  testAstLocationData 'new Date()',
    type: 'NewExpression'
    start: 0
    end: 10
    range: [0, 10]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 10
    callee:
      start: 4
      end: 8
      range: [4, 8]
      loc:
        start:
          line: 1
          column: 4
        end:
          line: 1
          column: 8

  testAstLocationData '''
    new Old(
      1
    )
  ''',
    start: 0
    end: 14
    range: [0, 14]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 3
        column: 1
    type: 'NewExpression'
    arguments: [
      start: 11
      end: 12
      range: [11, 12]
      loc:
        start:
          line: 2
          column: 2
        end:
          line: 2
          column: 3
    ]

  testAstLocationData 'maybe? 1 + 1',
    type: 'CallExpression'
    start: 0
    end: 12
    range: [0, 12]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 12
    arguments: [
      start: 7
      end: 12
      range: [7, 12]
      loc:
        start:
          line: 1
          column: 7
        end:
          line: 1
          column: 12
    ]

  testAstLocationData '''
    goDo(this,
      that)
  ''',
    type: 'CallExpression'
    start: 0
    end: 18
    range: [0, 18]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 2
        column: 7
    arguments: [
      start: 5
      end: 9
      range: [5, 9]
      loc:
        start:
          line: 1
          column: 5
        end:
          line: 1
          column: 9
    ,
      start: 13
      end: 17
      range: [13, 17]
      loc:
        start:
          line: 2
          column: 2
        end:
          line: 2
          column: 6
    ]

  testAstLocationData 'new Old',
    type: 'NewExpression'
    callee:
      start: 4
      end: 7
      range: [4, 7]
      loc:
        start:
          line: 1
          column: 4
        end:
          line: 1
          column: 7
    start: 0
    end: 7
    range: [0, 7]
    loc:
      start:
        line: 1
        column: 0
      end:
        line: 1
        column: 7
