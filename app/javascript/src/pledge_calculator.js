var updateBalance = function() {
    if ($("#patient_procedure_cost").val()) {
        $(".outstanding-balance-ctn").removeClass('hidden');
        return $("#outstanding-balance").text('$' + calculateRemainder());
    } else {
        return $(".outstanding-balance-ctn").addClass('hidden');
    }
};

var calculateRemainder = function() {
    var contributions, total;
    total = valueToNumber($("#patient_procedure_cost").val());
    contributions =
        valueToNumber($("#patient_patient_contribution").val()) +
        valueToNumber($("#patient_naf_pledge").val()) +
        valueToNumber($("#patient_fund_pledge").val()) +
        valueToNumber($(".external_pledge_amount").toArray().reduce(function(acc, next) {
        return acc + valueToNumber($(next).val());
    }, 0));
    return total - contributions;
};

var valueToNumber = function(val) {
    return +val || 0;
};