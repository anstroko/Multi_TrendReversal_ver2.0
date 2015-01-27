         //+------------------------------------------------------------------+
//|                                             SunExpert ver0.1.mq4 |
//|                                                Alexander Strokov |
//|                                    strokovalexander.fx@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Alexander Strokov"
#property link      "strokovalexander.fx@gmail.com"
#property version   "2.0"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

extern string Параметры1="Основные переменные ордеров";
extern bool BuyTrade=true;
extern bool SellTrade=true;
extern int filtr=5;
extern int BodySize=0;
extern int CandleSize=0;
extern int OrdersToZero=5;
extern int TP=10;
extern double BonusDollar=1;
extern int Magic_Number=3213;
extern double Percent=30;
extern double CoeffNull=7;
extern int Lok=3;
extern double Buy1=3;
extern double Buy2=4;
extern double Buy3=5;
extern double Buy4=6;
extern double Sell1=3;
extern double Sell2=4;
extern double Sell3=5;
extern double Sell4=6;
//extern bool DinamicLot=true;
//extern double MM=35000;
extern string Параметры2="Уровни открытия хеджирующих ордеров Buy/Sell";
extern double Level1=100;
extern double Level2=150;
extern double Level3=200;
extern double Level4=250;
extern double Level5=300;
extern double Level6=350;
extern double Level7=400;
extern double Level8=450;
extern double Level9=500;
extern string Параметры3="Объемы ордеров Buy/Sell";
extern double Lot1=0.1;
extern double CoefLot=1.6;


int ss;
int bb; 
double TP1;
int k;
double Lot;
double LastBuyLot;
double LastSellLot;
double GoGoBuy=1;
double GoGoSell=1;
bool StartBuyOrders;
bool StartSellOrders;
int CountBuy;
int CountSell;
double TotalSlt;
double TotalBLt;
double OrderSwaps;
double LastBuyPrice;
double LastSellPrice;
double TPB;
double TPS;
int total;
bool SellLimitInTrade;
bool BuyLimitInTrade;
double BuyLimitPrice;
double SellLimitPrice;
int ReCountBuy;
int ReCountSell;
double ReBuyLots;
double ReSellLots;
double BuyLots;
double SellLots;
bool CloseLokB;
bool CloseLokS;
bool BuyGoToZero;
bool SellGoToZero;
double BuyOrdersProfit;
double SellOrdersProfit;
int NumSLimOrders;
int NumBLimOrders;
double FirstBuyOrderProfit;
double SecondBuyOrderProfit;
double FirstSellOrderProfit;
double SecondSellOrderProfit;
double FirstBuyPrice;
double FirstSellPrice;
bool NoDeleteBuyProfit;
bool NoDeleteSellProfit;
bool TradeWithTPB=false;
bool TradeWithTPS=false;
bool SecondSellSeries;
bool SecondBuySeries;
bool ThirdSellSeries;
bool ThirdBuySeries;
int Ticket;
int Ticket2;
bool ZeroS1;
bool ZeroS2;
bool ZeroB1;
bool ZeroB2;
bool OnlyToZeroBuy;
bool OnlyToZeroSell;
int DeGreeBuy;
int DeGreeSell;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {

   if((Digits==3)||(Digits==5)) { k=10;}
   if((Digits==4)||(Digits==2)) { k=1;}
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {

   ObjectDelete("label_object1");
   ObjectDelete("label_object2");
   ObjectDelete("label_object3");
   ObjectDelete("label_object4");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
 /*  if(IsDemo()==false) 
     {
      Alert("Неверный счет!");
      Sleep(6000);return(0);
     }*/
 ObjectCreate("label_object1",OBJ_LABEL,0,0,0);
ObjectSet("label_object1",OBJPROP_CORNER,4);
ObjectSet("label_object1",OBJPROP_XDISTANCE,10);
ObjectSet("label_object1",OBJPROP_YDISTANCE,10);
ObjectSetText("label_object1","Количество ордеров Buy="+CountBuy+";Торгуемый лот="+DoubleToStr(TotalBLt,2)+";Обнуляем Sell="+SellGoToZero,12,"Arial",Red);


ObjectCreate("label_object2",OBJ_LABEL,0,0,0);
ObjectSet("label_object2",OBJPROP_CORNER,4);
ObjectSet("label_object2",OBJPROP_XDISTANCE,10);
ObjectSet("label_object2",OBJPROP_YDISTANCE,30);
ObjectSetText("label_object2","Количество ордеров Sell="+CountSell+";Торгуемый лот="+DoubleToStr(TotalSlt,2)+";Обнуляем Buy="+BuyGoToZero,12,"Arial",Red);
  /* 
ObjectCreate("label_object3",OBJ_LABEL,0,0,0);
ObjectSet("label_object3",OBJPROP_CORNER,4);
ObjectSet("label_object3",OBJPROP_XDISTANCE,10);
ObjectSet("label_object3",OBJPROP_YDISTANCE,50);
ObjectSetText("label_object3","Вторая серия Buy="+SecondBuySeries+"; Третья серия Buy="+ThirdBuySeries,12,"Arial",Red);
      
   
ObjectCreate("label_object4",OBJ_LABEL,0,0,0);
ObjectSet("label_object4",OBJPROP_CORNER,4);
ObjectSet("label_object4",OBJPROP_XDISTANCE,10);
ObjectSet("label_object4",OBJPROP_YDISTANCE,70);
ObjectSetText("label_object4","Вторая серия Sell="+SecondSellSeries+"; Третья серия Sell="+ThirdSellSeries,12,"Arial",Red);
         */
   
   
   
   ReCountBuy=0;ReCountSell=0;ReBuyLots=0;ReSellLots=0;bb=0;ss=0;SellGoToZero=false;BuyGoToZero=false;bb=0;ss=0;
   //if (SecondBuySeries==true){bb=1;}if (ThirdBuySeries==true){bb=2;}if (SecondSellSeries==true){ss=1;}if (ThirdSellSeries==true){ss=2;}
   for(int in=0;in<OrdersTotal();in++)
     {      if(OrderSelect(in,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number) )
           {
            if(OrderType()==OP_BUY){ReCountBuy=ReCountBuy+1;ReBuyLots=ReBuyLots+OrderLots(); if((ReCountBuy+bb)>=OrdersToZero){BuyGoToZero=true;}}
            if(OrderType()==OP_SELL){ReCountSell=ReCountSell+1;ReSellLots=ReSellLots+OrderLots();if((ReCountSell+ss)>=OrdersToZero){SellGoToZero=true;}}
           }
        }
     }
   
   
     
   //   if (ReCountBuy==0){SecondBuySeries=false;ThirdBuySeries=false;}
  //    if (ReCountSell==0){SecondSellSeries=false;ThirdSellSeries=false;}

   //   if ((BuyGoToZero==false)&&(SellGoToZero==false)&&(ReCountBuy==0)&&(ReCountSell!=0)){SearchFirstSellOrder();OrderSelect(Ticket, SELECT_BY_TICKET);Sleep(1000);if ((OrderLots()/(Lot1))>1.00){SecondSellSeries=true;}if (OrderLots()/(Lot1*(1+Percent/100))>1.00){SecondSellSeries=false;ThirdSellSeries=true;}}
   //   if ((BuyGoToZero==false)&&(SellGoToZero==false)&&(ReCountBuy!=0)&&(ReCountSell==0)){SearchFirstBuyOrder();OrderSelect(Ticket, SELECT_BY_TICKET);Sleep(1000);if ((OrderLots()/(Lot1))>1.00){SecondBuySeries=true;}if (OrderLots()/(Lot1*(1+Percent/100))>1.00){SecondBuySeries=false;ThirdBuySeries=true;}}
      
      
if ((BuyGoToZero==true)&&(ReCountSell==2)&&(CountSell==1)&&(ZeroS1==true)&&(DeGreeSell==0)&&(NoDeleteSellProfit==false)){DeleteSellTakeProfit();  }
if ((BuyGoToZero==true)&&(ReCountSell==3)&&(CountSell==2)&&(ZeroS2==true)&&(DeGreeSell==0)&&(NoDeleteSellProfit==false)){DeleteSellTakeProfit();  }
if ((BuyGoToZero==true)&&(ReCountSell==3)&&(CountSell==2)&&(ZeroS1==true)&&(DeGreeSell==1)&&(NoDeleteSellProfit==false)){DeleteSellTakeProfit();  }
if ((BuyGoToZero==true)&&(ReCountSell==4)&&(CountSell==3)&&(ZeroS2==true)&&(DeGreeSell==1)&&(NoDeleteSellProfit==false)){DeleteSellTakeProfit();  }

if ((SellGoToZero==true)&&(ReCountBuy==2)&&(CountBuy==1)&&(ZeroB1==true)&&(DeGreeBuy==0)&&(NoDeleteBuyProfit==false)){DeleteBuyTakeProfit();}
if ((SellGoToZero==true)&&(ReCountBuy==3)&&(CountBuy==2)&&(ZeroB2==true)&&(DeGreeBuy==0)&&(NoDeleteBuyProfit==false)){DeleteBuyTakeProfit();}
if ((SellGoToZero==true)&&(ReCountBuy==3)&&(CountBuy==2)&&(ZeroB1==true)&&(DeGreeBuy==1)&&(NoDeleteBuyProfit==false)){DeleteBuyTakeProfit();}
if ((SellGoToZero==true)&&(ReCountBuy==4)&&(CountBuy==3)&&(ZeroB2==true)&&(DeGreeBuy==1)&&(NoDeleteBuyProfit==false)){DeleteBuyTakeProfit();}
//Пересчет локовых ордеров в 0
if((ReCountBuy>0)&&((ReBuyLots<BuyLots) || (ReBuyLots>BuyLots))&&(OnlyToZeroBuy==true)){Print("Произошли изменения у ордеров buy,пересчитаем ТР в 0");CalculateTotalBuyTPToZero();}
if((ReCountSell>0)&&((ReSellLots<SellLots) || (ReSellLots>SellLots))&&(OnlyToZeroSell==true)){Print("Произошли изменения у ордеров sell,пересчитаем ТР в 0");CalculateTotalSellTPToZero();}
if((ReCountBuy==0)&&(BuyGoToZero==false)&&(CloseLokB==true)){Print("Закрылись ордера на покупку, выводим sell ордера в 0");CalculateTotalSellTPToZero();OnlyToZeroSell=true;}
if((ReCountSell==0)&&(SellGoToZero==false)&&(CloseLokS==true)){Print("Закрылись ордера на покупку, выводим buy ордера в 0");CalculateTotalBuyTPToZero();OnlyToZeroBuy=true;}
if ((OnlyToZeroBuy==true)&&(ReCountBuy==0)&&(CountBuy!=0)){Print("Закрылись в 0, дальше работаем с ТР");OnlyToZeroBuy=false;}
if ((OnlyToZeroSell==true)&&(ReCountSell==0)&&(CountSell!=0)){Print("Закрылись в 0, дальше работаем с ТР");OnlyToZeroSell=false;}

if((ReCountBuy>0)&&(OnlyToZeroBuy==false)&&((SellGoToZero==false)||(NoDeleteBuyProfit==true))&& ((ReBuyLots<BuyLots) || (ReBuyLots>BuyLots))){Print("Произошли изменения,пересчитаем профит у buy ордеров");CalculateTotalBuyTP();}
if((ReCountSell>0)&&(OnlyToZeroSell==false)&&((BuyGoToZero==false)||(NoDeleteSellProfit==true))&& ((ReSellLots<SellLots) || (ReSellLots>SellLots))){Print("Произошли изменения,пересчитаем профит у sell ордеров");CalculateTotalSellTP();}

if(((ZeroB2==true)&&(DeGreeBuy==0)&&(ReCountBuy==2)&&(CountBuy==1))||((ZeroB1==true)&&(DeGreeBuy==1)&&(ReCountBuy==2)&&(CountBuy==1))||((ZeroB2==true)&&(DeGreeBuy==1)&&(((ReCountBuy==2)&&(CountBuy==1))||((ReCountBuy==3)&&(CountBuy==2))))){Print("Произошли изменения в лок ордерах,пересчитаем профит у buy ордеров");CalculateTotalBuyTP();}
if(((ZeroS2==true)&&(DeGreeSell==0)&&(ReCountSell==2)&&(CountSell==1))||((ZeroS1==true)&&(DeGreeSell==1)&&(ReCountSell==2)&&(CountSell==1))||((ZeroS2==true)&&(DeGreeSell==1)&&(((ReCountSell==2)&&(CountSell==1))||((ReCountSell==3)&&(CountSell==2))))){Print("Произошли изменения в лок ордерах,пересчитаем профит у sell ордеров");CalculateTotalSellTP();}


 SellOrdersProfit=0; BuyOrdersProfit=0; FirstBuyOrderProfit=0; FirstSellOrderProfit=0;SecondBuyOrderProfit=0; SecondSellOrderProfit=0;


if (BuyGoToZero==true){

if(ZeroS1==true){
if ((ReCountSell>(1+DeGreeSell))) {SearchFirstBuyOrder(); SearchLokSellOrdersProfit(); OrderSelect(Ticket, SELECT_BY_TICKET);FirstBuyOrderProfit=OrderProfit();if(FirstBuyOrderProfit!=0){
  if(OrderLots()*CoeffNull<ReSellLots){  if((SellOrdersProfit+FirstBuyOrderProfit)>BonusDollar*100){Print("Закрываем первый ордер на покупку и ордера на продажу");CloseFirstBuySellOrders();}}
  else {if((SellOrdersProfit+FirstBuyOrderProfit/2)>BonusDollar*100){Print("Закрываем половину первого ордера на покупку и ордера на продажу");CloseMidFirstBuySellOrders();}}}
  }}
  

if(ZeroS2==true){
if (ReCountSell>(2+DeGreeSell)) {SearchFirstBuyOrder(); SearchLokSellOrdersProfit(); OrderSelect(Ticket, SELECT_BY_TICKET);FirstBuyOrderProfit=OrderProfit();if(FirstBuyOrderProfit!=0){
  if(OrderLots()*CoeffNull<ReSellLots){  if((SellOrdersProfit+FirstBuyOrderProfit)>BonusDollar*100){Print("Закрываем первый ордер на покупку и ордера на продажу");CloseFirstBuySellOrders();}}
  else {if((SellOrdersProfit+FirstBuyOrderProfit/2)>BonusDollar*100){Print("Закрываем половину первого ордера на покупку и ордера на продажу");CloseMidFirstBuySellOrders();}}
  
  }}

}}

                      
SellOrdersProfit=0; BuyOrdersProfit=0; FirstBuyOrderProfit=0; FirstSellOrderProfit=0;SecondBuyOrderProfit=0; SecondSellOrderProfit=0;                      
if (SellGoToZero==true){

if(ZeroB1==true){
if ((ReCountBuy>(1+DeGreeBuy))) {SearchFirstSellOrder();SearchLokBuyOrdersProfit();OrderSelect(Ticket, SELECT_BY_TICKET);FirstSellOrderProfit=OrderProfit();if(FirstSellOrderProfit!=0){
  if(OrderLots()*CoeffNull<ReBuyLots){ if((BuyOrdersProfit+FirstSellOrderProfit)>BonusDollar*100){Print("Закрываем первый ордер на продажу и ордера на покупку");CloseFirstSellBuyOrders();}}
  else{if((BuyOrdersProfit+FirstSellOrderProfit/2)>BonusDollar*100){Print("Закрываем первый ордер на продажу и ордера на покупку");CloseMidFirstSellBuyOrders();}}
  }}
}
if(ZeroB2==true){
if ((ReCountBuy>(2+DeGreeBuy))) {SearchFirstSellOrder();SearchLokBuyOrdersProfit();OrderSelect(Ticket, SELECT_BY_TICKET);FirstSellOrderProfit=OrderProfit();if(FirstSellOrderProfit!=0){
  if(OrderLots()*CoeffNull<ReBuyLots){if((BuyOrdersProfit+FirstSellOrderProfit)>BonusDollar*100){Print("Закрываем первый ордер на продажу и ордера на покупку");CloseFirstSellBuyOrders();}}
  else{if((BuyOrdersProfit+FirstSellOrderProfit/2)>BonusDollar*100){Print("Закрываем первый ордер на продажу и ордера на покупку");CloseMidFirstSellBuyOrders();}}
  }}
}


}
 
   CountBuy=0;CountSell=0;TotalSlt=0;TotalBLt=0;OrderSwaps=0;total=OrdersTotal();LastBuyPrice=0;LastSellPrice=0;BuyLots=0;SellLots=0;CloseLokB=false;CloseLokS=false;
   for(int i=0;i<total;i++)
     {
     
      if(OrderSelect(i,SELECT_BY_POS)==true)
        {
         if(OrderSymbol()==Symbol()) 
           {
            if(OrderType()==OP_BUY){CountBuy=CountBuy+1;TotalBLt=TotalBLt+OrderLots();BuyLots=BuyLots+OrderLots();if(CountBuy+bb>=OrdersToZero){CloseLokB=true;}}
            if(OrderType()==OP_SELL){CountSell=CountSell+1;TotalSlt=TotalSlt+OrderLots();SellLots=SellLots+OrderLots();if(CountSell+ss>=OrdersToZero){CloseLokS=true;}}
            if((OrderType()==OP_SELL) || (OrderType()==OP_BUY)){OrderSwaps=OrderSwaps+OrderSwap();}
           }
        }
     }

//#Удаление лимитных ордеров
   if(CountBuy==0)
     {
      for(int iDel=OrdersTotal()-1; iDel>=0; iDel--)
        {
         if(!OrderSelect(iDel,SELECT_BY_POS,MODE_TRADES)) break;
         if((OrderType()==OP_BUYLIMIT) && (OrderMagicNumber()==Magic_Number)) if(IsTradeAllowed()) 
           {
            if(OrderDelete(OrderTicket())<0)
              {
               Alert("Удаление лимитного ордера",GetLastError());
              }
           }
        }
     }
   if(CountSell==0)
     {
      for(int iDelS=OrdersTotal()-1; iDelS>=0; iDelS--)
        {
         if(!OrderSelect(iDelS,SELECT_BY_POS,MODE_TRADES)) break;
         if((OrderType()==OP_SELLLIMIT) && (OrderMagicNumber()==Magic_Number)) if(IsTradeAllowed()) 
           {
            if(OrderDelete(OrderTicket())<0)
              {
               Alert("Удаление лимитного ордера",GetLastError());
              }
           }
        }
     }


     
      //#Размещение 2-ого buy
      if((CountBuy==1) && (BuyTrade==true))
        {
         for(int ibuy=0;ibuy<OrdersTotal();ibuy++)
           {
         
            if(OrderSelect(ibuy,SELECT_BY_POS)==true)
              {
               if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) 
                 {
                  LastBuyPrice=OrderOpenPrice(); Lot=NormalizeDouble(OrderLots()*CoefLot,2);
                 }
              }
           }
         if(Ask<(LastBuyPrice-Level1*k*Point))
           {
            
            Print("Открываем 2-й ордер Buy");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"12",Magic_Number,0,Blue)<0)
                 {Alert("Возникла ошибка № ",GetLastError()); }
               
              }
           }
        }


      //#Размещение 2-ого sell
      if((CountSell==1) && (SellTrade==true))
        {
         for(int isell=0;isell<OrdersTotal();isell++)
           {
           
            if(OrderSelect(isell,SELECT_BY_POS)==true)
              {
               if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL))
                 {LastSellPrice=OrderOpenPrice();Lot=NormalizeDouble(OrderLots()*CoefLot,2);}
              }
           }
         if(Bid>(LastSellPrice+Level1*k*Point))
           {
          
            Print("Открываем 2-й ордер Sell");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"22",Magic_Number,0,Red)<0)
                 {Alert("Возникла ошибка № ",GetLastError()); }
             
              }
           }
        }


           //#Размещение 3-ого buy
      if((CountBuy==2) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level2*k*Point))
           {
        
            Print("Открываем 3-й ордер Buy");
             SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2);
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"13",Magic_Number,0,Blue)<0)
                 {Alert("Возникла ошибка № ",GetLastError()); }
               
              }
           }
        }


     //#Размещение 3-ого sell
      if((CountSell==2) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level2*k*Point))
           {
         
            Print("Открываем 3-й ордер Sell");
            SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2);
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"23",Magic_Number,0,Red)<0)
                 {Alert("Возникла ошибка № ",GetLastError()); }
              
              }
           }
        }

   //#Размещение 4-ого buy
      if((CountBuy==3) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level3*k*Point))
           {
           
            Print("Открываем 4-й ордер Buy");
                    SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2);
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"14",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }

              }
           }
        }


//#Размещение 4-ого  sell
      if((CountSell==3) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level3*k*Point))
           {
            
            Print("Открываем 4-й ордер Sell");
            SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2);
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"24",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
            
              }
           }
        }


   //#Размещение 5-ого buy
      if((CountBuy==4) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level4*k*Point))
           {
            
            Print("Открываем 5-й ордер Buy");
                    SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2);
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"15",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
           
              }
           }
        }


      //#Размещение 5-ого  sell
      if((CountSell==4) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level4*k*Point))
           {
         ;
            Print("Открываем 5-й ордер Sell");
            SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2);
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"25",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
           
              }
           }
        }

    //#Размещение 6-ого buy
      if((CountBuy==5) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level5*k*Point))
           {
        
            Print("Открываем 6-й ордер Buy");
                    SearchLastBuyLot();Lot=LastBuyLot*CoefLot;
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"16",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
              
              }
           }
        }


     //#Размещение 6-ого  sell
      if((CountSell==5) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level5*k*Point))
           {
            
            Print("Открываем 6-й ордер Sell");
            SearchLastSellLot();Lot=LastSellLot*CoefLot;
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"26",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               
              }
           }
        }
    //#Размещение 7-ого buy
      if((CountBuy==6) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level6*k*Point))
           {
          
            Print("Открываем 7-й ордер Buy");
                    SearchLastBuyLot();Lot=LastBuyLot*CoefLot;
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"17",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
              
              }
           }
        }


   //#Размещение 7-ого  sell
      if((CountSell==6) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level6*k*Point))
           {
           
            Print("Открываем 7-й ордер Sell");
            SearchLastSellLot();Lot=LastSellLot*CoefLot;
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"27",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               
              }
           }
        }


     //#Размещение 8-ого buy
      if((CountBuy==7) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level7*k*Point))
           {
           
            Print("Открываем 8-й ордер Buy");
                    SearchLastBuyLot();Lot=LastBuyLot*CoefLot;
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"18",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               
              }
           }
        }


//#Размещение 8-ого sell
      if((CountSell==7) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level7*k*Point))
           {
            
            Print("Открываем 8-й ордер Sell");
            SearchLastSellLot();Lot=LastSellLot*CoefLot;
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"28",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               
              }
           }
        }


//#Размещение 9-ого buy
      if((CountBuy==8) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level8*k*Point))
           {
           
            Print("Открываем 9-й ордер Buy");
                    SearchLastBuyLot();Lot=LastBuyLot*CoefLot;
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"19",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
              
              }
           }
        }


//#Размещение 9-ого sell
      if((CountSell==8) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level8*k*Point))
           {
            
            Print("Открываем 9-й ордер Sell");
            SearchLastSellLot();Lot=LastSellLot*CoefLot;
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"29",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
             
              }
           }
        }

//#Размещение 10-ого buy
      if((CountBuy==9) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level9*k*Point))
           {
            
            Print("Открываем 10-й ордер Buy");
                    SearchLastBuyLot();Lot=LastBuyLot*CoefLot;
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
              
              }
           }
        }


//#Размещение 10-ого sell
      if((CountSell==9) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level9*k*Point))
           {
         
            Print("Открываем 10-й ордер Sell");
            SearchLastSellLot();Lot=LastSellLot*CoefLot;
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"210",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               
              }
           }
        }
 if(!isNewBar())return(0);
  for (int i=OrdersTotal()-1; i>=0; i--)
   {
      if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) break;
            if ((OrderType()==OP_BUYSTOP  )&&(OrderMagicNumber() == Magic_Number ))    if (IsTradeAllowed()) { if (OrderDelete(OrderTicket())<0) 
            { 
        Alert("Ошибка удаления ордера № ", GetLastError()); 
      }  
            }
      if ((OrderType()==OP_SELLSTOP )&&(OrderMagicNumber() == Magic_Number )) if (IsTradeAllowed()){if (OrderDelete(OrderTicket())<0)
           { 
        Alert("Ошибка удаления ордера № ", GetLastError()); 
      } 
      }
         } 
//#Открытие первого ордера buy
   if((CountBuy==0) && (BuyTrade==true)&&((((Open[1]-Close[1])>BodySize*k*Point)&&((High[1]-Low[1])>CandleSize*k*Point))||(SellGoToZero==true)||(CountSell==Lok)))
     {   NoDeleteBuyProfit=false; GoGoBuy=1;ZeroB1=false;ZeroB2=false;
     if(SellGoToZero==true){
        SearchFirstSellOrder();    
          OrderSelect(Ticket, SELECT_BY_TICKET);
            if(OrderComment()==21){ZeroB1=true;GoGoBuy=Buy1; if(OrderLots()==Lot1){Print("Степень lok Buy=0");DeGreeBuy=0;} else {Print("Степень lok Buy=1");DeGreeBuy=1;}}//GoGoBuy=(OrderLots()*(1+(Percent/100)))/Lot1;
            if(OrderComment()==22){ZeroB1=true;GoGoBuy=Buy1; if(OrderLots()==NormalizeDouble(Lot1*CoefLot,2)){Print("Степень lok Buy=0");DeGreeBuy=0;} else {Print("Степень lok Buy=1");DeGreeBuy=1;}} 
            if(OrderComment()==23){ZeroB2=true; GoGoBuy=Buy2;if(OrderLots()==NormalizeDouble(Lot1*CoefLot*CoefLot,2)){Print("Степень lok Buy=0");DeGreeBuy=0;} else {Print("Степень lok Buy=1");DeGreeBuy=1;}}
            if(OrderComment()==24){ZeroB2=true;GoGoBuy=Buy2; if(OrderLots()==NormalizeDouble(Lot1*CoefLot*CoefLot*CoefLot,1)){Print("Степень lok Buy=0");DeGreeBuy=0;} else {Print("Степень lok Buy=1");DeGreeBuy=1;}} 
            if(OrderComment()==25){ZeroB2=true;GoGoBuy=Buy3; if(OrderLots()==NormalizeDouble(Lot1*CoefLot*CoefLot*CoefLot*CoefLot,1)){Print("Степень lok Buy=0");DeGreeBuy=0;} else {Print("Степень lok Buy=1");DeGreeBuy=1;}} 
            if(OrderComment()==26){ZeroB2=true;GoGoBuy=Buy4; if(OrderLots()==NormalizeDouble(Lot1*CoefLot*CoefLot*CoefLot*CoefLot*CoefLot,1)){Print("Степень lok Buy=0");DeGreeBuy=0;} else {Print("Степень lok Buy=1");DeGreeBuy=1;}} 
            
              }    
               
     if(SellGoToZero==false){NoDeleteBuyProfit=true;}
     
     
     
      Print("Размещение первого ордера на покупку ");

      if(IsTradeAllowed()) 
        {
if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYSTOP,Lot1*GoGoBuy,High[1]+filtr*k*Point,3*k,NULL,High[1]+filtr*k*Point+TP*k*Point,"11",Magic_Number,0,Blue) < 0) 
      {Alert("Ошибка открытия позиции № ", GetLastError()); }}
      }
        

     } 
//#Открытие первого ордера sell
   if((CountSell==0) && (SellTrade==true)&&((((Close[1]-Open[1])>BodySize*k*Point)&&((High[1]-Low[1])>CandleSize*k*Point))||(BuyGoToZero==true)||(CountBuy==Lok)))
     {   NoDeleteSellProfit=false;GoGoSell=1;ZeroS1=false;ZeroS2=false;
     if(BuyGoToZero==true){
        SearchFirstBuyOrder();    
          OrderSelect(Ticket, SELECT_BY_TICKET);
            if(OrderComment()==11){ZeroS1=true;GoGoSell=Sell1; if(OrderLots()==Lot1){Print("Степень lok Sell=0");DeGreeSell=0;} else {Print("Степень lok Sell=1");DeGreeSell=1;}}//GoGoBuy=(OrderLots()*(1+(Percent/100)))/Lot1;
            if(OrderComment()==12){ZeroS1=true;GoGoSell=Sell1; if(OrderLots()==NormalizeDouble(Lot1*CoefLot,2)){Print("Степень lok Sell=0");DeGreeSell=0;} else {Print("Степень lok Sell=1");DeGreeSell=1;}} 
            if(OrderComment()==13){ZeroS2=true; GoGoSell=Sell2;   double per=NormalizeDouble(Lot1*CoefLot*CoefLot,2);if(OrderLots()==per){Print("Степень lok Sell=0");DeGreeSell=0;} else {Print("Степень lok Sell=1");DeGreeSell=1;}}
            if(OrderComment()==14){ZeroS2=true;GoGoSell=Sell2; if(NormalizeDouble(OrderLots(),1)==NormalizeDouble(Lot1*CoefLot*CoefLot*CoefLot,1)){Print("Степень lok Sell=0");DeGreeSell=0;} else {Print("Степень lok Sell=1");DeGreeSell=1;}} 
            if(OrderComment()==15){ZeroS2=true;GoGoSell=Sell3; if(NormalizeDouble(OrderLots(),1)==NormalizeDouble(Lot1*CoefLot*CoefLot*CoefLot*CoefLot,1)){Print("Степень lok Sell=0");DeGreeSell=0;} else {Print("Степень lok Sell=1");DeGreeSell=1;}} 
            if(OrderComment()==16){ZeroS2=true;GoGoSell=Sell4; if(NormalizeDouble(OrderLots(),1)==NormalizeDouble(Lot1*CoefLot*CoefLot*CoefLot*CoefLot*CoefLot,1)){Print("Степень lok Sell=0");DeGreeSell=0;} else {Print("Степень lok Sell=1");DeGreeSell=1;}} 
                 }    
               
         if(BuyGoToZero==false){NoDeleteSellProfit=true;}
         
      Print("Размещение первого ордера на продажу");
      if(IsTradeAllowed()) 
        {
         if(OrderSend(Symbol(),OP_SELLSTOP,Lot1*GoGoSell,Low[1]-filtr*k*Point,3*k,NULL,Low[1]-filtr*k*Point-TP*k*Point,"21",Magic_Number,0,Red) < 0)
           {Alert("Произошла ошибка",GetLastError()); }
        }
     }

   return(0);
  }
  
//#пїЅпїЅз°Ѕз°Ѕз№©з№Ўз°· з™Ўз°·з°ѕз“Љз°ѕз’Ѕз°ѕз“Љз°ѕ з°їз°ёз°ѕз№«з™Ўз°·пїЅ з°ѕз°ёз“Јз–‡з°ёз°ѕз’Ѕ з©©пїЅ з°їз°ѕз¤™з±Ђз°їз¤™з±Ђ

//#пїЅпїЅз°Ѕз°Ѕз№©з№Ўз°· з™Ўз°·з°ѕз“Љз°ѕз’Ѕз°ѕз“Љз°ѕ з°їз°ёз°ѕз№«з™Ўз°·пїЅ з°ѕз°ёз“Јз–‡з°ёз°ѕз’Ѕ з©©пїЅ з°їз°ѕз¤™з±Ђз°їз¤™з±Ђ
double CalculateTotalBuyTP()
  {
TPB=0;
   double BuyLots=0;
   double PriceB=0;
   int CountB=0;
   for(int ibuy2Result=0;ibuy2Result<OrdersTotal();ibuy2Result++)
     {
   
      if(OrderSelect(ibuy2Result,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) {PriceB=PriceB+OrderOpenPrice()*OrderLots();BuyLots=BuyLots+OrderLots();CountB=CountB+1;}
        }
     }
   if(CountB>0)
     {
      TPB=PriceB/BuyLots+TP*Point*k;
      for(int ibuy3Result=0;ibuy3Result<OrdersTotal();ibuy3Result++)
        { 
         if(OrderSelect(ibuy3Result,SELECT_BY_POS)==true)
           {
            if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) 
              {
               RefreshRates();
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),TPB,0,Orange); 
              }
           }
        }
     }
   return(TPB);
  }  

double CalculateTotalBuyTPToZero()
  {
TPB=0;
   double BuyLots=0;
   double PriceB=0;
   int CountB=0;
   for(int ibuy2Result=0;ibuy2Result<OrdersTotal();ibuy2Result++)
     {
   
      if(OrderSelect(ibuy2Result,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) {PriceB=PriceB+OrderOpenPrice()*OrderLots();BuyLots=BuyLots+OrderLots();CountB=CountB+1;}
        }
     }
   if(CountB>0)
     {
      TPB=PriceB/BuyLots;
      for(int ibuy3Result=0;ibuy3Result<OrdersTotal();ibuy3Result++)
        { 
         if(OrderSelect(ibuy3Result,SELECT_BY_POS)==true)
           {
            if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) 
              {
               RefreshRates();
                    if ((CountB==1)&&(OrderTakeProfit()!=NULL)){break;}
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),TPB,0,Orange); 
              }
           }
        }
     }
   return(TPB);
  }

  

  
 double CalculateTotalSellTP()
  {
   TPS=0;
   int CountS=0;
   double PriceS=0;
   SellLots=0;
   for(int isell2Result=0;isell2Result<OrdersTotal();isell2Result++)
     {
      // з°ёз–‡з™џз±Ђз¦±зѕ№з°·пїЅз°· з’Ѕзѕ¶зЌєз°ѕз°ёпїЅ з°їз°ёз°ѕз’Ѕз–‡з°ёз¤™з™Ў, з°·пїЅз¤™ з¤™пїЅз¤™ з°ѕз°ёз“Јз–‡з°ё з©«з°ѕз–†з–‡з°· зЌєзѕ¶з°·зѕ№ з™џпїЅз¤™з°ёзѕ¶з°· з™Ўз¦±з™Ў з±Ђз“ЈпїЅз¦±з–‡з©© з’Ѕ зѕёз°·з°ѕ з’Ѕз°ёз–‡з©«и—©!
      if(OrderSelect(isell2Result,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)) {CountS=CountS+1;PriceS=PriceS+OrderOpenPrice()*OrderLots();SellLots=SellLots+OrderLots();}
        }
     }
   if(CountS>0)
     {
      TPS=PriceS/SellLots-TP*Point*k;
      for(int isell4Result=0;isell4Result<OrdersTotal();isell4Result++)
        { 
         if(OrderSelect(isell4Result,SELECT_BY_POS)==true)
           {
            if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)) 
              {
               RefreshRates();
               if ((CountS==1)&&(OrderTakeProfit()!=NULL)){break;}
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),TPS,0,Orange); 
              }
           }
        }
     }
   return(TPS);
  } 


double CalculateTotalSellTPToZero()
  {
   TPS=0;
   int CountS=0;
   double PriceS=0;
   SellLots=0;
   for(int isell2Result=0;isell2Result<OrdersTotal();isell2Result++)
     {
     
      if(OrderSelect(isell2Result,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)) {CountS=CountS+1;PriceS=PriceS+OrderOpenPrice()*OrderLots();SellLots=SellLots+OrderLots();}
        }
     }
   if(CountS>0)
     {
      TPS=PriceS/SellLots;
      for(int isell4Result=0;isell4Result<OrdersTotal();isell4Result++)
        {
         if(OrderSelect(isell4Result,SELECT_BY_POS)==true)
           {
            if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)) 
              {
               RefreshRates();
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),TPS,0,Orange); 
              }
           }
        }
     }
   return(TPS);
  } 
  

double SearchLastBuyPrice()
  {
   LastBuyPrice=0;
   for(int ibuySearch=0;ibuySearch<OrdersTotal();ibuySearch++)
     {
      // з°ёз–‡з™џз±Ђз¦±зѕ№з°·пїЅз°· з’Ѕзѕ¶зЌєз°ѕз°ёпїЅ з°їз°ёз°ѕз’Ѕз–‡з°ёз¤™з™Ў, з°·пїЅз¤™ з¤™пїЅз¤™ з°ѕз°ёз“Јз–‡з°ё з©«з°ѕз–†з–‡з°· зЌєзѕ¶з°·зѕ№ з™џпїЅз¤™з°ёзѕ¶з°· з™Ўз¦±з™Ў з±Ђз“ЈпїЅз¦±з–‡з©© з’Ѕ зѕёз°·з°ѕ з’Ѕз°ёз–‡з©«и—©!
      if(OrderSelect(ibuySearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY))
           {
            if(LastBuyPrice==0){LastBuyPrice=OrderOpenPrice();}
            if(LastBuyPrice>OrderOpenPrice()){LastBuyPrice=OrderOpenPrice();}
           }
        }
     }
   return(LastBuyPrice);
  }
  
  double SearchLastBuyLot()
  {
   LastBuyPrice=0;
   for(int ibuySearch=0;ibuySearch<OrdersTotal();ibuySearch++)
     {
      // з°ёз–‡з™џз±Ђз¦±зѕ№з°·пїЅз°· з’Ѕзѕ¶зЌєз°ѕз°ёпїЅ з°їз°ёз°ѕз’Ѕз–‡з°ёз¤™з™Ў, з°·пїЅз¤™ з¤™пїЅз¤™ з°ѕз°ёз“Јз–‡з°ё з©«з°ѕз–†з–‡з°· зЌєзѕ¶з°·зѕ№ з™џпїЅз¤™з°ёзѕ¶з°· з™Ўз¦±з™Ў з±Ђз“ЈпїЅз¦±з–‡з©© з’Ѕ зѕёз°·з°ѕ з’Ѕз°ёз–‡з©«и—©!
      if(OrderSelect(ibuySearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY))
           {
            if(LastBuyPrice==0){LastBuyPrice=OrderOpenPrice();LastBuyLot=OrderLots();}
            if(LastBuyPrice>OrderOpenPrice()){LastBuyPrice=OrderOpenPrice();LastBuyLot=OrderLots();}
           }
        }
     }
   return(LastBuyLot);
  }
  
  
  
  

double SearchLastSellPrice()
  {
   LastSellPrice=0;
   for(int isellSearch=0;isellSearch<OrdersTotal();isellSearch++)
     {
      if(OrderSelect(isellSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL))
           {
            if(LastSellPrice==0){LastSellPrice=OrderOpenPrice();}
            if(LastSellPrice<OrderOpenPrice()){LastSellPrice=OrderOpenPrice();}
           }
        }
     }
   return(LastSellPrice);
  }

double SearchLastSellLot()
  {
   LastSellPrice=0;
   for(int isellSearch=0;isellSearch<OrdersTotal();isellSearch++)
     {
      if(OrderSelect(isellSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL))
           {
            if(LastSellPrice==0){LastSellPrice=OrderOpenPrice();LastSellLot=OrderLots();}
            if(LastSellPrice<OrderOpenPrice()){LastSellPrice=OrderOpenPrice();LastSellLot=OrderLots();}
           }
        }
     }
   return(LastSellLot);
  }


double SearchLastLimBuyPrice()
  {
   LastBuyPrice=0;
   for(int ibuySearch1=0;ibuySearch1<OrdersTotal();ibuySearch1++)
     {
      // з°ёз–‡з™џз±Ђз¦±зѕ№з°·пїЅз°· з’Ѕзѕ¶зЌєз°ѕз°ёпїЅ з°їз°ёз°ѕз’Ѕз–‡з°ёз¤™з™Ў, з°·пїЅз¤™ з¤™пїЅз¤™ з°ѕз°ёз“Јз–‡з°ё з©«з°ѕз–†з–‡з°· зЌєзѕ¶з°·зѕ№ з™џпїЅз¤™з°ёзѕ¶з°· з™Ўз¦±з™Ў з±Ђз“ЈпїЅз¦±з–‡з©© з’Ѕ зѕёз°·з°ѕ з’Ѕз°ёз–‡з©«и—©!
      if(OrderSelect(ibuySearch1,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUYLIMIT))
           {
            if(LastBuyPrice==0){LastBuyPrice=OrderOpenPrice();}
            if(LastBuyPrice>OrderOpenPrice()){LastBuyPrice=OrderOpenPrice();}
           }
        }
     }
   return(LastBuyPrice);
  }
//#пїЅз°ѕз™Ўз°Ѕз¤™ з°їз°ѕз°Ѕз¦±з–‡з“Јз©©з–‡з“Љз°ѕ з¦±з™Ўз©«з™Ўз°·з©©з°ѕз“Љз°ѕ з°ѕз°ёз“Јз–‡з°ёпїЅ з©©пїЅ з°їз°ёз°ѕз“ЈпїЅз–†з±Ђ
double SearchLastLimSellPrice()
  {
   LastSellPrice=0;
   
   for(int isellSearch1=0;isellSearch1<OrdersTotal();isellSearch1++)
     {
      // з°ёз–‡з™џз±Ђз¦±зѕ№з°·пїЅз°· з’Ѕзѕ¶зЌєз°ѕз°ёпїЅ з°їз°ёз°ѕз’Ѕз–‡з°ёз¤™з™Ў, з°·пїЅз¤™ з¤™пїЅз¤™ з°ѕз°ёз“Јз–‡з°ё з©«з°ѕз–†з–‡з°· зЌєзѕ¶з°·зѕ№ з™џпїЅз¤™з°ёзѕ¶з°· з™Ўз¦±з™Ў з±Ђз“ЈпїЅз¦±з–‡з©© з’Ѕ зѕёз°·з°ѕ з’Ѕз°ёз–‡з©«и—©!
      if(OrderSelect(isellSearch1,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELLLIMIT))
           {
            if(LastSellPrice==0){LastSellPrice=OrderOpenPrice();}
            if(LastSellPrice<OrderOpenPrice()){LastSellPrice=OrderOpenPrice();}
           }
        }
     }
   return(LastSellPrice);
  }
  double SearchFirstBuyOrder() {
   Ticket=0;
   FirstBuyPrice=0;
   for(int iFBSearch=0;iFBSearch<OrdersTotal();iFBSearch++)
     {
      if(OrderSelect(iFBSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (Magic_Number==OrderMagicNumber()))
           {
            if(FirstBuyPrice==0){FirstBuyPrice=OrderOpenPrice();Ticket=OrderTicket();}
            if(FirstBuyPrice<OrderOpenPrice()){FirstBuyPrice=OrderOpenPrice();Ticket=OrderTicket();}
           }
        }
     }
   return(Ticket);
  }
    double SearchSecondBuyOrder() {
  
   double SecondBuyPrice=0;
   SearchFirstBuyOrder();
   OrderSelect(Ticket, SELECT_BY_TICKET); 
   FirstBuyPrice=OrderOpenPrice();
   for(int iFBSearch=0;iFBSearch<OrdersTotal();iFBSearch++)
     {
      if(OrderSelect(iFBSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (Magic_Number==OrderMagicNumber()))
           {
            if((FirstBuyPrice>OrderOpenPrice())&&((SecondBuyPrice<OrderOpenPrice())||(SecondBuyPrice==0))){SecondBuyPrice=OrderOpenPrice();Ticket2=OrderTicket();}
     
           }
        }
     }
   return(Ticket2);
  }
    double SearchFirstSellOrder() {
   Ticket=0;
   FirstSellPrice=0;
   for(int iFSSearch=0;iFSSearch<OrdersTotal();iFSSearch++)
     {
      if(OrderSelect(iFSSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)&& (Magic_Number==OrderMagicNumber()))
           {
            if(FirstSellPrice==0){FirstSellPrice=OrderOpenPrice();Ticket=OrderTicket();}
            if(FirstSellPrice>OrderOpenPrice()){FirstSellPrice=OrderOpenPrice();Ticket=OrderTicket();}
           }
        }
     }
   
   return(Ticket);
  }
  
double SearchSecondSellOrder() {
  
   double SecondSellPrice=0;
   SearchFirstSellOrder();
   OrderSelect(Ticket, SELECT_BY_TICKET); 
   FirstSellPrice=OrderOpenPrice();
   for(int iFBSearch=0;iFBSearch<OrdersTotal();iFBSearch++)
     {
      if(OrderSelect(iFBSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)&& (Magic_Number==OrderMagicNumber()))
           {
            if((FirstSellPrice<OrderOpenPrice())&&((SecondSellPrice>OrderOpenPrice())||(SecondSellPrice==0))){SecondSellPrice=OrderOpenPrice();Ticket2=OrderTicket();}
     
           }
        }
     }
   return(Ticket2);
  }
  
  
  
  double SearchLokBuyOrdersProfit() {
  BuyOrdersProfit=0;
  for(int iFBBSearch=0;iFBBSearch<OrdersTotal();iFBBSearch++)
     {
      if(OrderSelect(iFBBSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (Magic_Number==OrderMagicNumber()))
           {
           BuyOrdersProfit=BuyOrdersProfit+OrderProfit();
           }
           }
        }
      return(BuyOrdersProfit);
  }
  
   double SearchLokSellOrdersProfit() {
  SellOrdersProfit=0;
  for(int iFBBSearch=0;iFBBSearch<OrdersTotal();iFBBSearch++)
     {
      if(OrderSelect(iFBBSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)&& (Magic_Number==OrderMagicNumber()))
           {
           SellOrdersProfit=SellOrdersProfit+OrderProfit();
           }
           }
        }
    
      return(SellOrdersProfit);
  } 
 double CloseFirstBuySellOrders()
  {
   SearchFirstBuyOrder();
         OrderSelect(Ticket, SELECT_BY_TICKET);   OrderClose(Ticket,OrderLots(),Bid,3*k,Black);
       
     for(int S=OrdersTotal();S>0;S--)
     {
    if(OrderSelect(S,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (Magic_Number==OrderMagicNumber())&&(OrderType()==OP_SELL))
           {
           OrderClose(OrderTicket(),OrderLots(),Ask,3*k,Black);
             
           }
        }
        }
        CalculateTotalBuyTP();
      return(0);
  } 
  
   double CloseMidFirstBuySellOrders()
  {
   SearchFirstBuyOrder();
         OrderSelect(Ticket, SELECT_BY_TICKET); double j=OrderLots()/2;  OrderClose(Ticket,j,Bid,3*k,Black);
       
     for(int S=OrdersTotal();S>0;S--)
     {
    if(OrderSelect(S,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (Magic_Number==OrderMagicNumber())&&(OrderType()==OP_SELL))
           {
           OrderClose(OrderTicket(),OrderLots(),Ask,3*k,Black);
             
           }
        }
        }
        CalculateTotalBuyTP();
      return(0);
  } 
 double CloseFirstSecondBuySellOrders()
  {
         SearchFirstBuyOrder();
         OrderSelect(Ticket, SELECT_BY_TICKET);   
         OrderClose(Ticket,OrderLots(),Bid,3*k,Black);
         SearchSecondBuyOrder();
         OrderSelect(Ticket, SELECT_BY_TICKET);   
         OrderClose(Ticket,OrderLots(),Bid,3*k,Black);     
     for(int S=OrdersTotal();S>0;S--)
     {
    if(OrderSelect(S,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (Magic_Number==OrderMagicNumber())&&(OrderType()==OP_SELL))
           {
           OrderClose(OrderTicket(),OrderLots(),Ask,3*k,Black);
             
           }
        }
        }
        CalculateTotalBuyTP();
      return(0);
  } 

   double CloseFirstSellBuyOrders()
  {
        SearchFirstSellOrder();
      OrderSelect(Ticket, SELECT_BY_TICKET); 
      OrderClose(Ticket,OrderLots(),Ask,3*k,Black);
    for(int SS=OrdersTotal();SS>0;SS--)
     {
      if(OrderSelect(SS,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (Magic_Number==OrderMagicNumber()))
           {
        OrderClose(OrderTicket(),OrderLots(),Bid,3*k,Black);
           }
        }
        }

      CalculateTotalSellTP();
      return(0);
  } 
     double CloseMidFirstSellBuyOrders()
  {
        SearchFirstSellOrder();
      OrderSelect(Ticket, SELECT_BY_TICKET); double t=OrderLots()/2;
      OrderClose(Ticket,t,Ask,3*k,Black);
    for(int SS=OrdersTotal();SS>0;SS--)
     {
      if(OrderSelect(SS,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (Magic_Number==OrderMagicNumber()))
           {
        OrderClose(OrderTicket(),OrderLots(),Bid,3*k,Black);
           }
        }
        }

      CalculateTotalSellTP();
      return(0);
  } 
   double CloseFirstSecondSellBuyOrders()
  {
        SearchFirstSellOrder();
      OrderSelect(Ticket, SELECT_BY_TICKET); 
      OrderClose(Ticket,OrderLots(),Ask,3*k,Black);
        SearchSecondSellOrder();
      OrderSelect(Ticket2, SELECT_BY_TICKET); 
      OrderClose(Ticket2,OrderLots(),Ask,3*k,Black);
    for(int SS=OrdersTotal();SS>0;SS--)
     {
      if(OrderSelect(SS,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (Magic_Number==OrderMagicNumber()))
           {
        OrderClose(OrderTicket(),OrderLots(),Bid,3*k,Black);
           }
        }
        }

      CalculateTotalSellTP();
      return(0);
  } 
  
  
  double BuySTOPDel()
{for (int iDel1=OrdersTotal()-1; iDel1>=0; iDel1--)
   {
      if (!OrderSelect(iDel1,SELECT_BY_POS,MODE_TRADES)) break;
            if ((OrderType()==OP_BUYSTOP)&&(OrderMagicNumber() == Magic_Number ))    if (IsTradeAllowed()) { if (OrderDelete(OrderTicket())<0) 
            { 
        Alert("Ошибка удаления ордера № ", GetLastError()); 
      }  
            }
} return(0);}

double SellSTOPDel()
{for (int iDel2=OrdersTotal()-1; iDel2>=0; iDel2--)
   {
      if (!OrderSelect(iDel2,SELECT_BY_POS,MODE_TRADES)) break;
            if ((OrderType()==OP_SELLSTOP)&&(OrderMagicNumber() == Magic_Number ))    if (IsTradeAllowed()) { if (OrderDelete(OrderTicket())<0) 
            { 
        Alert("Ошибка удаления ордера № ", GetLastError()); 
      }  
            }
} return(0);}


    double DeleteBuyTakeProfit() {

   for(int ibb=0;ibb<OrdersTotal();ibb++)
     {
      if(OrderSelect(ibb,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (OrderTakeProfit()!=NULL)&& (Magic_Number==OrderMagicNumber()))
           {
          Print("Удаляем профит первого ордера");   OrderModify(OrderTicket(),OrderOpenPrice(),NULL,NULL,0,Orange); 
           }
        }
     }
   
   return(0);
  }

    double DeleteSellTakeProfit() {

   for(int iss=0;iss<OrdersTotal();iss++)
     {
      if(OrderSelect(iss,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)&& (OrderTakeProfit()!=NULL)&& (Magic_Number==OrderMagicNumber()))
           {
            Print("Удаляем профит первого ордера");   OrderModify(OrderTicket(),OrderOpenPrice(),NULL,NULL,0,Orange); 
           }
        }
     }
   
   return(0);
  }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isNewBar()
  {
   static datetime BarTime;
   bool res=false;

   if(BarTime!=Time[0])
     {
      BarTime=Time[0];
      res=true;
     }
   return(res);
  }
//---- пїЅз°ѕз™џз’Ѕз°ёпїЅзѕ…пїЅз–‡з°· з¤™з°ѕз¦±з™Ўз№©з–‡з°Ѕз°·з’Ѕз°ѕ з°ѕз°ёз“Јз–‡з°ёз°ѕз’Ѕ з±Ђз¤™пїЅз™џпїЅз©©з©©з°ѕз“Љз°ѕ з°·з™Ўз°їпїЅ з°ѕз°ёз“Јз–‡з°ёз°ѕз’Ѕ ----//
int Orders_Total_by_type(int type,int mn,string sym)
  {
   int num_orders=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber()==mn && type==OrderType() && sym==OrderSymbol())
         num_orders++;
     }
   return(num_orders);
  }
//+------------------------------------------------------------------+
