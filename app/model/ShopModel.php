<?php

/*
 * Class ShopModel
 * ShopModel is managing all basic Shop informations and settings.
 */

class ShopModel extends Repository {
    /*
     * Load shop info
     * @param ?
     * @param ? example: pozice počátečního znaku
     * @return string 
     */


    /*
     * Load shipping info
     *  @param ?
     * @param ? example: pozice počátečního znaku
     * @return string
     */

    /*
     * Load tax value
     */
    public function getTax()
    {
        $tax = $this->getTable('settings')->where('SettingName',"TAX")->fetch();
        return $tax['Value'];
    }
    
    public function getShopInfo($name)
    {
        if($name != '') {
            $value = $this->getTable('settings')->where('SettingName', $name)->fetch();
            return $value['Value'];
        }
        else {
            return $this->getTable('settings')->fetchPairs('SettingID');
        }
    }
    
     public function getShopInfoPublic() {
         $param = array('Name', 'Description', 'CompanyAddress', 'TAX', 'OrderMail', 'ContactMail', 'ContactPhone', 'InvoicePrefix');
        return $this->getTable('settings')->where('SettingName', $param)->fetchPairs('SettingID'); 
     }
    
    public function setShopInfo($name, $value)
    {
        if ($name == 'CatalogLayout') {
            $update = array(
                'Value' => "layout" . $value
              );
            
        }
        else {
            $update = array(
              'Value' => $value  
            );
        }       
        return $this->getTable('settings')->where('SettingName', $name)->update($update);
    }
    
    public function setShopInfoByID($id, $value)
    {
        
            $update = array(
              'Value' => $value  
            );
       
        return $this->getTable('settings')->where('SettingID', $id)->update($update);
    }

    public function loadStaticText($id){
        if($id==''){
            return $this->getTable('statictext')->order('StaticTextName')->fetchPairs('StaticTextID');
        }
        else{
            return $this->getTable('statictext')->where('StaticTextID',$id)->fetch();
        }
    }
    
    public function loadActiveStaticText($id){
        $activeID = $this->getTable('status')->where('StatusName','Active')->fetch();     
        if($id==''){
            return $this->getTable('statictext')->where('StatusID',$activeID['StatusID'])->order('StaticTextName')->fetchPairs('StaticTextID');
        }
        else{
            return $this->getTable('statictext')->where('StaticTextID',$id);
        }
    }
    
    public function loadPhotoAlbumStatic($postid){
        
        $album = $this->getTable('photoalbum')->where('StaticTextID', $postid)->fetch();
        
        if ($album->PhotoAlbumID == NULL){
            $album->PhotoAlbumID = 1;
        }
        return $album->PhotoAlbumID;
    }
    
    public function insertStaticText($title, $content, $status){
        $insert = array(
            'StaticTextName' => $title,
            'StaticTextContent' => $content,
            'StatusID' => $status
        );
        
        $row = $this->getTable('statictext')->insert($insert);
        return $row->StaticTextID;
    }
    
    public function updateStaticText($id, $type, $content){
        $update = array(
            $type => $content
        );
        
        return $this->getTable('statictext')->where('StaticTextID', $id)->update($update);
    }
    
    public function deleteStaticText($id){
        return $this->getTable('statictext')->where('StaticTextID', $id)->delete();
    }
    /*
     * Load VAT etc
     * @param ?
     * @param ? example: pozice počátečního znaku
     * @return string
     */


    /*
     * ETC...
     */
}