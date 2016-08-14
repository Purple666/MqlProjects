//+------------------------------------------------------------------+
//|                                                  RunAllTests.mq4 |
//|                                Copyright 2016, Chirita Alexandru |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Chirita Alexandru"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


#property indicator_chart_window  // Drawing in the chart window
//#property indicator_separate_window // Drawing in a separate window
#property indicator_buffers 0       // Number of buffers
#property indicator_color1 Blue     // Color of the 1st line
#property indicator_color2 Red      // Color of the 2nd line

#include "../../MqlLibs/DecisionMaking/DecisionDoubleBB.mq4"
#include "../../MqlLibs/DecisionMaking/Decision3MA.mq4"
#include "../../MqlLibs/DecisionMaking/DecisionRSI.mq4"
#include "../../MqlLibs/TransactionManagement/BaseTransactionManagement.mq4"
#include "../../MqlLibs/VerboseInfo/ScreenInfo.mq4"
#include "../../MqlLibs/VerboseInfo/VerboseInfo.mq4"
#include "../../MqlLibs/MoneyManagement/MoneyBetOnDecision.mq4"


//+------------------------------------------------------------------+
//| Expert initialization function (used for testing)                |
//+------------------------------------------------------------------+
int init()
{
	// print some verbose info
	VerboseInfo vi;
	vi.BalanceAccountInfo();
	vi.ClientAndTerminalInfo();
	vi.PrintMarketInfo();
	
	return INIT_SUCCEEDED;
}


int start()
{
	// Decisions:
	DecisionRSI rsiDecision;
	Decision3MA maDecision;
	DecisionDoubleBB bbDecision;
	
	// Transaction management (send/etc)
	BaseTransactionManagement transaction;
	transaction.SetVerboseLevel(1);
	
	// Money management:
	MoneyBetOnDecision money(rsiDecision.GetMaxDecision() + maDecision.GetMaxDecision() + bbDecision.GetMaxDecision(),0.0,0);
	
	// Screen management:
	ScreenInfo screen;
	
	int i = Bars - IndicatorCounted() - 1;
	double SL = 0.0, TP = 0.0;
	
	while(i >= 0)
	{
		double decision = bbDecision.GetDecision(SL, TP, 1.0, i) + rsiDecision.GetDecision(i) + maDecision.GetDecision(i);
		int DecisionOrderType = (int)(decision > 0.0 ? BuyDecision : IncertitudeDecision) + 
			(int)(decision < 0.0 ? SellDecision : IncertitudeDecision);
		double price = money.GetPriceBasedOnDecision(decision);
		
		if((SL == 0.0) || (TP == 0.0))
			money.CalculateTP_SL(TP, SL, DecisionOrderType, price);
		
		if(decision != IncertitudeDecision)
		{
			if(DecisionOrderType > 0) // Buy
				transaction.SimulateOrderSend(Symbol(), OP_BUY, 0.1, price,0,SL,TP,NULL, 0, 0, clrNONE, i);
			else // Sell
				transaction.SimulateOrderSend(Symbol(), OP_SELL, 0.1, price,0,SL,TP,NULL, 0, 0, clrNONE, i);
		}
		i--;
	}
	
	return 0;
}
