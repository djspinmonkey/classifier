require File.dirname(__FILE__) + '/../test_helper'
class BayesianTest < Test::Unit::TestCase
	def setup
		@classifier = Classifier::Bayes.new 'Interesting', 'Uninteresting'
	end
	
	def test_good_training
		assert_nothing_raised { @classifier.train_interesting "love" }
	end

	def test_bad_training
		assert_raise(StandardError) { @classifier.train_no_category "words" }
	end
	
	def test_bad_method
		assert_raise(NoMethodError) { @classifier.forget_everything_you_know "" }
	end
	
	def test_categories
		assert_equal ['Interesting', 'Uninteresting'].sort, @classifier.categories.sort
	end

	def test_add_category
		@classifier.add_category 'Test'
		assert_equal ['Test', 'Interesting', 'Uninteresting'].sort, @classifier.categories.sort
	end

	def test_classification
		@classifier.train_interesting "here are some good words. I hope you love them"
		@classifier.train_uninteresting "here are some bad words, I hate you"
		assert_equal 'Uninteresting', @classifier.classify("I hate bad words and you")
	end

  def test_weighted_classification
    3.times { @classifier.train(:Interesting, "These words are only sligtly ok", 0.25) }
    @classifier.train(:Uninteresting, "But these ones are totally bad.")
		assert_equal 'Uninteresting', @classifier.classify("Now we have bad and ok.")
  end
end
