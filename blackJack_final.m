%This code will simulate a game of blackjack between a user and the
%dealer (computer)
clear;
clc;

%starting pool of $100
moneyPool = 100;

%initialising variable
bet = 0;

%input from user asking if they would like to play
playerStatus = input('Would you like to play a round of blackjack? ', 's');
playerStatus = lower(playerStatus);

%check for valid input
while strcmp(playerStatus, 'yes') ==0 && strcmp(playerStatus, 'no') == 0
    fprintf('\nSorry that was an invalid response, please try again.');
    playerStatus = input(['\nWould you like to play a round of' ...
        ' blackjack? '], 's');
end

if strcmp(playerStatus, 'no') == 1
    fprintf('\nThank you for playing, have a nice day.\n');
    return
end


%building the deck using function buildDeck

[decks, value] = buildDeck;

fprintf(['Your current balance is $%0.2f\n' ...
    '-----------------------------\n'], moneyPool);


%will continue to play until player runs out of money or decides not to
%play
while strcmp(playerStatus, 'no') == 0

    %check for valid input
    bet = input('Place your bets: ');
    while (bet <= 0 || bet > moneyPool)
        if (bet < 0)
            fprintf('\nYou can''t bet a negative amount.');
            bet = input('\nPlace your bets: ');
        elseif (bet > moneyPool)
            fprintf('\nYou can''t bet more than you have.')
            bet = input('\nPlace your bets: ');
        elseif (bet == 0)
            fprintf('\nYou have to place a bet.');
            bet = input('\nPlace your bets: ');
        end
    end

%initialising vectors to store player and dealer cards and value
player = [];
dealer = [];
playerValue = [];
dealerValue = [];

%alternate deal between player and dealer
for i = 1:2
    player = [player decks(1)];
    decks = decks(2:end);
    dealer = [dealer decks(1)];
    decks = decks(2:end);
    playerValue = [playerValue value(1)];
    value = value(2:end);
    dealerValue = [dealerValue value(1)];
    value = value(2:end);
end

%displaying the starting hands
fprintf("Current hand: %s\t%s \nValue of: %d\n\n", player(1), player(2) ...
    , sum(playerValue));

fprintf("Dealers hand: %s\t1 face down card\nValue of: %d\n\n", ...
    dealer(1), dealerValue(1));

%initialising exit for while loop
playerMove = ' ';

%while loop for player to choose to hit or stay
while strcmp(playerMove, 'stay') == 0 && strcmp(playerMove, 'bust') == 0

    %user input to ask for next move
    move = input('Would you like to hit or stay?: ', 's');
    move = lower(move);

    %check for valid input
    while strcmp(move, 'hit') ==0 && strcmp(move, 'stay') == 0
        fprintf(['\nSorry that was an invalid response, please try' ...
            ' again.\n']);
        move = input('Would you like to hit or stay?: ', 's');
        move = lower(move);
    end

    if strcmp(move, 'hit') == 1 && sum(playerValue) <= 21
        player = [player decks(1)];
        decks = decks(2:end);
        playerValue = [playerValue value(1)];
        value = value(2:end);
        fprintf("-----------------------------------\nCurrent hand: ");
        for i = 1:length(player)
            fprintf("%s\t ", player(i));
        end
        fprintf("\nValue of: %d\n\n", sum(playerValue));
    elseif strcmp(move, 'stay') == 1
        fprintf("-----------------------------------\nYou have" + ...
            " decided to stay.\n");
        playerMove = 'stay';
    end

    if sum(playerValue) > 21
        playerMove = 'bust';
    end
end

%ends round if player goes bust
if sum(playerValue) > 21
    moneyPool = moneyPool - bet;
    fprintf("You have gone bust. Dealer wins.\n");
    if moneyPool <= 0
        fprintf('\nUh oh, you have run out of money. Goodbye.\n')
        return
    end
        playerStatus = input('\nYour current balance is $' + string ...
            (moneyPool) +  '. Would you like to play again? ', 's');
        playerStatus = lower(playerStatus);
        
    while strcmp(playerStatus, 'yes') ==0 && strcmp(playerStatus, 'no')...
        == 0
        fprintf('Sorry that was an invalid response, please try again.')
        playerStatus = input('\nYour current balance is $' + string ...
            (moneyPool) +  '. Would you like to play again? ', 's');
    end

    if strcmp(playerStatus, 'no') == 1
        fprintf('\nThank you for playing, have a nice day.\n');
    end
    continue
end

if strcmp(playerMove, 'bust') == 0
%revealing the facedown card to user now that they have stopped
fprintf("\nDealers hand: %s\t%s \nValue of: %d\n\n", dealer(1), ...
    dealer(2), sum(dealerValue));

%initialising exit
dealerMove = ' ';

%while loop to simulate dealer interaction
while strcmp(dealerMove, 'stay') == 0 && strcmp(dealerMove, 'bust') ==0
   
    if sum(dealerValue) == 21
        dealerMove = 'stay';
    elseif (sum(dealerValue) < 17)
        dealer = [dealer decks(1)];
        decks = decks(2:end);
        dealerValue = [dealerValue value(1)];
        value = value(2:end);
        fprintf("Dealers hand: ");
        for i = 1:length(dealer)
           fprintf("%s\t ", dealer(i));
        end
        fprintf("\nValue of: %d\n\n", sum(dealerValue));
    elseif (sum(dealerValue) >= 17 && sum(dealerValue) <= 21)
        fprintf('\nThe Dealer decided to stay.\n');
        dealerMove = 'stay';
    elseif (sum(dealerValue) >21)
        dealerMove = 'bust';
    end
end

%reveal final hands of both player and dealer
fprintf('\n---------------------------------------------------------\n\n');

fprintf("Your final hand: ");
    for i = 1:length(player)
           fprintf("%s\t ", player(i));
    end
fprintf("\nValue of: %d\n\n", sum(playerValue));

fprintf("Dealers final hand: ");
    for i = 1:length(dealer)
           fprintf("%s\t ", dealer(i));
    end
fprintf("\nValue of: %d\n\n\n", sum(dealerValue));


%decide outcome for the round

    if sum(playerValue) == sum(dealerValue)
        fprintf("It's a tie.\n\n")
    
    elseif sum(playerValue) == 21 && length(playerValue) == 2
        moneyPool = moneyPool + (bet*1.5);
        chickenDinner; %function that will display the word winner
        
    elseif sum(dealerValue) == 21 && length(dealerValue) == 2
        moneyPool = moneyPool - bet;
        fprintf('The dealer has blackjack and wins.\n\n')
    
    elseif sum(dealerValue) > 21
        moneyPool = moneyPool + bet;
        fprintf('Dealer has gone bust. You win.\n\n')
    
    elseif sum(playerValue) > sum(dealerValue)
        moneyPool = moneyPool + bet;
        fprintf('You win. Congratulations.\n\n')
    
    elseif sum(dealerValue) > sum(playerValue)
        moneyPool = moneyPool - bet;
        fprintf('The dealer wins. Better luck next time.\n\n')
    end
end

if moneyPool <= 0
    fprintf('\nUh oh, you have run out of money. Goodbye.\n')
    return
end
%asking user if they would like to go again
playerStatus = input('\nYour current balance is $' + string(moneyPool) ...
    +  ', would you like to play again? ', 's');
playerStatus = lower(playerStatus);

while strcmp(playerStatus, 'yes') ==0 && strcmp(playerStatus, 'no') == 0
    fprintf('\nSorry that was an invalid response, please try again.\n')
    playerStatus = input('\nYour current balance is $' + string ...
        (moneyPool) +  ', would you like to play again? ', 's');
end

if strcmp(playerStatus, 'no') == 1
    fprintf('\nThank you for playing, have a nice day.\n');
end
end