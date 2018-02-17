module Expando
  module ApiAi
    module SystemEntityExamples
      # Example system entity values to use when replacing/annotating entity values.
      #
      # @see https://dialogflow.com/docs/reference/system-entities
      VALUES = {
        'sys.unit-currency' => [
          '5 dollars',
          '25 pounds'
        ],
        'sys.date-time' => [
          'Tomorrow',
          '5:30 pm',
          'Today at 4 pm',
          'Last morning',
          '1st to 3rd of January',
          'January 1st at 3 pm'
        ],
        'sys.date' => [
          'January 1',
          'Tomorrow',
          'January first'
        ],
        'sys.date-period' => [
          'April',
          'weekend',
          'from 1 till 3 of May',
          'in 2 days'
        ],
        'sys.given-name' => [
          'Matthew',
          'Jim',
          'Robert',
          'Lauren'
        ],
        'sys.number-integer' => [
          '1',
          '34',
          '5'
        ],
        'sys.number' => [
          'ten',
          'twenty',
          'tenth',
          'third'
        ],
        'sys.time' => [
          '1 pm',
          '20:30',
          'half past four',
          'in 2 minutes'
        ],
        'sys.any' => [
          'anything',
          'this is many words'
        ],
        'sys.time-period' => [
          'morning',
          'in the afternoon',
          'evening',
          'at night'
        ]
      }
    end
  end
end
