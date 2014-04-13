#!/usr/bin/env ruby

require "spec_helper"
require "alfred"

describe String do

  describe "#to_argv" do
    context "when there are white spaces among args" do
      it "will ommit the redudant white spaces" do
        s = "-e   mp3 -d    x   "
        expect(s.to_argv).to eql(['-e', 'mp3', '-d', 'x'])
      end
    end

    context "when passed Unicode characters" do
      it "is ok" do
        s = "-f 中文.txt"
        expect(s.to_argv).to eql(['-f', '中文.txt'])
      end
    end

    context "when there are white spaces in quotes" do
        it "will recognize these white spaces as contents of the arg" do
          s = %{-e 'hello world' -f "alfred ruby"}
          expect(s.to_argv).to eql(['-e', 'hello world', '-f', 'alfred ruby'])
        end
    end

    context "when there single quotes nested in double quotes" do
        it "will recognize the single quotes as contents of the arg" do
          s = %{-e "hello'world"}
          expect(s.to_argv).to eql(['-e', "hello'world"])
        end
    end

    context "when there double quotes nested in single quotes" do
        it "will recognize the double quotes as contents of the arg" do
          s = %{-e 'hello"world'}
          expect(s.to_argv).to eql(['-e', 'hello"world']) 
        end
    end

    context "when there are escaped double quote in double quotes" do
        it "will recognize the escaped quotes as contents of the arg" do
          s = %{-e "hello\\"world"}
          expect(s.to_argv).to eql(['-e', 'hello"world']) 
        end
    end

    context "when there are unclosed quote" do
        it "will close the unclosed quote" do
          s = %{-e 'mp4}
          expect(s.to_argv).to eql(['-e', 'mp4'])
        end
    end

  end

end