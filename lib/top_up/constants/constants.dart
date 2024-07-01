const kTopUpOptions = [
  5,
  10,
  20,
  30,
  50,
  75,
  100,
];

const kMaxUnverifiedMonthlyTopUpAmount = 500.0;
const kMaxVerifiedMonthlyTopUpAmount = 1000.0;
const kMaxTopUpMonthlyAmount = 3000.0;
const kCanNotAddBeneficiaryErrorMessage = 'You can only have 5 beneficiaries';
const kErrorAddingBeneficiaryErrorMessage = 'Error adding beneficiary';
const kErrorFetchingUserBeneficiariesErrorMessage = 'Error fetching user beneficiaries';
const kErrorFetchingUserTransactionsErrorMessage = 'Error fetching user transactions';
const kInsufficientFundsErrorMessage = 'Insufficient funds';
const kErrorToppingUpBeneficiaryErrorMessage = 'Error topping up beneficiary';
const kErrorAddingCreditErrorMessage = 'Error adding credit';

const kMaxUnverifiedMonthlyTopUpAmountErrorMessage =
    'You have reached the maximum top up amount of AED $kMaxUnverifiedMonthlyTopUpAmount for this month for this beneficiary';

const kMaxVerifiedMonthlyTopUpAmountErrorMessage =
    'You have reached the maximum top up amount of AED $kMaxVerifiedMonthlyTopUpAmount for this month for that beneficiary';

const kMaxTopUpMonthlyAmountErrorMessage =
    'You have reached the maximum top up amount of AED $kMaxTopUpMonthlyAmount for this month';
