<?php

/*
 * Class OrderModel
 * OrderModel is used for managing orders.
 * CRUD operations.
 */

class OrderModel extends Repository {
    /*
     * Show orderdetails
     * @param ?
     * @param ? example: pozice počátečního znaku
     * @return string 
     */
    public function loadOrderDetails($id){
        if($id==''){
            return $this->getTable('orderdetails')->fetch();
        }
        else
        {
            return $this->getTable('orderdetails')->where('orderID',$id)->fetch();
        }
    }
      
    /*
     * Show all orders
     * @param ?
     * @param ? example: pozice počátečního znaku
     * @return string 
     */  
    public function loadOrders(){     
        return $this->getTable('orders')->select('orders.*,delivery.*,payment.*,users.*,status.*')
                ->order('orders.OrderID DESC')->fetchPairs('OrderID');
    }
    
    /*
     * Show one order
     * @param ?
     * @param ? example: pozice počátečního znaku
     * @return string 
     */
    public function loadOrder($id){
        return $this->getTable('orders')->select('orders.*,payment.*,delivery.*,users.*,status.*')->where('orders.OrderID',$id)->fetch();
    }
    
    public function loadOrderAddress($id){
        $user = $this->getTable('orders')->select('orders.UsersID')->where('OrderID',$id);
        
        return $this->getTable('address')->where('UsersID',$user)->fetch();
    }
    /*
     * Show product in order
     */
    public function loadOrderProduct($id){
        //return $this->getTable('orderdetails')->select('orderdetails.* ,product.*')
          //      ->where('orderdetails.OrderID',$id);
          return $this->getDB()->query('SELECT * FROM orderdetails 
              JOIN product ON orderdetails.ProductID=product.ProductID 
              JOIN photoalbum ON product.ProductID=photoalbum.ProductID 
              JOIN photo ON photoalbum.PhotoAlbumID=photo.PhotoAlbumID 
              WHERE photo.CoverPhoto="1" and orderdetails.OrderID=?',$id);
    }
    /*
     * Check and save order
     * @param ?
     * @param ? 
     * @return string
     */
    public function insertOrder($user, $price, $delivery, $payment, $note)
    {                 
            $today = date("Y-m-d");
            
            $deliveryprice = $this->loadDeliveryPrice($delivery);            
            $paymentprice = $this->loadPaymentPrice($payment);
            $deliverypaymentprice = $deliveryprice + $paymentprice;
            
            $tax1 = $this->getTable('settings')->select('Value')->where('Name',"TAX")->fetch();
            $tax = $tax1['Value'];
            //settype($tax, 'float');
            $finaltax = $price * ($tax / 100);
            
            $totalprice = $price + $finaltax;

            $insert =  array(
                 //'OrderID' => $id, //automaticky!
                //'StatusID' => $status, //automaticky!
                'UsersID' => $user,  //nepraktické, aby se pouzivalo "novak", "admin"
                'ProductsPrice' => $price,
                'DeliveryPaymentPrice' => $deliverypaymentprice,
                'TaxPrice' => $finaltax, //
                'TotalPrice' => $totalprice,
                'DateCreated' => $today,  //automaticky presenter
                'DateOfLastChange' => $today, //pri vytvoreni stejne jako created
                //'DateFinished' => '', //? spolu s předchozí řešit až v administraci obj.
                'DeliveryID' => $delivery,
                'PaymentID' => $payment,
                'Note' => $note,
                'IP' => NULL,
                'SessionID' => NULL
            );
            $lastID = $this->getTable('orders')->insert($insert);
            return $lastID['OrderID'];
    }
    
    /*
     * Insert order details
     */
    public function insertOrderDetails($orderid, $product, $quantity, $unitprice) 
    {
        $insert = array(
          //  'OrderDetailsID' => $id,
            'OrderID' => $orderid,
            'ProductID' => $product,
            'Quantity' => $quantity,
            'UnitPrice' => $unitprice
        );    
        return $this->getTable('orderdetails')->insert($insert);
    }
    
    /*
     * Load order statuses
     */
    public function loadStatus($id)
    {
        if($id==''){
            return $this->getTable('orderstatus')->order('StatusProgress')->fetchPairs('OrderStatusID');
        }
        else
        {
            return $this->getTable('orderstatus')->where('OrderStatusID',$id);
        }
    }
    
    /*
     * Insert new order status
     */
    public function insertStatus($id,$name,$description)
    {
        $insert = array(
            'OrderStatusID' => $id,
            'StatusName' => $name,
            'StatusDescription' => $description
        );
        
        return $this->getTable('orderstatus')->insert($insert);
    }

    /*
     * Load payment  for order
     */
    public function loadPayment($id){
        if($id==''){
            return $this->getTable('payment')->fetchPairs('PaymentID');
        }
        else
        {
            return $this->getTable('payment')->where('PaymentID',$id);
        }
    }
    
    public function loadPaymentPrice($id){
        //return $this->getTable('payment')->select('PaymentPrice')->where('PaymentID',$id)->fetch();        
        $payment = $this->getTable('payment')->select('PaymentPrice')->where('PaymentID',$id)->fetch();
        return $payment['PaymentPrice'];
    }

    /*
     * Insert new payment method
     */
    public function insertPayment($id,$name,$price)
    {
        $insert = array(
            'PaymentID' => $id,
            'PaymentName' => $name,
            'PaymentPrice' => $price
        );
                
        return $this->getTable('payment')->insert($insert);
    }
    
    /*
     * Load delivery 
     */
    public function loadDelivery($id)
    {
        if($id==''){
            return $this->getTable('delivery')->fetchPairs('DeliveryID');
        }
        else
        {
            return $this->getTable('delivery')->where('DeliveryID',$id)->fetch();
        }
    }
    
    public function loadDeliveryPrice($id){
        //return $this->getTable('delivery')->select('DeliveryPrice')->where('DeliveryID',$id)->fetch();
        $delivery = $this->getTable('delivery')->select('DeliveryPrice')->where('DeliveryID',$id)->fetch();
        return $delivery['DeliveryPrice'];
    }
    
    /*
     * Insert new delivery 
     */
    public function insertDelivery($name,$price,$description=NULL,$free=NULL)
    {
        $insert = array(
            'DeliveryID' => NULL,
            'DeliveryName' => $name,
            'DeliveryDescription' => $description,
            'DeliveryPrice' => $price,
            'FreeFromPrice' => $free
        );
        
        return $this->getTable('delivery')->insert($insert);
    }
    
    public function updateDelivery($id, $name, $description=NULL, $price, $free=NULL)
    {
        $update = array(
            
            'DeliveryName' => $name,
            'DeliveryDescription' => $description,
            'DeliveryPrice' => $price,
            'FreeFromPrice' => $free
        );
        
        return $this->getTable('delivery')->where('DeliveryID', $id)->update($update);
    }
    
    public function deleteDelivery($id) {
        
        return $this->getTable('delivery')->where('DeliveryID',$id)->delete();
    }
    
    

    public function countOrder()  {
        return $this->getTable('orders')->count();
    }
    
    public function countOrderDetail()
    {
        return $this->getTable('orderdetails')->count();
    }
    
    public function countDelivery()
    {
        return $this->getTable('delivery')->count();
    }
    
    public function setStatus($orderid,$statusid){
        $update = array(
            'StatusID' => $statusid
        );
        
        return $this->getTable('Orders')->where('OrderID',$orderid)->update($update);
    }
    /*
     * Change order status
     * @param ?
     * @param ? example: pozice počátečního znaku
     * @return string
     */
    

    /*
     * Generate emails
     * @param ?
     * @param ? example: pozice počátečního znaku
     * @return string
     */
    
   
    
   
}


