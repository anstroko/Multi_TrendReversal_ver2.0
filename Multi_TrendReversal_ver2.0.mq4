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
extern string �ap������="��������� ���������";
extern int LotsBuy=8;
extern int LotsSell=8;
extern string �ap������1="��������� �������";
extern bool BuyTrade=true;
extern bool SellTrade=true;
extern int TP=10;
extern int Magic_Number=3213;
extern string �ap������2="������ �������� ������� Buy/Sell";
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
extern string �ap������5="���� ������� Buy/Sell";
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
      Alert("�������� ����!");
      Sleep(6000);return(0);
     }
//�������� ��������� � ���������   
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
      // ��������� ������ ��������, ��� ��� ����� ����� ���� ������ ��� ������ � ��� �����!
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
               Alert("������ �������� ������ � ",GetLastError());
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
               Alert("������ �������� ������ � ",GetLastError());
              }
           }
        }
     }
//#����� ������ TP ��� BUY
   if((CountBuy!=0) && (CountBuy!=1))
     {
      double BuyOrderTP=0;
      bool CalculateNow=false;
      for(int iss=0;iss<OrdersTotal();iss++)
        {
         // ��������� ������ ��������, ��� ��� ����� ����� ���� ������ ��� ������ � ��� �����!
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
//#����� ������ TP ��� SELL
   if((CountSell!=0) && (CountSell!=1))
     {
      double SellOrderTP=0;
      bool CalculateNow=false;
      for(int is=0;is<OrdersTotal();is++)
        {
         // ��������� ������ ��������, ��� ��� ����� ����� ���� ������ ��� ������ � ��� �����!
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
//#������ ����� buy
   if((CountBuy==0) && (BuyTrade==true))
     {
      Print("�������� ������� ������ �� �������");
      if(IsTradeAllowed()) 
        {
         if(OrderSend(Symbol(),OP_BUY,Lot1,Ask,3*k,NULL,Ask+TP*Point*k,"Sun-Lot1-buy(1)",Magic_Number,0,Blue)<0)
           {Alert("������ �������� ������� � ",GetLastError()); }
        }

     }
//#������ ����� sell
   if((CountSell==0) && (SellTrade==true))
     {
      Print("�������� ������� ������ �� �������");
      if(IsTradeAllowed()) 
        {
         if(OrderSend(Symbol(),OP_SELL,Lot1,Bid,3*k,NULL,Bid-TP*Point*k,"Sun-Lot1-sell(1)",Magic_Number,0,Red)<0)
           {Alert("������ �������� ������� � ",GetLastError()); }
        }
     }

     
      //#������ ����� buy
      if((CountBuy==1) && (BuyTrade==true))
        {
         for(int ibuy=0;ibuy<OrdersTotal();ibuy++)
           {
            // ��������� ������ ��������, ��� ��� ����� ����� ���� ������ ��� ������ � ��� �����!
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
            
            Print("�������� ������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot2,Ask,3*k,NULL,NULL,"Sun-Lot2-buy(2)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }


      //#������ ����� sell
      if((CountSell==1) && (SellTrade==true))
        {
         for(int isell=0;isell<OrdersTotal();isell++)
           {
            // ��������� ������ ��������, ��� ��� ����� ����� ���� ������ ��� ������ � ��� �����!
            if(OrderSelect(isell,SELECT_BY_POS)==true)
              {
               if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL))
                 {LastSellPrice=OrderOpenPrice();}
              }
           }
         if(Bid>(LastSellPrice+Level1*k*Point))
           {
            CalculateSellTP();
            Print("�������� ������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot2,Ask,3*k,NULL,NULL,"Sun-Lot2-sell(2)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
             
              }
           }
        }


      //#������ ����� buy
      if((CountBuy==2) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level2*k*Point))
           {
        
            Print("�������� �������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot3,Ask,3*k,NULL,NULL,"Sun-Lot3-buy(3)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }


      //������ ����� sell
      if((CountSell==2) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level2*k*Point))
           {
         
            Print("�������� �������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot3,Ask,3*k,NULL,NULL,"Sun-Lot3-sell(3)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
              
              }
           }
        }

      //#��������� ����� buy
      if((CountBuy==3) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level3*k*Point))
           {
           
            Print("�������� ���������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot4,Ask,3*k,NULL,NULL,"Sun-Lot4-buy(4)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }

              }
           }
        }


      //#��������� ����� sell
      if((CountSell==3) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level3*k*Point))
           {
            
            Print("�������� ���������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot4,Ask,3*k,NULL,NULL,"Sun-Lot4-sell(4)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
            
              }
           }
        }


      //#����� ����� buy
      if((CountBuy==4) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level4*k*Point))
           {
            
            Print("�������� ������ ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot5,Ask,3*k,NULL,NULL,"Sun-Lot5-buy(5)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
           
              }
           }
        }


      //#����� ����� sell
      if((CountSell==4) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level4*k*Point))
           {
         ;
            Print("�������� ������ ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot5,Ask,3*k,NULL,NULL,"Sun-Lot5-sell(5)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
           
              }
           }
        }

      //#������ ����� buy
      if((CountBuy==5) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level5*k*Point))
           {
        
            Print("�������� ������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot6,Ask,3*k,NULL,NULL,"Sun-Lot6-buy(6)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
              
              }
           }
        }


      //#������ ����� sell
      if((CountSell==5) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level5*k*Point))
           {
            
            Print("�������� ������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot6,Ask,3*k,NULL,NULL,"Sun-Lot6-sell(6)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }
      //#������� ����� buy
      if((CountBuy==6) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level6*k*Point))
           {
          
            Print("�������� �������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot7,Ask,3*k,NULL,NULL,"Sun-Lot7-buy(7)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
              
              }
           }
        }


      //#������� ����� sell
      if((CountSell==6) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level6*k*Point))
           {
           
            Print("�������� �������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot7,Ask,3*k,NULL,NULL,"Sun-Lot7-sell(7)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }


      //#������� ����� buy
      if((CountBuy==7) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level7*k*Point))
           {
           
            Print("�������� �������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot8,Ask,3*k,NULL,NULL,"Sun-Lot8-buy(8)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }


      //#������� ����� sell
      if((CountSell==7) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level7*k*Point))
           {
            
            Print("�������� �������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot8,Ask,3*k,NULL,NULL,"Sun-Lot8-sell(8)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }


      //#������� ����� buy
      if((CountBuy==8) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level8*k*Point))
           {
           
            Print("�������� �������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot9,Ask,3*k,NULL,NULL,"Sun-Lot9-buy(9)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
              
              }
           }
        }


      //#������� ����� sell
      if((CountSell==8) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level8*k*Point))
           {
            
            Print("�������� �������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot9,Ask,3*k,NULL,NULL,"Sun-Lot9-sell(9)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
             
              }
           }
        }

      //#������� ����� buy
      if((CountBuy==9) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level9*k*Point))
           {
            
            Print("�������� �������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot10,Ask,3*k,NULL,NULL,"Sun-Lot10-buy(10)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
              
              }
           }
        }


      //#������� ����� sell
      if((CountSell==9) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level9*k*Point))
           {
         
            Print("�������� �������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot10,Ask,3*k,NULL,NULL,"Sun-Lot10-sell(10)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }


      //#������������ ����� buy
      if((CountBuy==10) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level10*k*Point))
           {
            
            Print("�������� ������������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot11,Ask,3*k,NULL,NULL,"Sun-Lot11-buy(11)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
              
              }
           }
        }


      //#������������ ����� sell
      if((CountSell==10) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level10*k*Point))
           {
            
            Print("�������� ������������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot11,Ask,3*k,NULL,NULL,"Sun-Lot11-sell(11)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }

      //#����������� ����� buy
      if((CountBuy==11) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level11*k*Point))
           {
            
            Print("�������� ������������ ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot12,Ask,3*k,NULL,NULL,"Sun-Lot12-buy(12)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }


      //#����������� ����� sell
      if((CountSell==11) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level11*k*Point))
           {
            
            Print("�������� ������������ ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot12,Ask,3*k,NULL,NULL,"Sun-Lot12-sell(12)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }

      //#����������� ����� buy
      if((CountBuy==12) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level12*k*Point))
           {
          
            Print("�������� ������������ ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot13,Ask,3*k,NULL,NULL,"Sun-Lot13-buy(13)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }


      //#����������� ����� sell
      if((CountSell==12) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level12*k*Point))
           {
            
            Print("�������� ������������ ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot13,Ask,3*k,NULL,NULL,"Sun-Lot13-sell(13)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
              
              }
           }
        }


      //#������������� ����� buy
      if((CountBuy==13) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level13*k*Point))
           {
           
            Print("�������� �������������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot14,Ask,3*k,NULL,NULL,"Sun-Lot14-buy(14)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }


      //#������������� ����� sell
      if((CountSell==13) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level13*k*Point))
           {
           
            Print("�������� �������������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot14,Ask,3*k,NULL,NULL,"Sun-Lot14-sell(14)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }

      //#����������� ����� buy
      if((CountBuy==14) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level14*k*Point))
           {
            
            Print("�������� ������������ ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot15,Ask,3*k,NULL,NULL,"Sun-Lot15-buy(15)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
             
              }
           }
        }


      //#����������� ����� sell
      if((CountSell==14) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level14*k*Point))
           {
            CalculateSellTP();
            Print("�������� ������������ ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot15,Ask,3*k,NULL,NULL,"Sun-Lot15-sell(15)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }

      //#������������ ����� buy
      if((CountBuy==15) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level15*k*Point))
           {
          
            Print("�������� ������������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot16,Ask,3*k,NULL,NULL,"Sun-Lot16-buy(16)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }


      //#������������ ����� sell
      if((CountSell==15) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level15*k*Point))
           {
            
            Print("�������� ������������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot16,Ask,3*k,NULL,NULL,"Sun-Lot16-sell(16)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }
      //#����������� ����� buy
      if((CountBuy==16) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level16*k*Point))
           {
            
            Print("�������� ������������ ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot17,Ask,3*k,NULL,NULL,"Sun-Lot17-buy(17)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }


      //#����������� ����� sell
      if((CountSell==16) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level16*k*Point))
           {
            
            Print("�������� ������������ ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot17,Ask,3*k,NULL,NULL,"Sun-Lot17-sell(17)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
              
              }
           }
        }
      //#������������� ����� buy
      if((CountBuy==17) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level17*k*Point))
           {
            
            Print("�������� �������������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot18,Ask,3*k,NULL,NULL,"Sun-Lot18-buy(18)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }


      //#������������� ����� sell
      if((CountSell==17) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level17*k*Point))
           {
            
            Print("�������� �������������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot18,Ask,3*k,NULL,NULL,"Sun-Lot18-sell(18)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }
      //#������������� ����� buy
      if((CountBuy==18) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level18*k*Point))
           {
            
            Print("�������� �������������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot19,Ask,3*k,NULL,NULL,"Sun-Lot19-buy(19)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }


      //#������������� ����� sell
      if((CountSell==18) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level18*k*Point))
           {
            
            Print("�������� �������������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot19,Ask,3*k,NULL,NULL,"Sun-Lot19-sell(19)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }
      //#��������� ����� buy
      if((CountBuy==19) && (BuyTrade==true))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level19*k*Point))
           {
            
            Print("�������� ���������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot20,Ask,3*k,NULL,NULL,"Sun-Lot20-buy(20)",Magic_Number,0,Blue)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }


      //#��������� ����� sell
      if((CountSell==19) && (SellTrade==true))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level19*k*Point))
           {
      
            Print("�������� ���������� ������ �� �������");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot20,Ask,3*k,NULL,NULL,"Sun-Lot20-sell(20)",Magic_Number,0,Red)<0)
                 {Alert("������ �������� ������� � ",GetLastError()); }
               
              }
           }
        }




        



   return(0);
  }
//#������� ��������� ������� ������� �� �������
double CalculateBuyTP()
  {
   RefreshRates();
   TPB=0;
   int CountB=1;
   double PriceB=Ask;
   for(int ibuyResult=0;ibuyResult<OrdersTotal();ibuyResult++)
     {
      // ��������� ������ ��������, ��� ��� ����� ����� ���� ������ ��� ������ � ��� �����!
      if(OrderSelect(ibuyResult,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) {PriceB=PriceB+OrderOpenPrice();CountB=CountB+1;}
        }
     }
   TPB=PriceB/CountB+TP*Point*k;
   return(TPB);
  }
//#������� ��������� ������� ������� �� �������
double CalculateTotalBuyTP()
  {
TPB=0;
   double BuyLots=0;
   double PriceB=0;
   int CountB=0;
   for(int ibuy2Result=0;ibuy2Result<OrdersTotal();ibuy2Result++)
     {
      // ��������� ������ ��������, ��� ��� ����� ����� ���� ������ ��� ������ � ��� �����!
      if(OrderSelect(ibuy2Result,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) {PriceB=PriceB+OrderOpenPrice()*OrderLots();BuyLots=BuyLots+OrderLots();CountB=CountB+1;}
        }
     }
   if(CountB>1)
     {
      TPB=PriceB/BuyLots+TP*Point*k;
      for(int ibuy3Result=0;ibuy3Result<OrdersTotal();ibuy3Result++)
        { // ��������� ������ ��������, ��� ��� ����� ����� ���� ������ ��� ������ � ��� �����!
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
  

//#������� ��������� ������� ������� �� �������
double CalculateSellTP()
  {
   TPS=0;
   int CountS=1;
   double PriceS=Bid;
   for(int isellResult=0;isellResult<OrdersTotal();isellResult++)
     {
      // ��������� ������ ��������, ��� ��� ����� ����� ���� ������ ��� ������ � ��� �����!
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
      // ��������� ������ ��������, ��� ��� ����� ����� ���� ������ ��� ������ � ��� �����!
      if(OrderSelect(isell2Result,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)) {CountS=CountS+1;PriceS=PriceS+OrderOpenPrice()*OrderLots();SellLots=SellLots+OrderLots();}
        }
     }
   if(CountS>1)
     {
      TPS=PriceS/SellLots-TP*Point*k;
      for(int isell4Result=0;isell4Result<OrdersTotal();isell4Result++)
        { // ��������� ������ ��������, ��� ��� ����� ����� ���� ������ ��� ������ � ��� �����!
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

  
//#����� ���������� ������ �� �������
double SearchLastBuyPrice()
  {
   LastBuyPrice=0;
   for(int ibuySearch=0;ibuySearch<OrdersTotal();ibuySearch++)
     {
      // ��������� ������ ��������, ��� ��� ����� ����� ���� ������ ��� ������ � ��� �����!
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
//#����� ���������� ������ �� �������
double SearchLastSellPrice()
  {
   LastSellPrice=0;
   for(int isellSearch=0;isellSearch<OrdersTotal();isellSearch++)
     {
      // ��������� ������ ��������, ��� ��� ����� ����� ���� ������ ��� ������ � ��� �����!
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
//#����� ���������� ��������� ������ �� �������
double SearchLastLimBuyPrice()
  {
   LastBuyPrice=0;
   for(int ibuySearch1=0;ibuySearch1<OrdersTotal();ibuySearch1++)
     {
      // ��������� ������ ��������, ��� ��� ����� ����� ���� ������ ��� ������ � ��� �����!
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
//#����� ���������� ��������� ������ �� �������
double SearchLastLimSellPrice()
  {
   LastSellPrice=0;
   
   for(int isellSearch1=0;isellSearch1<OrdersTotal();isellSearch1++)
     {
      // ��������� ������ ��������, ��� ��� ����� ����� ���� ������ ��� ������ � ��� �����!
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
//---- ���������� ���������� ������� ���������� ���� ������� ----//
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
