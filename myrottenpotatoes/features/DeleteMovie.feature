Feature: User can manually delete movie

Scenario: Delete movie

  Given I am on the RottenPotatoes home page
  When I follow "Add new movie"
  Then I should be on the Create New Movie page
  When I fill in "Title" with "Men In Black"
  And I select "PG-13" from "Rating"
  And I press "Save Changes"
  Then I should be on the RottenPotatoes home page
  And I should see "More about Men In Black"
  Then I follow "More about Men In Black"
  Then I follow "Delete"
  Then I should be on the RottenPotatoes home page
