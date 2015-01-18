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

extern string ���������1="�������� ���������� �������";
extern bool BuyTrade=true;
extern bool SellTrade=true;
extern int filtr=5;
extern int BodySize=0;
extern int CandleSize=0;
extern int OrdersToZero=6;
extern int CriticalLotsInTrade2=3;
extern double CC=3;
extern int TP=10;
extern int Magic_Number=3213;
extern int Percent=30;
extern int CriticalCoef=5;
extern bool DinamicLot=true;
extern double MM=35000;
extern int Lok=3;
extern string ���������2="������ �������� ����������� ������� Buy/Sell";
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
extern string ���������3="������ ������� Buy/Sell";
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


double TP1;
int k;
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
double FirstSellOrderProfit;
double FirstBuyPrice;
double FirstSellPrice;
bool WithTpB=true;
bool WithTpS=true;
bool TradeWithTPB=false;
bool TradeWithTPS=false;
int Ticket;
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
  /* if(IsDemo()==false) 
     {
      Alert("�������� ����!");
      Sleep(6000);return(0);
     }*/
 ObjectCreate("label_object1",OBJ_LABEL,0,0,0);
ObjectSet("label_object1",OBJPROP_CORNER,4);
ObjectSet("label_object1",OBJPROP_XDISTANCE,10);
ObjectSet("label_object1",OBJPROP_YDISTANCE,10);
ObjectSetText("label_object1","���������� ������� Buy="+CountBuy+"; ��������� ���="+DoubleToStr(TotalBLt,2)+"SellGoToZero="+SellGoToZero,12,"Arial",Red);


ObjectCreate("label_object2",OBJ_LABEL,0,0,0);
ObjectSet("label_object2",OBJPROP_CORNER,4);
ObjectSet("label_object2",OBJPROP_XDISTANCE,10);
ObjectSet("label_object2",OBJPROP_YDISTANCE,30);
ObjectSetText("label_object2","���������� ������� Sell="+CountSell+"; ��������� ���="+DoubleToStr(TotalSlt,2)+"BuyGoToZero="+BuyGoToZero,12,"Arial",Red);
   ReCountBuy=0;ReCountSell=0;ReBuyLots=0;ReSellLots=0;BuyGoToZero=false;SellGoToZero=false;
   for(int in=0;in<OrdersTotal();in++)
     {      if(OrderSelect(in,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number) )
           {
            if(OrderType()==OP_BUY){ReCountBuy=ReCountBuy+1;ReBuyLots=ReBuyLots+OrderLots(); if(ReCountBuy>=OrdersToZero){BuyGoToZero=true;}}
            if(OrderType()==OP_SELL){ReCountSell=ReCountSell+1;ReSellLots=ReSellLots+OrderLots();if(ReSellLots>=OrdersToZero){SellGoToZero=true;}}
           }
        }
     }


if((ReCountBuy==0)&&(BuyGoToZero==false)&&(CloseLokB==true)){Print("��������� ���������,����������� ������ � sell �������");CalculateTotalSellTP();}
if((ReCountSell==0)&&(SellGoToZero==false)&&(CloseLokS==true)){Print("��������� ���������,����������� ������ � buy �������");CalculateTotalBuyTP();}


if((ReCountBuy>0)&&((SellGoToZero==false)||(WithTpB==true))&& ((ReBuyLots<BuyLots) || (ReBuyLots>BuyLots))){Print("��������� ���������,����������� ������ � buy �������");CalculateTotalBuyTP();}

if((ReCountSell>0)&&((BuyGoToZero==false)||(WithTpS==true))&& ((ReSellLots<SellLots) || (ReSellLots>SellLots))){Print("��������� ���������,����������� ������ � sell �������");CalculateTotalSellTP();}


 SellOrdersProfit=0; BuyOrdersProfit=0; FirstBuyOrderProfit=0; FirstSellOrderProfit=0;
 
//�������� ������� ������ �� ������� � ������� �� �������

if ((BuyGoToZero==true)&&((ReSellLots==2)||(ReSellLots==3))) {SearchFirstBuyOrderProfit(); SearchLokSellOrdersProfit(); OrderSelect(Ticket, SELECT_BY_TICKET);FirstBuyOrderProfit=OrderProfit();if(FirstBuyOrderProfit!=0){
if (((ReSellLots/OrderLots())<0.5)&&((ReSellLots/OrderLots())>0)){if((SellOrdersProfit+FirstBuyOrderProfit/16)>0){Print("��������� 1/16 ����� ������� ������ �� ������� � ������ �� �������");CloseQQQFirstBuySellOrders();}}
if (((ReSellLots/OrderLots())<2)&&((ReSellLots/OrderLots())>=0.5)){if((SellOrdersProfit+FirstBuyOrderProfit/8)>0){Print("��������� 1/8 ����� ������� ������ �� ������� � ������ �� �������");CloseQQFirstBuySellOrders();}}
if (((ReSellLots/OrderLots())<3)&&((ReSellLots/OrderLots())>=2)){if((SellOrdersProfit+FirstBuyOrderProfit/4)>0){Print("��������� 1/4 ������� ������ �� ������� � ������ �� �������");CloseQuatFirstBuySellOrders();}}
if (((ReSellLots/OrderLots())<6)&&((ReSellLots/OrderLots())>=3)){if((SellOrdersProfit+FirstBuyOrderProfit/2)>0){Print("��������� 1/2 ������� ������ �� ������� � ������ �� �������");CloseMidFirstBuySellOrders();}}
if ((ReSellLots/OrderLots())>=6){  if((SellOrdersProfit+FirstBuyOrderProfit)>0){Print("��������� ������ ����� �� ������� � ������ �� �������");CloseFirstBuySellOrders();}}


}
}
if (SellGoToZero==true) {SearchFirstSellOrderProfit();SearchLokBuyOrdersProfit();OrderSelect(Ticket, SELECT_BY_TICKET);FirstSellOrderProfit=OrderProfit();if(FirstSellOrderProfit!=0){
if (((ReBuyLots/OrderLots())<0.5)&&((ReBuyLots/OrderLots())>0)){if((BuyOrdersProfit+FirstSellOrderProfit/16)>0){Print("��������� 1/16 ������� ������ �� ������� � ������ �� �������");CloseQQQFirstSellBuyOrders();}}
if (((ReBuyLots/OrderLots())<2)&&((ReBuyLots/OrderLots())>=0.5)){if((BuyOrdersProfit+FirstSellOrderProfit/8)>0){Print("��������� 1/8 ������� ������ �� ������� � ������ �� �������");CloseQQFirstSellBuyOrders();}}
if (((ReBuyLots/OrderLots())<3)&&((ReBuyLots/OrderLots())>=2)){if((BuyOrdersProfit+FirstSellOrderProfit/4)>0){Print("��������� 1/4 ������� ������ �� ������� � ������ �� �������");CloseQuatFirstSellBuyOrders();}}
if (((ReBuyLots/OrderLots())<6)&&((ReBuyLots/OrderLots())>=3)){if((BuyOrdersProfit+FirstSellOrderProfit/2)>0){Print("��������� 1/2 ������� ������ �� ������� � ������ �� �������");CloseMidFirstSellBuyOrders();}}
if ((ReBuyLots/OrderLots())>=6){if((BuyOrdersProfit+FirstSellOrderProfit)>0){Print("��������� ������ ����� �� ������� � ������ �� �������");CloseFirstSellBuyOrders();}}



}
}
 
   CountBuy=0;CountSell=0;TotalSlt=0;TotalBLt=0;OrderSwaps=0;total=OrdersTotal();LastBuyPrice=0;LastSellPrice=0;BuyLots=0;SellLots=0;CloseLokB=false;CloseLokS=false;
   for(int i=0;i<total;i++)
     {
     
      if(OrderSelect(i,SELECT_BY_POS)==true)
        {
         if(OrderSymbol()==Symbol()) 
           {
            if(OrderType()==OP_BUY){CountBuy=CountBuy+1;TotalBLt=TotalBLt+OrderLots();BuyLots=BuyLots+OrderLots();if(TotalBLt>=OrdersToZero){CloseLokB=true;}}
            if(OrderType()==OP_SELL){CountSell=CountSell+1;TotalSlt=TotalSlt+OrderLots();SellLots=SellLots+OrderLots();if(TotalSlt>=OrdersToZero){CloseLokS=true;}}
            if((OrderType()==OP_SELL) || (OrderType()==OP_BUY)){OrderSwaps=OrderSwaps+OrderSwap();}
           }
        }
     }

//#�������� �������� �������
   if(CountBuy==0)
     {
      for(int iDel=OrdersTotal()-1; iDel>=0; iDel--)
        {
         if(!OrderSelect(iDel,SELECT_BY_POS,MODE_TRADES)) break;
         if((OrderType()==OP_BUYLIMIT) && (OrderMagicNumber()==Magic_Number)) if(IsTradeAllowed()) 
           {
            if(OrderDelete(OrderTicket())<0)
              {
               Alert("�������� ��������� ������",GetLastError());
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
               Alert("�������� ��������� ������",GetLastError());
              }
           }
        }
     }


     
      //#���������� 2-��� buy
      if((CountBuy==1) && (BuyTrade==true))
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
            
            Print("��������� 2-� ����� Buy");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot2,Ask,3*k,NULL,NULL,"12",Magic_Number,0,Blue)<0)
                 {Alert("�������� ������ � ",GetLastError()); }
               
              }
           }
        }


      //#���������� 2-��� sell
      if((CountSell==1) && (SellTrade==true))
        {
         for(int isell=0;isell<OrdersTotal();isell++)
           {
           
            if(OrderSelect(isell,SELECT_BY_POS)==true)
              {
               if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL))
                 {LastSellPrice=OrderOpenPrice();}
              }
           }
         if(Bid>(LastSellPrice+Level1*k*Point))
           {
          
            Print("��������� 2-� ����� Sell");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot2,Bid,3*k,NULL,NULL,"22",Magic_Number,0,Red)<0)
                 {Alert("�������� ������ � ",GetLastError()); }
             
              }
           }
        }


           //#���������� 3-��� buy
      if((CountBuy==2) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level2*k*Point))
           {
        
            Print("��������� 3-� ����� Buy");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot3,Ask,3*k,NULL,NULL,"13",Magic_Number,0,Blue)<0)
                 {Alert("�������� ������ � ",GetLastError()); }
               
              }
           }
        }


     //#���������� 3-��� sell
      if((CountSell==2) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level2*k*Point))
           {
         
            Print("��������� 3-� ����� Sell");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot3,Bid,3*k,NULL,NULL,"23",Magic_Number,0,Red)<0)
                 {Alert("�������� ������ � ",GetLastError()); }
              
              }
           }
        }

   //#���������� 4-��� buy
      if((CountBuy==3) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level3*k*Point))
           {
           
            Print("��������� 4-� ����� Buy");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot4,Ask,3*k,NULL,NULL,"14",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }

              }
           }
        }


//#���������� 4-���  sell
      if((CountSell==3) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level3*k*Point))
           {
            
            Print("��������� 4-� ����� Sell");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot4,Bid,3*k,NULL,NULL,"24",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
            
              }
           }
        }


   //#���������� 5-��� buy
      if((CountBuy==4) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level4*k*Point))
           {
            
            Print("��������� 5-� ����� Buy");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot5,Ask,3*k,NULL,NULL,"15",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
           
              }
           }
        }


      //#���������� 5-���  sell
      if((CountSell==4) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level4*k*Point))
           {
         ;
            Print("��������� 5-� ����� Sell");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot5,Bid,3*k,NULL,NULL,"25",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
           
              }
           }
        }

    //#���������� 6-��� buy
      if((CountBuy==5) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level5*k*Point))
           {
        
            Print("��������� 6-� ����� Buy");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot6,Ask,3*k,NULL,NULL,"16",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
              
              }
           }
        }


     //#���������� 6-���  sell
      if((CountSell==5) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level5*k*Point))
           {
            
            Print("��������� 6-� ����� Sell");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot6,Bid,3*k,NULL,NULL,"26",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
               
              }
           }
        }
    //#���������� 7-��� buy
      if((CountBuy==6) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level6*k*Point))
           {
          
            Print("��������� 7-� ����� Buy");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot7,Ask,3*k,NULL,NULL,"17",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
              
              }
           }
        }


   //#���������� 7-���  sell
      if((CountSell==6) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level6*k*Point))
           {
           
            Print("��������� 7-� ����� Sell");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot7,Bid,3*k,NULL,NULL,"27",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
               
              }
           }
        }


     //#���������� 8-��� buy
      if((CountBuy==7) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level7*k*Point))
           {
           
            Print("��������� 8-� ����� Buy");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot8,Ask,3*k,NULL,NULL,"18",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
               
              }
           }
        }


//#���������� 8-��� sell
      if((CountSell==7) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level7*k*Point))
           {
            
            Print("��������� 8-� ����� Sell");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot8,Bid,3*k,NULL,NULL,"28",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
               
              }
           }
        }


//#���������� 9-��� buy
      if((CountBuy==8) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level8*k*Point))
           {
           
            Print("��������� 9-� ����� Buy");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot9,Ask,3*k,NULL,NULL,"19",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
              
              }
           }
        }


//#���������� 9-��� sell
      if((CountSell==8) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level8*k*Point))
           {
            
            Print("��������� 9-� ����� Sell");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot9,Bid,3*k,NULL,NULL,"29",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
             
              }
           }
        }

//#���������� 10-��� buy
      if((CountBuy==9) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level9*k*Point))
           {
            
            Print("��������� 10-� ����� Buy");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot10,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
              
              }
           }
        }


//#���������� 10-��� sell
      if((CountSell==9) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level9*k*Point))
           {
         
            Print("��������� 10-� ����� Sell");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot10,Bid,3*k,NULL,NULL,"210",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
               
              }
           }
        }


      //#�瓣癡穩穩�瓣繹�簷羶矇 簾簸瓣疇簸 buy
      if((CountBuy==10) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level10*k*Point))
           {
            
            Print("�簷礙簸羶簷癡疇 簾瓣癡穩穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簾礙籀簿礙籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot11,Ask,3*k,NULL,NULL,"Sun-Lot11-buy(11)",Magic_Number,0,Blue)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
              
              }
           }
        }


      //#�瓣癡穩穩�瓣繹�簷羶矇 簾簸瓣疇簸 sell
      if((CountSell==10) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level10*k*Point))
           {
            
            Print("�簷礙簸羶簷癡疇 簾瓣癡穩穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簸簾瓣�疆籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot11,Bid,3*k,NULL,NULL,"Sun-Lot11-sell(11)",Magic_Number,0,Red)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }

      //#�璽疇穩�瓣繹�簷羶矇 簾簸瓣疇簸 buy
      if((CountBuy==11) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level11*k*Point))
           {
            
            Print("�簷礙簸羶簷癡疇 瓣璽疇穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簾礙籀簿礙籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot12,Ask,3*k,NULL,NULL,"Sun-Lot12-buy(12)",Magic_Number,0,Blue)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }


      //#�璽疇穩�瓣繹�簷羶矇 簾簸瓣疇簸 sell
      if((CountSell==11) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level11*k*Point))
           {
            
            Print("�簷礙簸羶簷癡疇 瓣璽疇穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簸簾瓣�疆籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot12,Bid,3*k,NULL,NULL,"Sun-Lot12-sell(12)",Magic_Number,0,Red)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }

      //#�簸癡穩�瓣繹�簷羶矇 簾簸瓣疇簸 buy
      if((CountBuy==12) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level12*k*Point))
           {
          
            Print("�簷礙簸羶簷癡疇 簷簸癡穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簾礙籀簿礙籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot13,Ask,3*k,NULL,NULL,"Sun-Lot13-buy(13)",Magic_Number,0,Blue)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }


      //#�簸癡穩�瓣繹�簷羶矇 簾簸瓣疇簸 sell
      if((CountSell==12) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level12*k*Point))
           {
            
            Print("�簷礙簸羶簷癡疇 簷簸癡穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簸簾瓣�疆籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot13,Bid,3*k,NULL,NULL,"Sun-Lot13-sell(13)",Magic_Number,0,Red)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
              
              }
           }
        }


      //#�疇簷羶簸穩�瓣繹�簷羶矇 簾簸瓣疇簸 buy
      if((CountBuy==13) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level13*k*Point))
           {
           
            Print("�簷礙簸羶簷癡疇 繩疇簷羶簸穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簾礙籀簿礙籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot14,Ask,3*k,NULL,NULL,"Sun-Lot14-buy(14)",Magic_Number,0,Blue)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }


      //#�疇簷羶簸穩�瓣繹�簷羶矇 簾簸瓣疇簸 sell
      if((CountSell==13) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level13*k*Point))
           {
           
            Print("�簷礙簸羶簷癡疇 繩疇簷羶簸穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簸簾瓣�疆籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot14,Bid,3*k,NULL,NULL,"Sun-Lot14-sell(14)",Magic_Number,0,Red)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }

      //#�藩簷穩�瓣繹�簷羶矇 簾簸瓣疇簸 buy
      if((CountBuy==14) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level14*k*Point))
           {
            
            Print("�簷礙簸羶簷癡疇 簿藩簷穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簾礙籀簿礙籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot15,Ask,3*k,NULL,NULL,"Sun-Lot15-buy(15)",Magic_Number,0,Blue)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
             
              }
           }
        }


      //#�藩簷穩�瓣繹�簷羶矇 簾簸瓣疇簸 sell
      if((CountSell==14) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level14*k*Point))
           {
          
            Print("�簷礙簸羶簷癡疇 簿藩簷穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簸簾瓣�疆籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot15,Bid,3*k,NULL,NULL,"Sun-Lot15-sell(15)",Magic_Number,0,Red)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }

      //#�疇簽簷穩�瓣繹�簷羶矇 簾簸瓣疇簸 buy
      if((CountBuy==15) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level15*k*Point))
           {
          
            Print("�簷礙簸羶簷癡疇 繪疇簽簷穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簾礙籀簿礙籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot16,Ask,3*k,NULL,NULL,"Sun-Lot16-buy(16)",Magic_Number,0,Blue)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }


      //#�疇簽簷穩�瓣繹�簷羶矇 簾簸瓣疇簸 sell
      if((CountSell==15) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level15*k*Point))
           {
            
            Print("�簷礙簸羶簷癡疇 繪疇簽簷穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簸簾瓣�疆籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot16,Bid,3*k,NULL,NULL,"Sun-Lot16-sell(16)",Magic_Number,0,Red)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }
      //#�疇穫穩�瓣繹�簷羶矇 簾簸瓣疇簸 buy
      if((CountBuy==16) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level16*k*Point))
           {
            
            Print("�簷礙簸羶簷癡疇 簽疇穫穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簾礙籀簿礙籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot17,Ask,3*k,NULL,NULL,"Sun-Lot17-buy(17)",Magic_Number,0,Blue)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }


      //#�疇穫穩�瓣繹�簷羶矇 簾簸瓣疇簸 sell
      if((CountSell==16) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level16*k*Point))
           {
            
            Print("�簷礙簸羶簷癡疇 簽疇穫穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簸簾瓣�疆籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot17,Bid,3*k,NULL,NULL,"Sun-Lot17-sell(17)",Magic_Number,0,Red)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
              
              }
           }
        }
      //#�簾簽疇穫穩�瓣繹�簷羶矇 簾簸瓣疇簸 buy
      if((CountBuy==17) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level17*k*Point))
           {
            
            Print("�簷礙簸羶簷癡疇 璽簾簽疇穫穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簾礙籀簿礙籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot18,Ask,3*k,NULL,NULL,"Sun-Lot18-buy(18)",Magic_Number,0,Blue)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }


      //#�簾簽疇穫穩�瓣繹�簷羶矇 簾簸瓣疇簸 sell
      if((CountSell==17) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level17*k*Point))
           {
            
            Print("�簷礙簸羶簷癡疇 璽簾簽疇穫穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簸簾瓣�疆籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot18,Bid,3*k,NULL,NULL,"Sun-Lot18-sell(18)",Magic_Number,0,Red)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }
      //#�疇璽藩簷穩�瓣繹�簷羶矇 簾簸瓣疇簸 buy
      if((CountBuy==18) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level18*k*Point))
           {
            
            Print("�簷礙簸羶簷癡疇 瓣疇璽藩簷穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簾礙籀簿礙籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot19,Ask,3*k,NULL,NULL,"Sun-Lot19-buy(19)",Magic_Number,0,Blue)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }


      //#�疇璽藩簷穩�瓣繹�簷羶矇 簾簸瓣疇簸 sell
      if((CountSell==18) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level18*k*Point))
           {
            
            Print("�簷礙簸羶簷癡疇 瓣疇璽藩簷穩�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簸簾瓣�疆籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot19,Bid,3*k,NULL,NULL,"Sun-Lot19-sell(19)",Magic_Number,0,Red)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }
      //#�璽�瓣繹�簷羶矇 簾簸瓣疇簸 buy
      if((CountBuy==19) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level19*k*Point))
           {
            
            Print("�簷礙簸羶簷癡疇 瓣璽�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簾礙籀簿礙籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,GoGoBuy*Lot20,Ask,3*k,NULL,NULL,"Sun-Lot20-buy(20)",Magic_Number,0,Blue)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }


      //#�璽�瓣繹�簷羶矇 簾簸瓣疇簸 sell
      if((CountSell==19) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level19*k*Point))
           {
      
            Print("�簷礙簸羶簷癡疇 瓣璽�瓣繹�簷簾瓊簾 簾簸瓣疇簸� 穩� 簿簸簾瓣�疆籀");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot20,Bid,3*k,NULL,NULL,"Sun-Lot20-sell(20)",Magic_Number,0,Red)<0)
                 {Alert("�繪癡獺礙� 簾簷礙簸羶簷癡藩 簿簾癟癡繹癡癡 繒 ",GetLastError()); }
               
              }
           }
        }
        
        
        
//#�������� ������� ������ buy
   if((CountBuy==0) && (BuyTrade==true)&&((Open[1]-Close[1])>BodySize*k*Point)&&((High[1]-Low[1])>CandleSize*k*Point))
     {     if (SellGoToZero==false){GoGoBuy=1; if ((DinamicLot==true)&&(GoGoBuy<(AccountEquity()/MM))) {GoGoBuy=AccountEquity()/MM;}}
   
        TradeWithTPB=false;

//if (GoGoBuy<1) {GoGoBuy=1;}

if (SellGoToZero==true){if((AccountEquity()/MM)>1){GoGoBuy=AccountEquity()/MM*CC;}else{GoGoBuy=CC;} if(ReSellLots>(OrdersToZero)){GoGoBuy=2*CC;} if(ReSellLots>(CriticalLotsInTrade2)){GoGoBuy=3*CC;}


}
if (GoGoBuy>CriticalCoef){GoGoBuy=CriticalCoef;}
//if ((SellGoToZero==false)&&(DinamicLot==true)){Print("������� ���������� ������");GoGoBuy=AccountEquity()/MM;}
Sleep(2000);
      Print("���������� ������� ������ �� ������� ");
      if ((SellGoToZero==false)||(TradeWithTPB==true)){TP1=Ask+TP*Point*k;WithTpB=true;}
      else {TP1=NULL;WithTpB=false;}
      if(IsTradeAllowed()) 
        {
if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYSTOP,Lot1*GoGoBuy,High[1]+filtr*k*Point,3*k,NULL,High[1]+filtr*k*Point+TP*k*Point,"11",Magic_Number,0,Blue) < 0) 
      {Alert("������ �������� ������� � ", GetLastError()); }}
      }
        

     }
//#�������� ������� ������ sell
   if((CountSell==0) && (SellTrade==true)&&((Close[1]-Open[1])>BodySize*k*Point)&&((High[1]-Low[1])>CandleSize*k*Point))
     {
     if (BuyGoToZero==false){GoGoSell=1; if ((DinamicLot==true)&&(GoGoSell<(AccountEquity()/MM))) {GoGoSell=AccountEquity()/MM;} Print("GoGoSell",GoGoSell);}
     TradeWithTPS=false;
   if(ReCountBuy==0){ GoGoSell=1;}

if (BuyGoToZero==true){ 
if ((AccountEquity()/MM)>1){ 
        GoGoSell=AccountEquity()/MM*CC;} else {GoGoSell=CC;} if(ReBuyLots>(OrdersToZero)){GoGoSell=2*CC;} if(ReBuyLots>(CriticalLotsInTrade2)){GoGoSell=3*CC;}
}
if (GoGoSell>CriticalCoef){GoGoSell=CriticalCoef;}
//if ((BuyGoToZero==false)&&(DinamicLot==true)){Print("������� ���������� ������");GoGoSell=AccountEquity()/MM;}
Print ("�������� 1-�� sell ������");
Sleep(2000);
    if ((BuyGoToZero==false)||(TradeWithTPS==true)){TP1=Bid-TP*Point*k;WithTpS=true;}
      else {TP1=NULL;WithTpS=false;}
      Print("���������� ������� ������ �� �������");
      if(IsTradeAllowed()) 
        {
         if(OrderSend(Symbol(),OP_SELL,GoGoSell*Lot1,Bid,3*k,NULL,TP1,"21",Magic_Number,0,Red)<0)
           {Alert("��������� ������",GetLastError()); }
        }
     }

   return(0);
  }
  
//#��簽簽繩繡簷 癡簷簾瓊簾璽簾瓊簾 簿簸簾繫癡簷� 簾簸瓣疇簸簾璽 穩� 簿簾礙籀簿礙籀

//#��簽簽繩繡簷 癡簷簾瓊簾璽簾瓊簾 簿簸簾繫癡簷� 簾簸瓣疇簸簾璽 穩� 簿簾礙籀簿礙籀
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
      // 簸疇癟籀禱羹簷�簷 璽羶獺簾簸� 簿簸簾璽疇簸礙癡, 簷�礙 礙�礙 簾簸瓣疇簸 穫簾疆疇簷 獺羶簷羹 癟�礙簸羶簷 癡禱癡 籀瓣�禱疇穩 璽 羸簷簾 璽簸疇穫藩!
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
  
//#�簾癡簽礙 簿簾簽禱疇瓣穩疇瓊簾 簾簸瓣疇簸� 穩� 簿簾礙籀簿礙籀
double SearchLastBuyPrice()
  {
   LastBuyPrice=0;
   for(int ibuySearch=0;ibuySearch<OrdersTotal();ibuySearch++)
     {
      // 簸疇癟籀禱羹簷�簷 璽羶獺簾簸� 簿簸簾璽疇簸礙癡, 簷�礙 礙�礙 簾簸瓣疇簸 穫簾疆疇簷 獺羶簷羹 癟�礙簸羶簷 癡禱癡 籀瓣�禱疇穩 璽 羸簷簾 璽簸疇穫藩!
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
//#�簾癡簽礙 簿簾簽禱疇瓣穩疇瓊簾 簾簸瓣疇簸� 穩� 簿簸簾瓣�疆籀
double SearchLastSellPrice()
  {
   LastSellPrice=0;
   for(int isellSearch=0;isellSearch<OrdersTotal();isellSearch++)
     {
      // 簸疇癟籀禱羹簷�簷 璽羶獺簾簸� 簿簸簾璽疇簸礙癡, 簷�礙 礙�礙 簾簸瓣疇簸 穫簾疆疇簷 獺羶簷羹 癟�礙簸羶簷 癡禱癡 籀瓣�禱疇穩 璽 羸簷簾 璽簸疇穫藩!
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
//#�簾癡簽礙 簿簾簽禱疇瓣穩疇瓊簾 禱癡穫癡簷穩簾瓊簾 簾簸瓣疇簸� 穩� 簿簾礙籀簿礙籀
double SearchLastLimBuyPrice()
  {
   LastBuyPrice=0;
   for(int ibuySearch1=0;ibuySearch1<OrdersTotal();ibuySearch1++)
     {
      // 簸疇癟籀禱羹簷�簷 璽羶獺簾簸� 簿簸簾璽疇簸礙癡, 簷�礙 礙�礙 簾簸瓣疇簸 穫簾疆疇簷 獺羶簷羹 癟�礙簸羶簷 癡禱癡 籀瓣�禱疇穩 璽 羸簷簾 璽簸疇穫藩!
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
//#�簾癡簽礙 簿簾簽禱疇瓣穩疇瓊簾 禱癡穫癡簷穩簾瓊簾 簾簸瓣疇簸� 穩� 簿簸簾瓣�疆籀
double SearchLastLimSellPrice()
  {
   LastSellPrice=0;
   
   for(int isellSearch1=0;isellSearch1<OrdersTotal();isellSearch1++)
     {
      // 簸疇癟籀禱羹簷�簷 璽羶獺簾簸� 簿簸簾璽疇簸礙癡, 簷�礙 礙�礙 簾簸瓣疇簸 穫簾疆疇簷 獺羶簷羹 癟�礙簸羶簷 癡禱癡 籀瓣�禱疇穩 璽 羸簷簾 璽簸疇穫藩!
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
  double SearchFirstBuyOrderProfit() {
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
  
    double SearchFirstSellOrderProfit() {
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
   SearchFirstBuyOrderProfit();
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
        CalculateTotalBuyTPToZero();
      return(0);
  } 

 double CloseMidFirstBuySellOrders()
  {
   SearchFirstBuyOrderProfit();

         OrderSelect(Ticket, SELECT_BY_TICKET); 
          double Mid=OrderLots()/2;
            OrderClose(Ticket,Mid,Bid,3*k,Black);
       
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
double CloseQuatFirstBuySellOrders()
  {
   SearchFirstBuyOrderProfit();

         OrderSelect(Ticket, SELECT_BY_TICKET); 
          double Quat=OrderLots()/4;
          
            OrderClose(Ticket,Quat,Bid,3*k,Black);
       
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
  
double CloseQQFirstBuySellOrders()
  {
   SearchFirstBuyOrderProfit();

         OrderSelect(Ticket, SELECT_BY_TICKET); 
          double QQ=OrderLots()/8;
           if(QQ<0.01){QQ=0.01;}
            OrderClose(Ticket,QQ,Bid,3*k,Black);
       
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
  
  double CloseQQQFirstBuySellOrders()
  {
   SearchFirstBuyOrderProfit();

         OrderSelect(Ticket, SELECT_BY_TICKET); 
          double QQQ=OrderLots()/16;
           if(QQQ<0.01){QQQ=0.01;}
            OrderClose(Ticket,QQQ,Bid,3*k,Black);
       
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
   double CloseFirstSellBuyOrders()
  {
        SearchFirstSellOrderProfit();
      OrderSelect(Ticket, SELECT_BY_TICKET); 
      OrderClose(Ticket,OrderLots(),Ask,3*k,Black);
  Ticket=0;
  FirstSellPrice=0;
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
  
  double CloseMidFirstSellBuyOrders()
  {
        SearchFirstSellOrderProfit();
      OrderSelect(Ticket, SELECT_BY_TICKET); 
      double Mid=OrderLots()/2;
      OrderClose(Ticket,Mid,Ask,3*k,Black);
  Ticket=0;
  FirstSellPrice=0;
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
  
   double CloseQuatFirstSellBuyOrders()
  {
        SearchFirstSellOrderProfit();
      OrderSelect(Ticket, SELECT_BY_TICKET); 
      double Quat=OrderLots()/4;
      OrderClose(Ticket,Quat,Ask,3*k,Black);
  Ticket=0;
  FirstSellPrice=0;
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
  
    double CloseQQFirstSellBuyOrders()
  {
        SearchFirstSellOrderProfit();
      OrderSelect(Ticket, SELECT_BY_TICKET); 
      double QQ=OrderLots()/8;
      if(QQ<0.01){QQ=0.01;}
      OrderClose(Ticket,QQ,Ask,3*k,Black);
  Ticket=0;
  FirstSellPrice=0;
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
     
     double CloseQQQFirstSellBuyOrders()
  {
        SearchFirstSellOrderProfit();
      OrderSelect(Ticket, SELECT_BY_TICKET); 
      double QQQ=OrderLots()/16;
       if(QQQ<0.01){QQQ=0.01;}
      OrderClose(Ticket,QQQ,Ask,3*k,Black);
  Ticket=0;
  FirstSellPrice=0;
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
  
  
  double BuySTOPDel()
{for (int iDel1=OrdersTotal()-1; iDel1>=0; iDel1--)
   {
      if (!OrderSelect(iDel1,SELECT_BY_POS,MODE_TRADES)) break;
            if ((OrderType()==OP_BUYSTOP)&&(OrderMagicNumber() == Magic_Number ))    if (IsTradeAllowed()) { if (OrderDelete(OrderTicket())<0) 
            { 
        Alert("������ �������� ������ � ", GetLastError()); 
      }  
            }
} return(0);}

double SellSTOPDel()
{for (int iDel2=OrdersTotal()-1; iDel2>=0; iDel2--)
   {
      if (!OrderSelect(iDel2,SELECT_BY_POS,MODE_TRADES)) break;
            if ((OrderType()==OP_SELLSTOP)&&(OrderMagicNumber() == Magic_Number ))    if (IsTradeAllowed()) { if (OrderDelete(OrderTicket())<0) 
            { 
        Alert("������ �������� ������ � ", GetLastError()); 
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
          Print("������� ������ ������� ������");   OrderModify(OrderTicket(),OrderOpenPrice(),NULL,NULL,0,Orange); 
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
            Print("������� ������ ������� ������");   OrderModify(OrderTicket(),OrderOpenPrice(),NULL,NULL,0,Orange); 
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
//---- �簾癟璽簸�羅�疇簷 礙簾禱癡繩疇簽簷璽簾 簾簸瓣疇簸簾璽 籀礙�癟�穩穩簾瓊簾 簷癡簿� 簾簸瓣疇簸簾璽 ----//
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
