//+------------------------------------------------------------------+
//|                                       TestSimulateTranSystem.mq4 |
//|                                Copyright 2016, Chirita Alexandru |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Chirita Alexandru"
#property link      "https://www.mql5.com"
#property version   "1.20"
#property strict

#include <MyMql\System\SimulateTranSystem.mqh>
#include <stdlib.mqh>
#include <stderror.mqh>

static SimulateTranSystem system(DECISION_TYPE_ALL, LOT_MANAGEMENT_ALL, TRANSACTION_MANAGEMENT_ALL);

int OnInit()
{
	GlobalContext.InitRefresh();
	
	if(FirstSymbol == NULL)
	{
		GlobalContext.Config.Initialize(true, true, false, true, __FILE__);
		
		GlobalContext.DatabaseLog.Initialize(true);
		GlobalContext.DatabaseLog.ParametersSet(GlobalContext.Config.GetConfigFile());
		GlobalContext.DatabaseLog.CallWebServiceProcedure("NewTradingSession");
		
		Print(GlobalContext.Config.GetConfigFile());
		
		// Setup system only at the beginning:
		system.SetupTransactionSystem(_Symbol);
	}
	
	system.TestTransactionSystemForCurrentSymbol(true, true, false);
	
	if(!GlobalContext.Config.ChangeSymbol())
	{
		GlobalContext.DatabaseLog.ParametersSet(GlobalContext.Config.GetConfigFile());
		GlobalContext.DatabaseLog.CallWebServiceProcedure("EndTradingSession");
	}
	
	return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
	system.PrintDeInitReason(reason);
	system.CleanTranData();
	//system.RemoveUnusedDecisionsTransactionsAndLots();
}
