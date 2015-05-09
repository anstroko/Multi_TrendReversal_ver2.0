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
extern int TP2=1;
extern double Lot2=3;
extern double BonusDollar=1;
extern int Magic_Number=321;
extern double kLevel=2;
extern double Percent=25;


extern int Lok=3;
extern int SleepingTime=3;
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
extern double CoefLot2=1.6;
extern int Spread=3;

int ss;
int bb; 
double TP1;
bool BuyLok;
bool SellLok;
bool BuyLok2;
bool SellLok2;
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

double TotalProfit;
string BComment;
string SComment;
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
   
ObjectCreate("label_object3",OBJ_LABEL,0,0,0);
ObjectSet("label_object3",OBJPROP_CORNER,4);
ObjectSet("label_object3",OBJPROP_XDISTANCE,10);
ObjectSet("label_object3",OBJPROP_YDISTANCE,50);
ObjectSetText("label_object3","Текущая просадка="+DoubleToStr(TotalProfit,2),12,"Arial",Red);
      

   
     SearchLokSellOrdersProfit();  SearchLokBuyOrdersProfit();
    TotalProfit=SellOrdersProfit+BuyOrdersProfit;
   
   ReCountBuy=0;ReCountSell=0;ReBuyLots=0;ReSellLots=0;bb=0;ss=0;BuyLok=false;SellLok=false;BuyLok2=false;SellLok2=false;
   for(int in=0;in<OrdersTotal();in++)
     {      if(OrderSelect(in,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number) )
           {
            if(OrderType()==OP_BUY){ReCountBuy=ReCountBuy+1;ReBuyLots=ReBuyLots+OrderLots(); }
            if(OrderType()==OP_SELL){ReCountSell=ReCountSell+1;ReSellLots=ReSellLots+OrderLots();}
            if (OrderComment()=="BuyLok"){BuyLok=true;}
               if (OrderComment()=="SellLok"){SellLok=true;}
                 if ((OrderComment()=="BuyLok2")&&(OrderType()==OP_BUY)){BuyLok2=true;}
                   if ((OrderComment()=="SellLok2")&&(OrderType()==OP_SELL)){SellLok2=true;}
           }
        }
     }
  if   (ReCountBuy==0) {BuyGoToZero=false;} 
  if   (ReCountSell==0) {SellGoToZero=false;}     
  
  
    

 if(BuyGoToZero==false){if(ReCountBuy>=OrdersToZero){BuyGoToZero=true;}}
 if(SellGoToZero==false){if(ReCountSell>=OrdersToZero){SellGoToZero=true;}}
 
if (((BuyGoToZero==true)||(SellGoToZero==true))&&(TotalProfit>0)&&(ReCountSell!=0)&&(ReCountBuy!=0)){Print("Закрываем все ордера");CloseAllOrders();BuyLok=false;SellLok=false;}

if ((BuyGoToZero==true)&&(ReCountSell==1)&&(CountSell==0)&&(NoDeleteSellProfit==false)){DeleteSellTakeProfit();  }
if ((SellGoToZero==true)&&(ReCountBuy==1)&&(CountBuy==0)&&(NoDeleteBuyProfit==false)){DeleteBuyTakeProfit();}


if ((OnlyToZeroBuy==true)&&(ReCountBuy==0)&&(CountBuy!=0)){Print("Закрылись в 0, дальше работаем с ТР");OnlyToZeroBuy=false;}
if ((OnlyToZeroSell==true)&&(ReCountSell==0)&&(CountSell!=0)){Print("Закрылись в 0, дальше работаем с ТР");OnlyToZeroSell=false;}

if((BuyLok==false)&&(ReCountBuy>1)&&(OnlyToZeroBuy==false)&&((SellGoToZero==false)||(NoDeleteBuyProfit==true))&& ((ReBuyLots<BuyLots) || (ReBuyLots>BuyLots))){Print("Произошли изменения,пересчитаем профит у buy ордеров");CalculateTotalBuyTP();}
if((SellLok==false)&&(ReCountSell>1)&&(OnlyToZeroSell==false)&&((BuyGoToZero==false)||(NoDeleteSellProfit==true))&& ((ReSellLots<SellLots) || (ReSellLots>SellLots))){Print("Произошли изменения,пересчитаем профит у sell ордеров");CalculateTotalSellTP();}


if((BuyLok==true)&&(SellGoToZero==false)&&(ReCountBuy>1)&& ((ReBuyLots<BuyLots) || (ReBuyLots>BuyLots))){CalculateTotalBuyTP();}
if ((SellLok==true)&&(BuyGoToZero==false)&&(ReCountSell>1)&& ((ReSellLots<SellLots) || (ReSellLots>SellLots))){CalculateTotalSellTP();}


//if((BuyLok==true)&&(ReCountSell==0)&&(CloseLokS==true)){CalculateTotalBuyTP();}
//if((SellLok==true)&&(ReCountBuy==0)&&(CloseLokB==true)){CalculateTotalSellTP();}


if (((BuyLok==true)&&(SellGoToZero==false)&&(ReCountBuy>2)&&(CountBuy==(ReCountBuy-1))) || ((ReCountSell==0)&&CountSell>2)){CalculateTotalBuyTPToZero();}
if (((SellLok==true)&&(BuyGoToZero==false)&&(ReCountSell>2)&&(CountSell==(ReCountSell-1)))|| ((ReCountSell==0)&&CountSell>2)){CalculateTotalSellTPToZero();}

 SellOrdersProfit=0; BuyOrdersProfit=0; FirstBuyOrderProfit=0; FirstSellOrderProfit=0;SecondBuyOrderProfit=0; SecondSellOrderProfit=0;


if (BuyGoToZero==true){


if (SellLok2==true) {
CheckSellTP();
}
}
                      
SellOrdersProfit=0; BuyOrdersProfit=0; FirstBuyOrderProfit=0; FirstSellOrderProfit=0;SecondBuyOrderProfit=0; SecondSellOrderProfit=0;                      
if (SellGoToZero==true){


if (BuyLok2==true) {
CheckBuyTP();
}
}
 
   CountBuy=0;CountSell=0;TotalSlt=0;TotalBLt=0;OrderSwaps=0;total=OrdersTotal();LastBuyPrice=0;LastSellPrice=0;BuyLots=0;SellLots=0;
   //CloseLokB=false;CloseLokS=false;
   
  
   for(int i=0;i<total;i++)
     {
     
      if(OrderSelect(i,SELECT_BY_POS)==true)
        {
         if(OrderSymbol()==Symbol()) 
           {
            if(OrderType()==OP_BUY){CountBuy=CountBuy+1;TotalBLt=TotalBLt+OrderLots();BuyLots=BuyLots+OrderLots();    }
            if(OrderType()==OP_SELL){CountSell=CountSell+1;TotalSlt=TotalSlt+OrderLots();SellLots=SellLots+OrderLots();}
            if((OrderType()==OP_SELL) || (OrderType()==OP_BUY)){OrderSwaps=OrderSwaps+OrderSwap();}
           }
        }
     }
 if(CloseLokB==false){if(CountBuy>=OrdersToZero){CloseLokB=true;}}
 if(CloseLokS==false){if(CountSell>=OrdersToZero){CloseLokS=true;}}
 
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
      if((CountBuy==1) && (BuyTrade==true)&&(SellGoToZero==false)&&(BuyGoToZero==false))
        {
         for(int ibuy=0;ibuy<OrdersTotal();ibuy++)
           {
         
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
            
            Print("Открываем 2-й ордер Buy");
               SearchLastBuyLot();
           if (LastBuyLot<1){  Lot=NormalizeDouble(LastBuyLot*CoefLot,2); }
                else { Lot=LastBuyLot; }
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"12",Magic_Number,0,Blue)<0)
                 {Alert("Возникла ошибка № ",GetLastError()); }
               
              }
           }
        }


      //#Размещение 2-ого sell
      if((CountSell==1) && (SellTrade==true)&&(BuyGoToZero==false)&&(SellGoToZero==false))
        {
         for(int isell=0;isell<OrdersTotal();isell++)
           {
           
            if(OrderSelect(isell,SELECT_BY_POS)==true)
              {
               if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL))
                 {LastSellPrice=OrderOpenPrice();
                 
               
              
                 
                 
                 
           } 
              }
           }
         if(Bid>(LastSellPrice+Level1*k*Point))
           {
               SearchLastSellLot();    
         if (LastSellLot<1){  Lot=NormalizeDouble(LastSellLot*CoefLot,2); }
                else { Lot=LastSellLot; }
          
            Print("Открываем 2-й ордер Sell");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"22",Magic_Number,0,Red)<0)
                 {Alert("Возникла ошибка № ",GetLastError()); }
             
              }
           }
        }


           //#Размещение 3-ого buy
      if((CountBuy==2) && (BuyTrade==true)&&(SellGoToZero==false)&&(BuyGoToZero==false))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level2*k*Point))
           {
        
            Print("Открываем 3-й ордер Buy");
             SearchLastBuyLot();      
             if (LastBuyLot<1){  Lot=NormalizeDouble(LastBuyLot*CoefLot,2); }
                else { Lot=LastBuyLot; }
             
             
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"13",Magic_Number,0,Blue)<0)
                 {Alert("Возникла ошибка № ",GetLastError()); }
               
              }
           }
        }


     //#Размещение 3-ого sell
      if((CountSell==2) && (SellTrade==true)&&(BuyGoToZero==false)&&(SellGoToZero==false))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level2*k*Point))
           {
         
            Print("Открываем 3-й ордер Sell");
            SearchLastSellLot();    
         if (LastSellLot<1){  Lot=NormalizeDouble(LastSellLot*CoefLot,2); }
                else { Lot=LastSellLot; }
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"23",Magic_Number,0,Red)<0)
                 {Alert("Возникла ошибка № ",GetLastError()); }
              
              }
           }
        }

   //#Размещение 4-ого buy
      if((CountBuy==3) && (BuyTrade==true)&&(SellGoToZero==false)&&(BuyGoToZero==false))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level3*k*Point))
           {
           
            Print("Открываем 4-й ордер Buy");
                    SearchLastBuyLot();     if (LastBuyLot<2){  Lot=NormalizeDouble(LastBuyLot*CoefLot,2); }
                else { Lot=LastBuyLot; }
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"14",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }

              }
           }
        }


//#Размещение 4-ого  sell
      if((CountSell==3) && (SellTrade==true)&&(BuyGoToZero==false)&&(SellGoToZero==false))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level3*k*Point))
           {
            
            Print("Открываем 4-й ордер Sell");
            SearchLastSellLot();    if (LastSellLot<2){  Lot=NormalizeDouble(LastSellLot*CoefLot,2); }
                else { Lot=LastSellLot; }
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"24",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
            
              }
           }
        }

BuyComment();
SellComment();
   //#Размещение 5-ого buy
   
  
      if(((CountBuy==4)||(BComment=="14")) && (BuyTrade==true)&&(SellGoToZero==false))
        {
   
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level4*k*Point))
           {
            
            Print("Открываем 5-й ордер Buy");
                    SearchLastBuyLot();      if (LastBuyLot<1){  Lot=NormalizeDouble(LastBuyLot*CoefLot,2); }
                else { Lot=LastBuyLot; }
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"15",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
           
              }
           }
        }


      //#Размещение 5-ого  sell
      if(((CountSell==4)||(SComment=="24")) && (SellTrade==true)&&(BuyGoToZero==false))
        {
         SearchLastSellPrice();
             
         if(Bid>(LastSellPrice+Level4*k*Point))
           {
         
            Print("Открываем 5-й ордер Sell");
            SearchLastSellLot();    if (LastSellLot<1){  Lot=NormalizeDouble(LastSellLot*CoefLot,2); }
                else { Lot=LastSellLot;}
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"25",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
           
              }
           }
        }

    //#Размещение 6-ого buy
      if(((CountBuy==5)||(BComment=="15"))  && (BuyTrade==true)&&(SellGoToZero==false))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level5*k*Point))
           {
        
            Print("Открываем 6-й ордер Buy");
                    SearchLastBuyLot();      if (LastBuyLot<2){  Lot=NormalizeDouble(LastBuyLot*CoefLot,2); }
                else { Lot=LastBuyLot; }
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"16",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
              
              }
           }
        }


     //#Размещение 6-ого  sell
      if(((CountSell==5)||(SComment=="25")) && (SellTrade==true)&&(BuyGoToZero==false))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level5*k*Point))
           {
            
            Print("Открываем 6-й ордер Sell");
            SearchLastSellLot();    if (LastSellLot<2){  Lot=NormalizeDouble(LastSellLot*CoefLot,2); }
                else { Lot=LastSellLot; }
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"26",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               
              }
           }
        }
    //#Размещение 7-ого buy
      if(((CountBuy==6)||(BComment=="16")) && (BuyTrade==true)&&(SellGoToZero==false))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level6*k*Point))
           {
          
            Print("Открываем 7-й ордер Buy");
                    SearchLastBuyLot();      if (LastBuyLot<4){  Lot=NormalizeDouble(LastBuyLot*CoefLot,2); }
                else { Lot=LastBuyLot; }
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"17",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
              
              }
           }
        }


   //#Размещение 7-ого  sell
      if(((CountSell==6)||(SComment=="26")) && (SellTrade==true)&&(BuyGoToZero==false))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level6*k*Point))
           {
           
            Print("Открываем 7-й ордер Sell");
            SearchLastSellLot();   if (LastSellLot<4){  Lot=NormalizeDouble(LastSellLot*CoefLot,2); }
                else { Lot=LastSellLot; }
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"27",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               
              }
           }
        }


     //#Размещение 8-ого buy
      if(((CountBuy==7)||(BComment=="17")) && (BuyTrade==true)&&(SellGoToZero==false))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level7*k*Point))
           {
           
            Print("Открываем 8-й ордер Buy");
                    SearchLastBuyLot();        if (LastBuyLot<7){  Lot=NormalizeDouble(LastBuyLot*CoefLot,2); }
                else { Lot=LastBuyLot; }
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"18",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               
              }
           }
        }


//#Размещение 8-ого sell
     if(((CountSell==7)||(SComment=="27")) && (SellTrade==true)&&(BuyGoToZero==false))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level7*k*Point))
           {
            
            Print("Открываем 8-й ордер Sell");
            SearchLastSellLot();    if (LastSellLot<7){  Lot=NormalizeDouble(LastSellLot*CoefLot,2); }
                else { Lot=LastSellLot; }
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"28",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               
              }
           }
        }


//#Размещение 9-ого buy
      if(((CountBuy==8)||(BComment=="18")) && (BuyTrade==true)&&(SellGoToZero==false))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level8*k*Point))
           {
           
            Print("Открываем 9-й ордер Buy");
                    SearchLastBuyLot(); if (LastBuyLot<13){  Lot=NormalizeDouble(LastBuyLot*CoefLot,2); }
                else { Lot=LastBuyLot; }
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"19",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
              
              }
           }
        }


//#Размещение 9-ого sell
      if(((CountSell==8)||(SComment=="28")) && (SellTrade==true)&&(BuyGoToZero==false))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level8*k*Point))
           {
            
            Print("Открываем 9-й ордер Sell");
            SearchLastSellLot();if (LastSellLot<13){  Lot=NormalizeDouble(LastSellLot*CoefLot,2); }
                else { Lot=LastSellLot; }
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"29",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
             
              }
           }
        }

//#Размещение 10-ого buy
     if(((CountBuy==9)||(BComment=="19"))&& (BuyTrade==true)&&(SellGoToZero==false))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level9*k*Point))
           {
            
            Print("Открываем 10-й ордер Buy");
                    SearchLastBuyLot();Lot=LastBuyLot*CoefLot2; 
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
              
              }
           }
        }


//#Размещение 10-ого sell
      if(((CountSell==9)||(SComment=="29")) && (SellTrade==true)&&(BuyGoToZero==false))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level9*k*Point))
           {
         
            Print("Открываем 10-й ордер Sell");
            SearchLastSellLot();Lot=LastSellLot*CoefLot2; 
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"210",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               
              }
           }
        }
        
           
 if ((SellGoToZero==true)&&(BuyLok==false))     
 {
  Print("Открываем лок на покупку");
  GoGoBuy=SellLots*Percent/100/Lot1;NormalizeDouble(GoGoBuy,1);

 if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,Lot1*GoGoBuy,Ask,3*k,NULL,NULL,"BuyLok",Magic_Number,0,Blue) < 0) 
      {Alert("Ошибка открытия позиции № ", GetLastError()); }}
 
 }

 if ((BuyGoToZero==true)&&(SellLok==false))     
 {
  Print("Открываем лок на продажу");
 GoGoSell=BuyLots*Percent/100/Lot1;NormalizeDouble(GoGoSell,1);  
   
 if(OrderSend(Symbol(),OP_SELL,Lot1*GoGoSell,Bid,3*k,NULL,NULL,"SellLok",Magic_Number,0,Red) < 0)
           {Alert("Произошла ошибка",GetLastError()); }
 
 }
    
         
   
   if ((BuyLok==true)&&(BuyLok2==false)&&(((iMA(NULL,0,110,0,MODE_SMA,PRICE_CLOSE,1)+25*Point*k)<Close[1])&&(iATR(NULL,0,22,1)>0.0002)&&(iWPR(NULL,0,22,1)<-95)&&(iCCI(Symbol(),0,16,PRICE_TYPICAL,1)<-95))){
            
       //  GoGoBuy=SellLots*Percent/100/Lot1;NormalizeDouble(GoGoBuy,2);
       Print ("MixSystem Лок на BUY");

         if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,Lot2,Ask,3*k,NULL,NULL,"BuyLok2",Magic_Number,0,Blue) < 0) 
      {Alert("Ошибка открытия позиции № ", GetLastError()); }}
 
                    }
     if ((SellLok==true)&&(SellLok2==false)&&((((iMA(NULL,0,140,0,MODE_SMA,PRICE_CLOSE,1)-20*Point*k)>Close[1])&&(iATR(NULL,0,22,1)>0.0002)&&(iWPR(NULL,0,21,1)>-5)&&(iCCI(Symbol(),0,15,PRICE_TYPICAL,1)>90)))){
   
 //GoGoSell=BuyLots*Percent/100/Lot1;NormalizeDouble(GoGoSell,2);  
   Print ("MixSystem Лок на SELL");
         if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELL,Lot2,Bid,3*k,NULL,NULL,"SellLok2",Magic_Number,0,Red) < 0) 
      {Alert("Ошибка открытия позиции № ", GetLastError()); }}
 
                    }    
        
         
                   
        
        
        
        
        
        
        
 if(!isNewBar())return(0);
 Sleep(SleepingTime*100);

 
 
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
   if((ReCountBuy==0)&&(SellGoToZero==false) && (BuyTrade==true)&&((((Open[1]-Close[1])>BodySize*k*Point)&&((High[1]-Low[1])>CandleSize*k*Point))||(CountSell==Lok)))
     {   NoDeleteBuyProfit=false; GoGoBuy=1;ZeroB1=false;ZeroB2=false;
     
               
     if(SellGoToZero==false){NoDeleteBuyProfit=true;}
     
     
     
      Print("Размещение первого ордера на покупку ");
if (SellGoToZero==false){
      if(IsTradeAllowed()) 
        {
if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYSTOP,Lot1*GoGoBuy,High[1]+filtr*k*Point,3*k,NULL,High[1]+filtr*k*Point+TP*k*Point,"11",Magic_Number,0,Blue) < 0) 
      {Alert("Ошибка открытия позиции № ", GetLastError()); }}
      }
       } 
else {if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,Lot1*GoGoBuy,Ask,3*k,NULL,Ask+TP*k*Point,"11",Magic_Number,0,Blue) < 0) 
      {Alert("Ошибка открытия позиции № ", GetLastError()); }}}
     } 
//#Открытие первого ордера sell
   if((ReCountSell==0)&&(BuyGoToZero==false) && (SellTrade==true)&&((((Close[1]-Open[1])>BodySize*k*Point)&&((High[1]-Low[1])>CandleSize*k*Point))||(CountBuy==Lok)))
     {
     
        NoDeleteSellProfit=false;GoGoSell=1;ZeroS1=false;ZeroS2=false;
     if(BuyGoToZero==true){  GoGoSell=BuyLots*Percent/100/Lot1;NormalizeDouble(GoGoSell,2); } 
   
         if(BuyGoToZero==false){NoDeleteSellProfit=true;}
         
      Print("Размещение первого ордера на продажу");
      
      if (BuyGoToZero==false){
      if(IsTradeAllowed()) 
        {
         if(OrderSend(Symbol(),OP_SELLSTOP,Lot1*GoGoSell,Low[1]-filtr*k*Point,3*k,NULL,Low[1]-filtr*k*Point-TP*k*Point,"21",Magic_Number,0,Red) < 0)
           {Alert("Произошла ошибка",GetLastError()); }
        }
     }
     else { if(OrderSend(Symbol(),OP_SELL,Lot1*GoGoSell,Bid,3*k,NULL,Bid-TP*k*Point,"21",Magic_Number,0,Red) < 0)
           {Alert("Произошла ошибка",GetLastError()); }}
}
   return(0);
  }
  //Функция закрытия локовых ордеров на покупку 
double CheckBuyTP()
  {
TPB=0;
   double BuyLots=0;
   double PriceB=0;
   int CountB=0;
   double ProfitBuy;
   for(int ibuy2Result=0;ibuy2Result<OrdersTotal();ibuy2Result++)
     {
   
      if(OrderSelect(ibuy2Result,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (OrderComment()=="BuyLok2")) {PriceB=OrderOpenPrice();ProfitBuy=OrderProfit();}
        }
     }
     TPB=PriceB+TP2*Point*k;
     
    
     SearchFirstSellOrder(); OrderSelect(Ticket, SELECT_BY_TICKET);FirstSellOrderProfit=OrderProfit();
   if((TPB<Bid)||((ProfitBuy+FirstSellOrderProfit)>BonusDollar*100))
     {

     for (int bb=1;bb<30;bb++)
     {
         if((ProfitBuy+FirstSellOrderProfit/bb)>BonusDollar*100)
                          {
         CloseFirstSellBuyOrders(bb);
         break;
                          }   
     } 
     }
   return(0);
  }

double CheckSellTP()
  {
TPS=0;
   double SellLots=0;
   double PriceS=0;
   int CountS=0;double ProfitSell; 
   
   
   for(int isell2Result=0;isell2Result<OrdersTotal();isell2Result++)
     {
   
      if(OrderSelect(isell2Result,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol())&& (OrderType()==OP_SELL) && (OrderComment()=="SellLok2")) {PriceS=OrderOpenPrice();  ProfitSell=OrderProfit();}
        }
     }
     TPS=PriceS-TP2*Point*k;
      
     SearchFirstBuyOrder(); OrderSelect(Ticket, SELECT_BY_TICKET);FirstBuyOrderProfit=OrderProfit();
       
   if((Ask<TPS)||((ProfitSell+FirstBuyOrderProfit)>BonusDollar*100))
     {
 
     for (int ss=1;ss<30;ss++)
     {
  
         if((ProfitSell+FirstBuyOrderProfit/ss)>BonusDollar*100)
                          {
      CloseFirstBuySellOrders(ss);
         break;
                          }   
     } 
     }
   return(0);
  }



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
     
      if (CountB<OrdersToZero){TPB=PriceB/BuyLots+TP*Point*k;} else {TPB=PriceB/BuyLots+TP2*Point*k;}
      for(int ibuy3Result=0;ibuy3Result<OrdersTotal();ibuy3Result++)
        { 
         if(OrderSelect(ibuy3Result,SELECT_BY_POS)==true)
           {
            if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) 
              {
               
               bool res=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),TPB,0,Orange);
               if(!res)
                 { OrderClose(OrderTicket(),OrderLots(),Bid,3*k,Black); }
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
      if (TPB<Bid){Print ("Закрываемся по рынку"); CloseAllBuy();return(0);      }
      for(int ibuy3Result=0;ibuy3Result<OrdersTotal();ibuy3Result++)
        { 
         if(OrderSelect(ibuy3Result,SELECT_BY_POS)==true)
           {
            if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) 
              {
               RefreshRates();
                    if ((CountB==1)&&(OrderTakeProfit()!=NULL)){break;}
               if (OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),TPB,0,Orange)<0)
                { }
               
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
     if (CountS<OrdersToZero){ TPS=PriceS/SellLots-TP*Point*k; } else { TPS=PriceS/SellLots-TP2*Point*k; }
      for(int isell4Result=0;isell4Result<OrdersTotal();isell4Result++)
        { 
         if(OrderSelect(isell4Result,SELECT_BY_POS)==true)
           {
            if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)) 
              {
               RefreshRates();
               if ((CountS==1)&&(OrderTakeProfit()!=NULL)){break;}
              bool res=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),TPS,0,Orange);
              if (!res)
                 { OrderClose(OrderTicket(),OrderLots(),Ask,3*k,Black); }
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
      
      if (Ask<TPS){Print("Закрываем SELL по рынку"); CloseAllSell(); return(0);                 }
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
   LastSellLot=0;
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

   double CloseFirstBuySellOrders(int ss)
  {
   SearchFirstBuyOrder();
         OrderSelect(Ticket, SELECT_BY_TICKET); double j=OrderLots()/ss;  OrderClose(Ticket,j,Bid,3*k,Black);
       
     for(int S=OrdersTotal();S>0;S--)
     {
    if(OrderSelect(S,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (Magic_Number==OrderMagicNumber())&&(OrderComment()=="SellLok2")&&(OrderType()==OP_SELL))
           {
           OrderClose(OrderTicket(),OrderLots(),Ask,3*k,Black);
             
           }
        }
        }
        CalculateTotalBuyTPToZero();
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
        CalculateTotalBuyTPToZero();
      return(0);
  } 


     double CloseFirstSellBuyOrders(int bb)
  {
        SearchFirstSellOrder();
      OrderSelect(Ticket, SELECT_BY_TICKET); double t=OrderLots()/bb;
      OrderClose(Ticket,t,Ask,3*k,Black);
    for(int SS=OrdersTotal();SS>0;SS--)
     {
      if(OrderSelect(SS,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (OrderComment()=="BuyLok2")&& (Magic_Number==OrderMagicNumber()))
           {
        OrderClose(OrderTicket(),OrderLots(),Bid,3*k,Black);
           }
        }
        }

      CalculateTotalSellTPToZero();
      return(0);
  } 
  
     double CloseBuy()
  {

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

      return(0);
  } 
  
       double CloseAllOrders()
  {

    for(int SS=OrdersTotal()-1;SS>=0;SS--)
     {
      if(OrderSelect(SS,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol())&& (Magic_Number==OrderMagicNumber()))
           {
        OrderClose(OrderTicket(),OrderLots(),Bid,8*k,Black);
           }
   
           }
        }
        BuyLok=false;SellLok=false;BuyGoToZero=false;SellGoToZero=false;

      return(0);
  } 
     double CloseSell()
  {
RefreshRates();
    for(int SS=OrdersTotal();SS>0;SS--)
     {
      if(OrderSelect(SS,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)&& (Magic_Number==OrderMagicNumber()))
           {
        OrderClose(OrderTicket(),OrderLots(),Ask,3*k,Black);
           }
        }
        }

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

      CalculateTotalSellTPToZero();
      return(0);
  } 
  
  
  double StopBuy()
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

      SearchFirstBuyOrder();
              OrderSelect(Ticket, SELECT_BY_TICKET); 
       TPS=((PriceS+OrderOpenPrice()*(-OrderLots()))/(SellLots+(-OrderLots())))-TP2*k*Point;

          OrderModify(OrderTicket(),OrderOpenPrice(),TPS-Spread*Point*k,OrderTakeProfit(),0,Orange);
        
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
  
  


  
  
  
  


    double DeleteBuyTakeProfit() {

   for(int ibb=0;ibb<OrdersTotal();ibb++)
     {
      if(OrderSelect(ibb,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (OrderTakeProfit()!=NULL)&& (Magic_Number==OrderMagicNumber()))
           {
          Print("Удаляем профит первого ордера");   OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss() ,NULL,0,Orange); 
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
            Print("Удаляем профит первого ордера");   OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NULL,0,Orange); 
           }
        }
     }
   
   return(0);
  }
  
  
      double CloseAllBuy() {
     RefreshRates();
     int d=OrdersTotal();
   for(int bb=d-1;bb>=0;bb--)
     {

      if(OrderSelect(bb,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (Magic_Number==OrderMagicNumber()))
           {
    OrderClose(OrderTicket(),OrderLots(),Bid,3*k,Black);
           }
        }
     }
   
   return(0);
  }


  
      double CloseAllSell() {
 RefreshRates();
 int d=OrdersTotal();
   for(int ss=d-1;ss>=0;ss--)
     {
    
      if(OrderSelect(ss,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)&& (Magic_Number==OrderMagicNumber()))
           {
    OrderClose(OrderTicket(),OrderLots(),Ask,3*k,Black);
           }
        }
     }
   
   return(0);
  }
double BuyComment(){
BComment=NULL;
for (int iii=OrdersTotal()-1;iii>=0;iii--){
if(OrderSelect(iii,SELECT_BY_POS)==true){
if((OrderSymbol()==Symbol())&& ((OrderComment()=="14")|| (OrderComment()=="15")|| (OrderComment()=="16")|| (OrderComment()=="17")||(OrderComment()=="18")) && (OrderType()==OP_BUY)&&(Magic_Number==OrderMagicNumber()))
{BComment=OrderComment();break;}}}




return(BComment);}

double SellComment(){
SComment=NULL;
for (int iii=OrdersTotal()-1;iii>=0;iii--){
if(OrderSelect(iii,SELECT_BY_POS)==true){
if((OrderSymbol()==Symbol())&& ((OrderComment()=="24")|| (OrderComment()=="25")|| (OrderComment()=="26")|| (OrderComment()=="27")||(OrderComment()=="28"))  && (OrderType()==OP_SELL)&&(Magic_Number==OrderMagicNumber()))
{SComment=OrderComment();break;}}}

return(SComment);}
//+------------------------------------------------------------------+
//|                           SearchLastSellLot                                       |
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
