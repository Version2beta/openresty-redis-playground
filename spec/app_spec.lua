describe('Basic functionality', function()
  it('loads the app', function()
    local app = require "app"
    assert.truthy(app)
  end)
end)
describe('redis functionality', function()
  it('can set a key', function()
    local app = require "app"
    assert.is.equal(app.set('test:0', 0), 'OK')
    assert.is.equal(app.set('test:1', 1), 'OK')
  end)
  it('can get a key', function()
    local app = require "app"
    assert.is.equal(app.get('test:0'), '0')
    assert.is.equal(app.get('test:1'), '1')
  end)
end)
