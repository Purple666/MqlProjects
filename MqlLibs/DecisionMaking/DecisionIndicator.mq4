//+------------------------------------------------------------------+
//|                                            DecisionIndicator.mq4 |
//|                                Copyright 2016, Chirita Alexandru |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright 2016, Chirita Alexandru"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "BaseDecision.mq4"


const double InvalidValue = 0.0;

class DecisionIndicator : public BaseDecision
{
	protected:
		int ShiftValue; // difference between current data and almost current data (current data - ShiftValue)
		int InternalShift; // used to calculate decision in the past
		
	public:
		DecisionIndicator(int verboseLevel = 1, int shiftValue = 1, int internalShift = 0) : BaseDecision(verboseLevel)
		{
			this.ShiftValue = shiftValue;
			this.InternalShift = internalShift;
		}
		
		~DecisionIndicator() {}
};
