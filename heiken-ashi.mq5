#property copyright "Copyright 2023, KaiAlgo"
#property version   "1.00"

#property indicator_separate_window 

#property indicator_buffers 5
#property indicator_plots   1 

#property indicator_label1  "Heiken ashi bars" 
#property indicator_type1   DRAW_COLOR_CANDLES 
#property indicator_color1  clrGreen, clrRed
#property indicator_style1  STYLE_SOLID 
#property indicator_width1  1 

double haOpen[];
double haHigh[];
double haLow[];
double haClose[];

double barColorBuffer[];


int OnInit() {

   SetIndexBuffer(0, haOpen, INDICATOR_DATA);
   SetIndexBuffer(1, haHigh, INDICATOR_DATA);
   SetIndexBuffer(2, haLow, INDICATOR_DATA);
   SetIndexBuffer(3, haClose, INDICATOR_DATA);
   SetIndexBuffer(4, barColorBuffer, INDICATOR_COLOR_INDEX);
   
   PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, 0);
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0.0);
   PlotIndexSetInteger(0,PLOT_SHOW_DATA,false);
   
    IndicatorSetInteger(INDICATOR_LEVELS,1);
   
   return(INIT_SUCCEEDED);
}



int OnCalculate(const int rates_total, // rates_total is the number of total available candles
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){
   
   if (IsStopped()) return 0;             // This line respects MetaTrader stop flag
   
   haOpen[0] = 0.0;
   haHigh[0] = 0.0;
   haLow[0] = 0.0;
   haClose[0] = 0.0;
   barColorBuffer[0] = clrGreen;
   

   for(int i = 1; i < rates_total; i++) {
      double candleOpen = open[i];
      double candleHigh = high[i];
      double candleLow = low[i];
      double candleClose = close[i];
      
      haClose[i] = (candleOpen + candleHigh + candleLow + candleClose) / 4;
      haOpen[i] = (haOpen[i-1] + haClose[i-1]) / 2;
      haHigh[i] = (double)MathMax(MathMax(candleHigh, haOpen[i]), haClose[i]);
      haLow[i] = (double)MathMin(MathMin(candleLow, haOpen[i]), haClose[i]);
      
      if (haClose[i] > haOpen[i]) {
         barColorBuffer[i] = 0.0;
      } else if (haClose[i] < haOpen[i]) {
         barColorBuffer[i] = 1.1;
      } else {
         barColorBuffer[i] = 0.0;
      } 
      IndicatorSetDouble(INDICATOR_LEVELVALUE, haClose[i]);        
   }


   return(rates_total);
}
