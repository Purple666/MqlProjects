#property copyright "Copyright 2016, Chirita Alexandru"
#property link      "https://www.mql5.com"
#property version   "1.01"
#property strict

#property description "First program made, used to check some MQL4 functions" 



#include <MyMql/TransactionManagement/CrappyTranManagement.mqh>
#include <MyMql/MoneyManagement/BaseMoneyManagement.mqh>
#include <MyMql/Info/ScreenInfo.mqh>

#include <MyMql/Info/VerboseInfo.mqh>
#include <MyMql/DecisionMaking/DecisionDoubleBB.mqh>
#include <MyMql/DecisionMaking/Decision3MA.mqh>
#include <MyMql/DecisionMaking/DecisionRSI.mqh>


int OnInit()
{
	// Print (one time) information
	VerboseInfo vi;
	vi.ClientAndTerminalInfo();
	vi.BalanceAccountInfo();
	vi.PrintMarketInfo();
	
	//--- create timer (seconds)
	EventSetTimer(1);
	
	// Validations
	return vi.ExpertValidationsTest();
}


void OnDeinit(const int reason)
{
	printf("OnDeinit: reason = %f", reason);
}

double CalculateDecision(double stopLoss = 0.0, double takeProfit = 0.0)
{
	DecisionDoubleBB doubleBB;
	Decision3MA ma;
	DecisionRSI rsi;
	
	double finalResult = 
		rsi.GetDecision() +
		ma.GetDecision() +
		doubleBB.GetDecision(stopLoss, takeProfit);
	
	printf("Final decision: %f\n Stop loss: %f\n Take profit: %f",
		finalResult, stopLoss, takeProfit);
	return finalResult;
}

void OnTick()
{
	
}


void OnTimer()
{
	double SL = InvalidValue, TP = InvalidValue;
	double decision = CalculateDecision(SL, TP); // maximum possible value is +/-14.0
	
	if(MathAbs(decision) >= 7.0)
	{
		if(decision > 0.0)
		{
		}
		else
		{
		
		}
	}
}
