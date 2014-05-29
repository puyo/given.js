
LazyLet = require '../build/lazylet'

describe "lazylet usage", ->

  Let = env = undefined

  beforeEach ->
    env = LazyLet.Env()
    Let = env.Let

  it "can define a variable", ->
    Let 'name', 'James Sadler'
    expect(env.name).toEqual "James Sadler"

  it "can define a variable that is depends on another and is computed on demand", ->
    Let 'name', 'James Sadler'
    Let 'message', -> "Hello, #{@name}!"
    expect(env.message).toEqual 'Hello, James Sadler!'

  it 'can define variables in bulk', ->
    Let
      name: 'James Sadler'
      age: 36
    expect(env.name).toEqual 'James Sadler'
    expect(env.age).toEqual 36

  it "does not clear the environment when declaring variables individually", ->
    Let 'name', 'James Sadler'
    Let 'age', 36
    expect(env.name).toEqual "James Sadler"
    expect(env.age).toEqual 36

  it 'provides a way to explicitly clear the environment', ->
    Let 'name', 'James Sadler'
    Let.clear()
    expect(typeof env.name).toBe 'undefined'

  it 'can define variable in terms of the existing value', ->
    Let 'array', [1, 2, 3]
    Let 'array', -> @array.concat 4
    expect(env.array).toEqual [1, 2, 3, 4]

  it 'memoizes variables when they are evaluated', ->
    count = 0
    Let name: ->
      count += 1
      'James'
    env.name
    expect(count).toEqual 1
    env.name
    expect(count).toEqual 1

  it 'forgets the memoization for all variables when any variable is redefined', ->
    count = 0
    Let name: ->
      count += 1
      'James'
    expect(env.name).toEqual 'James'
    expect(count).toEqual 1
    Let age: -> 36
    expect(env.name).toEqual 'James'
    expect(count).toEqual 2

  describe 'behaving in sane manner', ->

    it 'does not allow redefinition of "Let"', ->
      expect(-> Let 'Let', 'anything').toThrow 'cannot redefine Let'

