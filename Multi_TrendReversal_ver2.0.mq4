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
extern string Пapаметры="Настройки советника";
extern int LotsBuy=8;
extern int LotsSell=8;
extern string Пapаметры1="Параметры ордеров";
extern bool BuyTrade=true;
extern bool SellTrade=true;
extern int TP=10;
extern int Magic_Number=3213;
extern string Пapаметры2="Уровни открытия ордеров Buy/Sell";
extern double Level1=100;
extern double Level2=150;
extern double Level3=200;
extern double Level4=250;
extern double Level5=300;
extern double Level6=350;
extern double Level7=400;
extern double Level8=450;
extern double Level9=500;
extern double Level10=550;
extern double Level11=600;
extern double Level12=700;
extern double Level13=800;
extern double Level14=850;
extern double Level15=900;
extern double Level16=1000;
extern double Level17=1100;
extern double Level18=1200;
extern double Level19=1300;
extern double Level20=1400;
extern string Пapаметры5="Лоты ордеров Buy/Sell";
extern double Lot1=0.1;
extern double Lot2=0.2;
extern double Lot3=0.4;
extern double Lot4=0.6;
extern double Lot5=0.8;
extern double Lot6=1;
extern double Lot7=1.2;
extern double Lot8=1.4;
extern double Lot9=1.6;
extern double Lot10=1.8;
extern double Lot11=2;
extern double Lot12=2.2;
extern double Lot13=2.4;
extern double Lot14=2.6;
extern double Lot15=3;
extern double Lot16=3.2;
extern double Lot17=3.4;
extern double Lot18=3.6;
extern double Lot19=3.8;
extern double Lot20=4;



int k;
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
int NumSLimOrders;
int NumBLimOrders;
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
   if(IsDemo()==false) 
     {
      Alert("Неверный счет!");
      Sleep(6000);return(0);
     }
//Проверка изменений в советнике   
   ReCountBuy=0;ReCountSell=0;ReBuyLots=0;ReSellLots=0;
   for(int in=0;in<OrdersTotal();in++)
     {      if(OrderSelect(in,SELECT_BY_POS)==true)
        {
         if(OrderSymbol()==Symbol()) 
           {
            if(OrderType()==OP_BUY){ReCountBuy=ReCountBuy+1;ReBuyLots=ReBuyLots+OrderLots();}
            if(OrderType()==OP_SELL){ReCountSell=ReCountSell+1;ReSellLots=ReSellLots+OrderLots();}
           }
        }
     }

  

if((CountBuy!=0)&& ((ReBuyLots<BuyLots) || (ReBuyLots>BuyLots))){CalculateTotalBuyTP();}

   if((CountSell!=0)&& ((ReSellLots<SellLots) || (ReSellLots>SellLots))){CalculateTotalSellTP();}
   
   
 
   CountBuy=0;CountSell=0;TotalSlt=0;TotalBLt=0;OrderSwaps=0;total=OrdersTotal();LastBuyPrice=0;LastSellPrice=0;BuyLots=0;SellLots=0;
   for(int i=0;i<total;i++)
     {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
      if(OrderSelect(i,SELECT_BY_POS)==true)
        {
         if(OrderSymbol()==Symbol()) 
           {
            if(OrderType()==OP_BUY){CountBuy=CountBuy+1;TotalBLt=TotalBLt+OrderLots();BuyLots=BuyLots+OrderLots();}
            if(OrderType()==OP_SELL){CountSell=CountSell+1;TotalSlt=TotalSlt+OrderLots();SellLots=SellLots+OrderLots();}
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
               Alert("Ошибка удаления ордера № ",GetLastError());
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
               Alert("Ошибка удаления ордера № ",GetLastError());
              }
           }
        }
     }
//#Поиск общего TP для BUY
   if((CountBuy!=0) && (CountBuy!=1))
     {
      double BuyOrderTP=0;
      bool CalculateNow=false;
      for(int iss=0;iss<OrdersTotal();iss++)
        {
         // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
         if(OrderSelect(iss,SELECT_BY_POS)==true)
           {
            if(OrderSymbol()==Symbol()) 
              {
               if(OrderType()==OP_BUY)
                 {
                  if(BuyOrderTP==0){BuyOrderTP=OrderTakeProfit();}if(BuyOrderTP!=OrderTakeProfit()){CalculateNow=true;}
                 }
              }
           }
        }
      if(CalculateNow==true){CalculateTotalBuyTP();}
     }
//#Поиск общего TP для SELL
   if((CountSell!=0) && (CountSell!=1))
     {
      double SellOrderTP=0;
      bool CalculateNow=false;
      for(int is=0;is<OrdersTotal();is++)
        {
         // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
         if(OrderSelect(is,SELECT_BY_POS)==true)
           {
            if(OrderSymbol()==Symbol()) 
              {
               if(OrderType()==OP_SELL)
                 {
                  if(SellOrderTP==0){SellOrderTP=OrderTakeProfit();}if(SellOrderTP!=OrderTakeProfit()){CalculateNow=true;}
                 }
              }
           }
        }

      if(CalculateNow==true){CalculateTotalSellTP();}
     }
//#Первый ордер buy
   if((CountBuy==0) && (BuyTrade==true))
     {
      Print("Открытие первого ордера на покупку");
      if(IsTradeAllowed()) 
        {
         if(OrderSend(Symbol(),OP_BUY,Lot1,Ask,3*k,NULL,Ask+TP*Point*k,"Sun-Lot1-buy(1)",Magic_Number,0,Blue)<0)
           {Alert("Ошибка открытия позиции № ",GetLastError()); }
        }

     }
//#Первый ордер sell
   if((CountSell==0) && (SellTrade==true))
     {
      Print("Открытие первого ордера на продажу");
      if(IsTradeAllowed()) 
        {
         if(OrderSend(Symbol(),OP_SELL,Lot1,Bid,3*k,NULL,Bid-TP*Point*k,"Sun-Lot1-sell(1)",Magic_Number,0,Red)<0)
           {Alert("Ошибка открытия позиции № ",GetLastError()); }
        }
     }

     
      //#Второй ордер buy
      if((CountBuy==1) && (BuyTrade==true))
        {
         for(int ibuy=0;ibuy<OrdersTotal();ibuy++)
           {
            // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
            if(OrderSelect(ibuy,SELECT_BY_POS)==true)
              {
               if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) 
                 {
                  LastBuyPrice=OrderOpenPrice();
                 }
              }
           }
         if(Ask<(LastBuyPrice-Level1*k*Point))
           {
            
            Print("Открытие второго ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot2,Ask,3*k,NULL,NULL,"Sun-Lot2-buy(2)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }


      //#Второй ордер sell
      if((CountSell==1) && (SellTrade==true))
        {
         for(int isell=0;isell<OrdersTotal();isell++)
           {
            // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
            if(OrderSelect(isell,SELECT_BY_POS)==true)
              {
               if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL))
                 {LastSellPrice=OrderOpenPrice();}
              }
           }
         if(Bid>(LastSellPrice+Level1*k*Point))
           {
            CalculateSellTP();
            Print("Открытие второго ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot2,Ask,3*k,NULL,NULL,"Sun-Lot2-sell(2)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
             
              }
           }
        }


      //#Третий ордер buy
      if((CountBuy==2) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level2*k*Point))
           {
        
            Print("Открытие третьего ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot3,Ask,3*k,NULL,NULL,"Sun-Lot3-buy(3)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }


      //Третий ордер sell
      if((CountSell==2) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level2*k*Point))
           {
         
            Print("Открытие третьего ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot3,Ask,3*k,NULL,NULL,"Sun-Lot3-sell(3)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
              
              }
           }
        }

      //#Четвертый ордер buy
      if((CountBuy==3) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level3*k*Point))
           {
           
            Print("Открытие четвертого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot4,Ask,3*k,NULL,NULL,"Sun-Lot4-buy(4)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }

              }
           }
        }


      //#Четвертый ордер sell
      if((CountSell==3) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level3*k*Point))
           {
            
            Print("Открытие четвертого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot4,Ask,3*k,NULL,NULL,"Sun-Lot4-sell(4)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
            
              }
           }
        }


      //#Пятый ордер buy
      if((CountBuy==4) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level4*k*Point))
           {
            
            Print("Открытие пятого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot5,Ask,3*k,NULL,NULL,"Sun-Lot5-buy(5)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
           
              }
           }
        }


      //#Пятый ордер sell
      if((CountSell==4) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level4*k*Point))
           {
         ;
            Print("Открытие пятого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot5,Ask,3*k,NULL,NULL,"Sun-Lot5-sell(5)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
           
              }
           }
        }

      //#Шестой ордер buy
      if((CountBuy==5) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level5*k*Point))
           {
        
            Print("Открытие шестого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot6,Ask,3*k,NULL,NULL,"Sun-Lot6-buy(6)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
              
              }
           }
        }


      //#Шестой ордер sell
      if((CountSell==5) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level5*k*Point))
           {
            
            Print("Открытие шестого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot6,Ask,3*k,NULL,NULL,"Sun-Lot6-sell(6)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }
      //#Седьмой ордер buy
      if((CountBuy==6) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level6*k*Point))
           {
          
            Print("Открытие седьмого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot7,Ask,3*k,NULL,NULL,"Sun-Lot7-buy(7)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
              
              }
           }
        }


      //#Седьмой ордер sell
      if((CountSell==6) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level6*k*Point))
           {
           
            Print("Открытие седьмого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot7,Ask,3*k,NULL,NULL,"Sun-Lot7-sell(7)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }


      //#Восьмой ордер buy
      if((CountBuy==7) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level7*k*Point))
           {
           
            Print("Открытие восьмого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot8,Ask,3*k,NULL,NULL,"Sun-Lot8-buy(8)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }


      //#Восьмой ордер sell
      if((CountSell==7) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level7*k*Point))
           {
            
            Print("Открытие восьмого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot8,Ask,3*k,NULL,NULL,"Sun-Lot8-sell(8)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }


      //#Девятый ордер buy
      if((CountBuy==8) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level8*k*Point))
           {
           
            Print("Открытие девятого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot9,Ask,3*k,NULL,NULL,"Sun-Lot9-buy(9)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
              
              }
           }
        }


      //#Девятый ордер sell
      if((CountSell==8) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level8*k*Point))
           {
            
            Print("Открытие девятого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot9,Ask,3*k,NULL,NULL,"Sun-Lot9-sell(9)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
             
              }
           }
        }

      //#Десятый ордер buy
      if((CountBuy==9) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level9*k*Point))
           {
            
            Print("Открытие десятого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot10,Ask,3*k,NULL,NULL,"Sun-Lot10-buy(10)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
              
              }
           }
        }


      //#Десятый ордер sell
      if((CountSell==9) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level9*k*Point))
           {
         
            Print("Открытие десятого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot10,Ask,3*k,NULL,NULL,"Sun-Lot10-sell(10)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }


      //#Одиннадцатый ордер buy
      if((CountBuy==10) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level10*k*Point))
           {
            
            Print("Открытие одиннадцатого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot11,Ask,3*k,NULL,NULL,"Sun-Lot11-buy(11)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
              
              }
           }
        }


      //#Одиннадцатый ордер sell
      if((CountSell==10) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level10*k*Point))
           {
            
            Print("Открытие одиннадцатого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot11,Ask,3*k,NULL,NULL,"Sun-Lot11-sell(11)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }

      //#Двенадцатый ордер buy
      if((CountBuy==11) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level11*k*Point))
           {
            
            Print("Открытие двенадцатого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot12,Ask,3*k,NULL,NULL,"Sun-Lot12-buy(12)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }


      //#Двенадцатый ордер sell
      if((CountSell==11) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level11*k*Point))
           {
            
            Print("Открытие двенадцатого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot12,Ask,3*k,NULL,NULL,"Sun-Lot12-sell(12)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }

      //#Тринадцатый ордер buy
      if((CountBuy==12) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level12*k*Point))
           {
          
            Print("Открытие тринадцатого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot13,Ask,3*k,NULL,NULL,"Sun-Lot13-buy(13)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }


      //#Тринадцатый ордер sell
      if((CountSell==12) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level12*k*Point))
           {
            
            Print("Открытие тринадцатого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot13,Ask,3*k,NULL,NULL,"Sun-Lot13-sell(13)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
              
              }
           }
        }


      //#Четырнадцатый ордер buy
      if((CountBuy==13) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level13*k*Point))
           {
           
            Print("Открытие четырнадцатого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot14,Ask,3*k,NULL,NULL,"Sun-Lot14-buy(14)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }


      //#Четырнадцатый ордер sell
      if((CountSell==13) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level13*k*Point))
           {
           
            Print("Открытие четырнадцатого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot14,Ask,3*k,NULL,NULL,"Sun-Lot14-sell(14)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }

      //#Пятнадцатый ордер buy
      if((CountBuy==14) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level14*k*Point))
           {
            
            Print("Открытие пятнадцатого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot15,Ask,3*k,NULL,NULL,"Sun-Lot15-buy(15)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
             
              }
           }
        }


      //#Пятнадцатый ордер sell
      if((CountSell==14) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level14*k*Point))
           {
            CalculateSellTP();
            Print("Открытие пятнадцатого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot15,Ask,3*k,NULL,NULL,"Sun-Lot15-sell(15)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }

      //#Шестнадцатый ордер buy
      if((CountBuy==15) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level15*k*Point))
           {
          
            Print("Открытие шестнадцатого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot16,Ask,3*k,NULL,NULL,"Sun-Lot16-buy(16)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }


      //#Шестнадцатый ордер sell
      if((CountSell==15) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level15*k*Point))
           {
            
            Print("Открытие шестнадцатого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot16,Ask,3*k,NULL,NULL,"Sun-Lot16-sell(16)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }
      //#Семнадцатый ордер buy
      if((CountBuy==16) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level16*k*Point))
           {
            
            Print("Открытие семнадцатого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot17,Ask,3*k,NULL,NULL,"Sun-Lot17-buy(17)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }


      //#Семнадцатый ордер sell
      if((CountSell==16) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level16*k*Point))
           {
            
            Print("Открытие семнадцатого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot17,Ask,3*k,NULL,NULL,"Sun-Lot17-sell(17)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
              
              }
           }
        }
      //#Восемнадцатый ордер buy
      if((CountBuy==17) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level17*k*Point))
           {
            
            Print("Открытие восемнадцатого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot18,Ask,3*k,NULL,NULL,"Sun-Lot18-buy(18)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }


      //#Восемнадцатый ордер sell
      if((CountSell==17) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level17*k*Point))
           {
            
            Print("Открытие восемнадцатого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot18,Ask,3*k,NULL,NULL,"Sun-Lot18-sell(18)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }
      //#Девятнадцатый ордер buy
      if((CountBuy==18) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level18*k*Point))
           {
            
            Print("Открытие девятнадцатого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot19,Ask,3*k,NULL,NULL,"Sun-Lot19-buy(19)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }


      //#Девятнадцатый ордер sell
      if((CountSell==18) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level18*k*Point))
           {
            
            Print("Открытие девятнадцатого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot19,Ask,3*k,NULL,NULL,"Sun-Lot19-sell(19)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }
      //#Двадцатый ордер buy
      if((CountBuy==19) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level19*k*Point))
           {
            
            Print("Открытие двадцатого ордера на покупку");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot20,Ask,3*k,NULL,NULL,"Sun-Lot20-buy(20)",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }


      //#Двадцатый ордер sell
      if((CountSell==19) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level19*k*Point))
           {
      
            Print("Открытие двадцатого ордера на продажу");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot20,Ask,3*k,NULL,NULL,"Sun-Lot20-sell(20)",Magic_Number,0,Red)<0)
                 {Alert("Ошибка открытия позиции № ",GetLastError()); }
               
              }
           }
        }




        



   return(0);
  }
//#Рассчёт итогового профита ордеров на покупку
double CalculateBuyTP()
  {
   RefreshRates();
   TPB=0;
   int CountB=1;
   double PriceB=Ask;
   for(int ibuyResult=0;ibuyResult<OrdersTotal();ibuyResult++)
     {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
      if(OrderSelect(ibuyResult,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) {PriceB=PriceB+OrderOpenPrice();CountB=CountB+1;}
        }
     }
   TPB=PriceB/CountB+TP*Point*k;
   return(TPB);
  }
//#Рассчёт итогового профита ордеров на покупку
double CalculateTotalBuyTP()
  {
TPB=0;
   double BuyLots=0;
   double PriceB=0;
   int CountB=0;
   for(int ibuy2Result=0;ibuy2Result<OrdersTotal();ibuy2Result++)
     {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
      if(OrderSelect(ibuy2Result,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) {PriceB=PriceB+OrderOpenPrice()*OrderLots();BuyLots=BuyLots+OrderLots();CountB=CountB+1;}
        }
     }
   if(CountB>1)
     {
      TPB=PriceB/BuyLots+TP*Point*k;
      for(int ibuy3Result=0;ibuy3Result<OrdersTotal();ibuy3Result++)
        { // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
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
  

//#Рассчёт итогового профита ордеров на продажу
double CalculateSellTP()
  {
   TPS=0;
   int CountS=1;
   double PriceS=Bid;
   for(int isellResult=0;isellResult<OrdersTotal();isellResult++)
     {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
      if(OrderSelect(isellResult,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)) {PriceS=PriceS+OrderOpenPrice();CountS=CountS+1;}
        }
     }
   if(CountS!=0)
     {
      TPS=PriceS/CountS-TP*Point*k; 
     }
   return(TPS);
  }
  
 double CalculateTotalSellTP()
  {
   TPS=0;
   int CountS=0;
   double PriceS=0;
   for(int isell2Result=0;isell2Result<OrdersTotal();isell2Result++)
     {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
      if(OrderSelect(isell2Result,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)) {CountS=CountS+1;PriceS=PriceS+OrderOpenPrice()*OrderLots();SellLots=SellLots+OrderLots();}
        }
     }
   if(CountS>1)
     {
      TPS=PriceS/SellLots-TP*Point*k;
      for(int isell4Result=0;isell4Result<OrdersTotal();isell4Result++)
        { // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
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

  
//#Поиск последнего ордера на покупку
double SearchLastBuyPrice()
  {
   LastBuyPrice=0;
   for(int ibuySearch=0;ibuySearch<OrdersTotal();ibuySearch++)
     {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
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
//#Поиск последнего ордера на продажу
double SearchLastSellPrice()
  {
   LastSellPrice=0;
   for(int isellSearch=0;isellSearch<OrdersTotal();isellSearch++)
     {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
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
//#Поиск последнего лимитного ордера на покупку
double SearchLastLimBuyPrice()
  {
   LastBuyPrice=0;
   for(int ibuySearch1=0;ibuySearch1<OrdersTotal();ibuySearch1++)
     {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
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
//#Поиск последнего лимитного ордера на продажу
double SearchLastLimSellPrice()
  {
   LastSellPrice=0;
   
   for(int isellSearch1=0;isellSearch1<OrdersTotal();isellSearch1++)
     {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
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
//---- Возвращает количество ордеров указанного типа ордеров ----//
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
