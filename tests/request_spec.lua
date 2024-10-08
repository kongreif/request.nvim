describe("request", function()
  it("can be required", function()
    require("request")
  end)

  it("can make a get request", function()
    local expected_response = [[{
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
}]]
    local response = require("request").get('https://jsonplaceholder.typicode.com/posts/1')
    assert.equals(expected_response, response)
  end)

  it("can make a post request", function()
    local expected_response = [[{
  "userId": "1",
  "title": "foo",
  "body": "bar",
  "id": 101
}]]
    local params = {
      title = 'foo',
      body = 'bar',
      userId = 1
    }
    local response = require("request").post('https://jsonplaceholder.typicode.com/posts', params)
    assert.equals(expected_response, response)
  end)
end)
