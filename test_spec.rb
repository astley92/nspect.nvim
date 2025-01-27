require("rspec")

RSpec.describe "testing" do
  it "works" do
    expect(1).to eq(1)
  end

  it "fails" do
    expect(1).to eq(2)
  end
end
