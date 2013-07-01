<?php

use Nette\Forms\Form,
    Nette\Utils\Html,
    Nette\Image;
use Kdyby\BootstrapFormRenderer\BootstrapRenderer;

/*
 * class ProductPresenter
 * ProductPresenter rendering product info, and catalog info
 */

class ProductPresenter extends BasePresenter {
    /*
     * @var productModel
     * @var categoryModel;
     */

    private $productModel;
    private $categoryModel;
    private $shopModel;
    private $blogModel;
    private $id;
    private $catId;
    protected $translator;
    private $row;
    private $parameters;
    private $edit;
    private $categoryParam;
    private $filter;

    protected function startup() {
        parent::startup();
        $this->productModel = $this->context->productModel;
        $this->categoryModel = $this->context->categoryModel;
        $this->shopModel = $this->context->shopModel;
        $this->blogModel = $this->context->blogModel;
        
        if ($this->getUser()->isInRole('admin')) {
            $this->edit = $this->getSession('edit');
        }
        /* Kontrola přihlášení
         * 
         * if (!$this->getUser()->isInRole('admin')) {
          $this->redirect('Sign:in');
          } */
    }

    public function injectTranslator(NetteTranslator\Gettext $translator) {
        $this->translator = $translator;
    }

    public function handleDeletePhotoCategory($id, $name) {
        if ($this->getUser()->isInRole('admin')) {


            $imgUrl = $this->context->parameters['wwwDir'] . '/images/category/' . $name;
            if ($imgUrl) {
                unlink($imgUrl);
            }

            $imgUrl = $this->context->parameters['wwwDir'] . '/images/category/150-' . $name;
            if ($imgUrl) {
                unlink($imgUrl);
            }

            $imgUrl = $this->context->parameters['wwwDir'] . '/images/category/20-' . $name;
            if ($imgUrl) {
                unlink($imgUrl);
            }

            $e = 'Photo ' . $name . ' was sucessfully deleted.';

            $this->categoryModel->deletePhoto($id);
            $this->flashMessage($e, 'alert');

            $this->redirect('Product:products', $id);
        }
    }

    protected function createComponentEditControl() {
        if ($this->getUser()->isInRole('admin')) {
            $editControl = new EditControl();
            $editControl->setService($this->productModel);
            $editControl->setTranslator($this->translator);
            $editControl->setParameters($this->productModel->loadParameters($this->row['ProductID']));
            $editControl->setProductID($this->row['ProductID']);
            return $editControl;
        }
    }
    
    

    /*     * **********************************************************************
     *                            Render Products aka CATEGORY
     * @param 
     * ********************************************************************** */

    public function actionProducts($catID) {
        if ($this->getUser()->isInRole('admin')) {
            // load all products
            $row = $this->productModel->loadCatalogAdmin($catID);
        } else {
            // load published products
            $row = $this->productModel->loadCatalog($catID);
        }
        if (!$row) {
            $this->flashMessage('Categry not available', 'alert');
            $this->redirect('Homepage:');
        } else {


            if ($this->getUser()->isInRole('admin')) {


                $row2 = $this->categoryModel->loadCategory($catID);
                
                $this->categoryParam = array('CategoryID' => $catID,
                    'CategoryName' => $row2->CategoryName,
                    'CategoryDescription' => $row2->CategoryDescription,
                    'HigherCategoryID' => $row2->HigherCategoryID);

                $editCategoryForm = $this['editCategoryForm'];
                $addCategoryForm = $this['addCategoryForm'];
                //$addForm = $this['addCategoryForm'];
            }
        }
    }

    public function handleSetCategoryStatus($catID, $categoryStatus) {
        if ($this->getUser()->isInRole('admin')) {
            $this->categoryModel->setCategoryStatus($catID, $categoryStatus);
            $status = $this->categoryModel->getStatusName($categoryStatus);
          //  $status = $categoryStatus;
            $e = 'Category status is now: ' . $status;
            $this->flashMessage($e, 'alert');
            
            if($this->isAjax()) {
                $this->invalidateControl('categoryStatus');
                $this->invalidateControl('script');

            }
            else {
            $this->redirect('this', $catID);
            }
        }
    }
    
    public function handleSetFilter($filter, $sorting) {

            
            $this->filter = 'FinalPrice';
           
            
            if($this->isAjax()) {
                $this->invalidateControl('products');
                $this->invalidateControl('script');

            }
            else {
            $this->redirect('this');
            }
    }

    public function createComponentAddProductForm() {

        if ($this->getUser()->isInRole('admin')) {

            $addProduct = new Nette\Application\UI\Form;
      //      $addProduct->setRenderer(new BootstrapRenderer);
            $addProduct->setTranslator($this->translator);
            $addProduct->addText('name', 'Name:')
                    ->setRequired()
                    ->setAttribute('placeholder', "Enter product name…")
                    ->setAttribute('class', '.span3');
            $addProduct->addText('price', 'Price:')
                    ->setRequired()
                    ->addRule(FORM::FLOAT, 'It has to be a number!')
                    ->setAttribute('class', 'span2');
            $addProduct->addText('amount', 'Amount')
                    ->setDefaultValue('1')
                    ->addRule(FORM::INTEGER, 'It has to be a number!')
                    ->setRequired()
                    ->setAttribute('class', 'span2');
            $addProduct->addHidden('cat', $this->catId);
            $addProduct->addUpload('image', 'Image:')
                    ->addRule(FORM::IMAGE, 'Je podporován pouze soubor JPG, PNG a GIF')
                    ->addRule(FORM::MAX_FILE_SIZE, 'Maximálně 2MB', 6400 * 1024)
                    ->setAttribute('class', 'span2');
            $addProduct->addSubmit('add', 'Add Product')
                    ->setAttribute('class', 'upl btn btn-primary')
                    ->setAttribute('data-loading-text', 'Adding...');
            $addProduct->onSuccess[] = $this->addProductFormSubmitted;
            return $addProduct;
        }
    }

    /*
     * Processing added product
     */

    public function addProductFormSubmitted($form) {
        if ($this->getUser()->isInRole('admin')) {

            $return = $this->productModel->insertProduct(
                    $form->values->name, //Name
                    $form->values->price, 1, //Producer                
                    '11111', //Product Number
                    '', '', //Description
                    '123456', //Ean
                    '122', //QR
                    'rok', //Warranty
                    $form->values->amount, //Pieces
                    $form->values->cat, //CatID
                    '', //Date of avail.                
                    1 //Comment   
            );

            if ($form->values->image->isOK()) {

                $this->productModel->insertPhoto(
                        $form->values->name, $form->values->image->name, $return[1], 1
                );
                $imgUrl = $this->context->parameters['wwwDir'] . '/images/' . $return[1] . '/' . $form->values->image->name;
                $form->values->image->move($imgUrl);

                $image = Image::fromFile($imgUrl);
                $image->resize(null, 300, Image::SHRINK_ONLY);

                $imgUrl = $this->context->parameters['wwwDir'] . '/images/' . $return[1] . '/300-' . $form->values->image->name;
                $image->save($imgUrl);

                $image = Image::fromFile($imgUrl);
                $image->resize(null, 50, Image::SHRINK_ONLY);

                $imgUrl = $this->context->parameters['wwwDir'] . '/images/' . $return[1] . '/50-' . $form->values->image->name;
                $image->save($imgUrl);
            }

            $this->redirect('Product:product', $return[0]);
            
            
        }
    }


    public function handleDeleteProduct($catID, $id) {
        if ($this->getUser()->isInRole('admin')) {
            $this->productModel->deleteProduct($id);
            $this->redirect('this', $catID);
        }
    }

    public function handleArchiveProduct($catID, $id) {
        if ($this->getUser()->isInRole('admin')) {
            $this->productModel->archiveProduct($id);
            $this->redirect('this', $catID);
        }
    }

     public function handleHideProduct($catID, $id) {
        if ($this->getUser()->isInRole('admin')) {
            
            $this->productModel->hideProduct($id);
            
            if($this->isAjax())
            {            
              $this->invalidateControl('products');
              $this->invalidateControl('script');
            }
            
            else {
              $this->redirect('this', $catID);
            }
        }
    }

    public function handleShowProduct($catID, $id) {
        if ($this->getUser()->isInRole('admin')) {
            $this->productModel->showProduct($id);
            
            if($this->presenter->isAjax()) {
                $this->invalidateControl('products');
                $this->invalidateControl('script');
            }
            else {
            $this->redirect('this', $catID);
            }
        }
    }
    


    
    public function handleSetCatalogLayout($catID, $layoutID) {
        if ($this->getUser()->isInRole('admin')) {
            $this->shopModel->setShopInfo('CatalogLayout', $layoutID);
            $this->redirect('this', $catID);
        }
    }

    protected function createComponentEditCategoryForm() {
        if ($this->getUser()->isInRole('admin')) {

            $editForm = new Nette\Application\UI\Form;
            $editForm->setTranslator($this->translator);

            $editForm->setRenderer(new BootstrapRenderer);

            foreach ($this->categoryModel->loadCategoryList() as $id => $category) {
                $categories[$id] = $category->CategoryName;
            }
            $prompt = Html::el('option')->setText("-- No Parent --")->class('prompt');

            $editForm->addText('name', 'Name:')
                    ->setRequired()
                    ->setDefaultValue($this->categoryParam['CategoryName']);
            $editForm->addTextArea('text', 'Description:', 150, 150)
                    ->setDefaultValue($this->categoryParam['CategoryDescription'])
                    ->setRequired()
                    ->setAttribute('class', 'mceEditor');
            $editForm->addSelect('parent', 'Parent Category:', $categories)
                    ->setPrompt($prompt)
                    ->setDefaultValue($this->categoryParam['HigherCategoryID']);
            $editForm->addHidden('id', $this->categoryParam['CategoryID']);
            $editForm->addSubmit('edit', 'Save description')
                    ->setAttribute('class', 'upl btn btn-primary')
                    ->setAttribute('data-loading-text', 'Saving...');
            $editForm->onSubmit('tinyMCE.triggerSave()');
            $editForm->onSuccess[] = $this->editCategoryFormSubmitted;
            return $editForm;
        }
    }

    public function editCategoryFormSubmitted($form) {
        if ($this->getUser()->isInRole('admin')) {

            $this->categoryModel->updateCategory($form->values->id, $form->values->name, $form->values->text, $form->values->parent, 1);

            if (!$this->isAjax()) {
                $this->redirect('this');
            } else {
               // $form->setValues(array(), TRUE);
                $this->invalidateControl('categoryInfoForm');
                $this->invalidateControl('categoryInfo');
            }
        }
    }
    
    public function handleEditCatTitle($catid) {
        if($this->getUser()->isInRole('admin')){
            
          $this->invalidateControl('bread');
          
            if($this->isAjax()){
               //$name = $_POST['id'];
               $content = $_POST['value'];
               $this->categoryModel->updateCategory($catid, $content);
               
           }
           if(!$this->isControlInvalid('CatTitle')){
               $this->payload->edit = $content;
               $this->sendPayload();
               $this->invalidateControl('menu');  
               $this->invalidateControl('bread');
               $this->invalidateControl('CatTitle');
           }
           else {
            $this->redirect('this');
           }
       }
    }
    
    
    
    public function handleEditProdTitle($prodid){
        if($this->getUser()->isInRole('admin')){
            if($this->isAjax()){            
                $content = $_POST['value'];
                $this->productModel->updateProduct($prodid, 'ProductName', $content);
            }
            if(!$this->isControlInvalid('editProdTitle')){
                $this->payload->edit = $content;
                $this->sendPayload();
                $this->invalidateControl('editProdTitle');
            }
            else {
             $this->redirect('this');
            }

        }
    }

    public function handleEditProdDescription($prodid) {
        if($this->getUser()->isInRole('admin')){
            if($this->isAjax()){            
                $content = $_POST['value'];
                $this->productModel->updateProduct($prodid, 'ProductDescription', $content);
            }
            if(!$this->isControlInvalid('editProdDescription')){
                $this->payload->edit = $content;
                $this->sendPayload();
                $this->invalidateControl('editProdDescription');
            }
            else {
             $this->redirect('this');
            }
        }
    }
    
    public function handleEditProdShort($prodid) {
        if($this->getUser()->isInRole('admin')){
            if($this->isAjax()){            
                $content = $_POST['value'];
                $this->productModel->updateProduct($prodid, 'ProductShort', $content);
            }
            if(!$this->isControlInvalid('editProdShort')){
                $this->payload->edit = $content;
                $this->sendPayload();
                $this->invalidateControl('editProdShort');
            }
            else {
             $this->redirect('this');
            }
        }
    }
    
    public function handleEditProdPrice($prodid, $sellingprice, $sale) {
        if($this->getUser()->isInRole('admin')){
            if($this->isAjax()){            
                $content = $_POST['value'];

                if ($sale == 0) {
                $this->productModel->updatePrice($prodid, $content, $sale);    
                }
                else {
                  $sale = $sellingprice - $content;
                $this->productModel->updatePrice($prodid, $sellingprice, $sale); 
                }
            }
            if(!$this->isControlInvalid('prodPrice')){
                $this->payload->edit = $content;
                $this->sendPayload();
            }
            else {
             $this->redirect('this');
            }
        }
    }
    
    public function handleSetSale($prodid, $amount, $type){
        if ($this->getUser()->isInRole('admin')) {            
            $this->productModel->updateSale($prodid, $amount, $type);
            if($this->isAjax()) {
                $this->invalidateControl('prodPrice');
            }
            else{
              $this->redirect('this');  
            }
        }
    }

    public function handleEditProdAmount($prodid) {        
        if($this->getUser()->isInRole('admin')){ 
            if($this->isAjax())
            {            
                $content = $_POST['value'];

                $this->productModel->updateProduct($prodid, 'PiecesAvailable', $content);
            }
            if(!$this->isControlInvalid('editProdAmount'))
            {
                $this->payload->edit = $content;
                $this->sendPayload();
                $this->invalidateControl('editProdAmount');
            }
            else {
             $this->redirect('this');
            }
        }
    }
    
    public function handleSetProductCategory($id, $catid) {
        if($this->getUser()->isInRole('admin')){ 
            if($this->isAjax())
            {            
                $this->productModel->updateProduct($id, 'CategoryID', $catid);
                $this->invalidateControl('productCategory');
                $this->invalidateControl('bread');
                $this->invalidateControl('script');

            }
            else {
             $this->redirect('this');
            }
        }
    }

    public function handleSetProductProducer($id, $producerid) {
        if($this->getUser()->isInRole('admin')){ 
            if($this->isAjax())
            {            
                $this->productModel->updateProduct($id, 'ProducerID', $producerid);
                $this->invalidateControl('productProducer');
                $this->invalidateControl('script');

            }
            else {
             $this->redirect('this');
            }
        }
    }
 


    public function handleEditCatDescription($catid) {
        if($this->getUser()->isInRole('admin')){
            if($this->isAjax()){            
               $content = $_POST['value']; //odesílaná nová hodnota
               $this->categoryModel->updateCategoryDesc($catid, $content);

           }
           if(!$this->isControlInvalid('editDescription')){           
               $this->payload->edit = $content; //zaslání nové hodnoty do šablony
               $this->sendPayload();
               $this->invalidateControl('menu');       
               $this->invalidateControl('editDescription'); //invalidace snipetu
           }
           else {
            $this->redirect('this');
           }

       }
    }
    
    public function handleSetParentCategory($catid, $parentid) {
        if($this->getUser()->isInRole('admin')){
        
            $this->categoryModel->updateCategoryParent($catid, $parentid);
                
            if($this->isAjax())
           {            
                $this->invalidateControl('parentCategory');
                $this->invalidateControl('bread');
                $this->invalidateControl('menu');
                $this->invalidateControl('script');

           }
           else {
            $this->redirect('this');
           }

       }
    }

    protected function createComponentAddCategoryForm() {
        if ($this->getUser()->isInRole('admin')) {

            $addForm = new Nette\Application\UI\Form;
            $addForm->setTranslator($this->translator);
            //$editForm->setRenderer(new BootstrapRenderer);

            foreach ($this->categoryModel->loadCategoryList() as $id => $category) {
                $categories[$id] = $category->CategoryName;
            }
            $prompt = Html::el('option')->setText("-- No Parent --")->class('prompt');

            $addForm->addText('name', 'Name:')
                    ->setRequired();
            $addForm->addTextArea('text', 'Description:', 150, 150)
                    ->setAttribute('class', 'mceEditor');
            $addForm->addSelect('parent', 'Parent Category:', $categories)
                    ->setPrompt($prompt);
            $addForm->addUpload('image', 'Image:')
                    ->addCondition(FORM::FILLED)
                    ->addRule(FORM::IMAGE, 'Je podporován pouze soubor JPG, PNG a GIF')
                    ->addRule(FORM::MAX_FILE_SIZE, 'Maximálně 2MB', 6400 * 1024);
            $addForm->addSubmit('edit', 'Create Category')
                    ->setAttribute('class', 'upl btn btn-primary')
                    ->setAttribute('data-loading-text', 'Creating...');
            $addForm->onSubmit('tinyMCE.triggerSave()');
            $addForm->onSuccess[] = $this->addCategoryFormSubmitted;
            return $addForm;
        }
    }

    public function addCategoryFormSubmitted($form) {
        if ($this->getUser()->isInRole('admin')) {

            if ($form->values->image->isOK()) {

                $imgUrl = $this->context->parameters['wwwDir'] . '/images/category/' . $form->values->image->name;
                $form->values->image->move($imgUrl);

                $image = Image::fromFile($imgUrl);
                $image->resize(null, 150, Image::SHRINK_ONLY);

                $imgUrl = $this->context->parameters['wwwDir'] . '/images/category/150-' . $form->values->image->name;
                $image->save($imgUrl);

                $image = Image::fromFile($imgUrl);
                $image->resize(null, 20, Image::SHRINK_ONLY);

                $imgUrl = $this->context->parameters['wwwDir'] . '/images/category/20-' . $form->values->image->name;
                $image->save($imgUrl);

                $row = $this->categoryModel->createCategory($form->values->name, $form->values->text, $form->values->parent, $form->values->image->name);
            } else {
                $row = $this->categoryModel->createCategory($form->values->name, $form->values->text, $form->values->parent);
            }
            $this->redirect('Product:products', $row);
        }
    }

    protected function createComponentDeleteCategoryForm() {
        if ($this->getUser()->isInRole('admin')) {

            $deleteForm = new Nette\Application\UI\Form;
            $deleteForm->setTranslator($this->translator);
            $deleteForm->setRenderer(new BootstrapRenderer);

            foreach ($this->categoryModel->loadCategoryList() as $id => $category) {
                $categories[$id] = $category->CategoryName;
            }
            $prompt = Html::el('option')->setText("-- No Parent --")->class('prompt');

            $deleteForm->addHidden('id', $this->categoryParam['CategoryID']);
            $deleteForm->addSelect('parent', 'Move products to category:', $categories)
                    ->setPrompt($prompt)
                    ->setDefaultValue($this->categoryParam['HigherCategoryID'])
                    ->setRequired();
            $deleteForm->addSubmit('edit', 'Delete Category')
                    ->setAttribute('class', 'upl btn btn-danger')
                    ->setAttribute('data-loading-text', 'Deleting...');
            $deleteForm->onSubmit('tinyMCE.triggerSave()');
            $deleteForm->onSuccess[] = $this->deleteCategoryFormSubmitted;
            return $deleteForm;
        }
    }

    public function deleteCategoryFormSubmitted($form) {
        if ($this->getUser()->isInRole('admin')) {

            foreach ($this->productModel->loadCatalog($form->values->id) as $product) {
                $this->productModel->updateProduct($product->ProductID, 'CategoryID', $form->values->parent);
            }

            $this->categoryModel->deleteCategory($form->values->id);
            $this->redirect('Product:products', $form->values->parent);
        }
    }

    public function renderProducts($catID) {

        $this->catId = $catID;

        if ($this->getUser()->isInRole('admin')) {
            // load all products
            $this->template->products = $this->productModel->loadCatalogAdmin($catID, $this->filter);
            
        } else {
            // load published products
            $this->template->products = $this->productModel->loadCatalog($catID, $this->filter);
        }

        $this->template->categories = $this->categoryModel->loadCategoryList();
        $this->template->category = $this->categoryModel->loadCategory($catID);
    }

    
    public function renderProductsBrand($prodID) {

        $this->template->products = $this->productModel->loadCatalogBrand($prodID);

        $this->template->producer = $this->productModel->loadProducer($prodID);
    }

    /*     * *******************************************************************
     *                      RENDER PRODUCT
     * rendering Product with full info
     * ********************************************************************* */

    public function actionProduct($id) {
        $row = $this->productModel->loadProduct($id);
        if (!$row) {
            $this->flashMessage('Product not available', 'alert');
            $this->redirect('Homepage:');
        } else {
            $this->parameters = $this->productModel->loadParameters($id);

            if ($this->getUser()->isInRole('admin')) {
                $this->row = array('ProductID' => $row->ProductID,
                    'ProductName' => $row->ProductName,
                    'ProducerID' => $row->ProducerID,
                    'PhotoAlbumID' => $row->PhotoAlbumID,
                    'ProductDescription' => $row->ProductDescription,
                    'SellingPrice' => $row->SellingPrice,
                    'SALE' => $row->SALE,
                    'CategoryID' => $row->CategoryID,
                    'PiecesAvailable' => $row->PiecesAvailable);

                $editForm = $this['editParamForm'];
                $addForm = $this['addParamForm'];
                $docsForm = $this['addDocumentationForm'];
                $priceForm = $this['editPriceForm'];
                // $this['editPriceForm']['price'] = $this->row['SellingPrice'];
            }
        }
    }


    


    public function createComponentAddPhotoForm() {
        if ($this->getUser()->isInRole('admin')) {
            $addPhoto = new Nette\Application\UI\Form;
           // $addPhoto->setRenderer(new BootstrapRenderer);
            $addPhoto->setTranslator($this->translator);
            $addPhoto->addHidden('name', 'name');
            $addPhoto->addHidden('albumID', $this->row['PhotoAlbumID']);
            $addPhoto->addUpload('image', 'Photo:')
                    ->addRule(FORM::IMAGE, 'Je podporován pouze soubor JPG, PNG a GIF')
                    ->addRule(FORM::MAX_FILE_SIZE, 'Maximálně 2MB', 6400 * 1024)
                    ->setAttribute('class', 'span3');
            $addPhoto->addSubmit('add', 'Add Photo')
                    ->setAttribute('class', 'btn-primary upl span2')
                    ->setAttribute('data-loading-text', 'Uploading...');
            $addPhoto->onSuccess[] = $this->addProductPhotoFormSubmitted;
            return $addPhoto;
        }
    }

  


    public function addProductPhotoFormSubmitted($form) {
        if ($this->getUser()->isInRole('admin')) {
            if ($form->values->image->isOK()) {

                $this->productModel->insertPhoto(
                        $form->values->name, $form->values->image->name, $form->values->albumID
                );
                $imgUrl = $this->context->parameters['wwwDir'] . '/images/' . $form->values->albumID . '/' . $form->values->image->name;
                $form->values->image->move($imgUrl);

                $image = Image::fromFile($imgUrl);
                $image->resize(null, 300, Image::SHRINK_ONLY);

                $imgUrl = $this->context->parameters['wwwDir'] . '/images/' . $form->values->albumID . '/300-' . $form->values->image->name;
                $image->save($imgUrl);

                $image = Image::fromFile($imgUrl);
                $image->resize(null, 50, Image::SHRINK_ONLY);

                $imgUrl = $this->context->parameters['wwwDir'] . '/images/' . $form->values->albumID . '/50-' . $form->values->image->name;
                $image->save($imgUrl);

                $e = HTML::el('span', ' Photo ' . $form->values->image->name . ' was sucessfully uploaded');
                $ico = HTML::el('i')->class('icon-ok-sign left');
                $e->insert(0, $ico);
                $this->flashMessage($e, 'alert');
            }

            $this->redirect('this');
        }
    }

    public function createComponentAddCategoryPhotoForm() {
        if ($this->getUser()->isInRole('admin')) {
            $addPhoto = new Nette\Application\UI\Form;
            $addPhoto->setRenderer(new BootstrapRenderer);
            $addPhoto->setTranslator($this->translator);
            $addPhoto->addHidden('categoryID', $this->categoryParam['CategoryID']);
            $addPhoto->addUpload('image', 'Photo:')
                    ->addRule(FORM::IMAGE, 'Je podporován pouze soubor JPG, PNG a GIF')
                    ->addRule(FORM::MAX_FILE_SIZE, 'Maximálně 2MB', 6400 * 1024);
            $addPhoto->addSubmit('add', 'Add Photo')
                    ->setAttribute('class', 'btn-primary upl')
                    ->setAttribute('data-loading-text', 'Uploading...');
            $addPhoto->onSuccess[] = $this->addCategoryPhotoFormSubmitted;
            return $addPhoto;
        }
    }

    /*
     * Adding submit form for adding photos
     */

    public function addCategoryPhotoFormSubmitted($form) {
        if ($this->getUser()->isInRole('admin')) {
            if ($form->values->image->isOK()) {


                $imgUrl = $this->context->parameters['wwwDir'] . '/images/category/' . $form->values->image->name;
                $form->values->image->move($imgUrl);

                $image = Image::fromFile($imgUrl);
                $image->resize(null, 150, Image::SHRINK_ONLY);

                $imgUrl = $this->context->parameters['wwwDir'] . '/images/category/150-' . $form->values->image->name;
                $image->save($imgUrl);

                $image = Image::fromFile($imgUrl);
                $image->resize(null, 20, Image::SHRINK_ONLY);

                $imgUrl = $this->context->parameters['wwwDir'] . '/images/category/20-' . $form->values->image->name;
                $image->save($imgUrl);

                $this->categoryModel->addPhoto($form->values->categoryID, $form->values->image->name);

                $e = HTML::el('span', ' Photo ' . $form->values->image->name . ' was sucessfully uploaded');
                $ico = HTML::el('i')->class('icon-ok-sign left');
                $e->insert(0, $ico);
                $this->flashMessage($e, 'alert');
            }

            $this->redirect('this');
        }
    }

    protected function createComponentEditPriceForm() {
        if ($this->getUser()->isInRole('admin')) {

            $priceForm = new Nette\Application\UI\Form;
            $priceForm->setTranslator($this->translator);
            $priceForm->setRenderer(new BootstrapRenderer);
            $priceForm->addText('price', 'Price:')
                    ->setDefaultValue($this->row['SellingPrice'])
                    ->setRequired()
                    ->addRule(FORM::FLOAT, 'This has to be a number.');
            $priceForm->addText('discount', 'Discount:')
                    ->setDefaultValue($this->row['SALE'])
                    ->addRule(FORM::FLOAT, 'This has to be a number.')
                    ->addRule(FORM::RANGE, 'It should be less then price', array(0, $this->row['SellingPrice']));
            $priceForm->addHidden('id', $this->row['ProductID']);
            $priceForm->addSubmit('edit', 'Save price')
                    ->setAttribute('class', 'btn btn-primary')
                    ->setHtmlId('priceSave')
                    ->setAttribute('data-loading-text', 'Saving...');
            $priceForm->onSuccess[] = $this->editPriceFormSubmitted;
            return $priceForm;
        }
    }

    public function editPriceFormSubmitted($form) {
        if ($this->getUser()->isInRole('admin')) {

            
            $this->productModel->updatePrice($form->values->id, $form->values->price, $form->values->discount);
            if($this->isAjax()){
                
                $this->invalidateControl('prodPrice');
            }
            else {
            
            $this->redirect('this');
            }
        }
    }

    protected function createComponentEditParamForm() {
        if ($this->getUser()->isInRole('admin')) {
            $editForm = new Nette\Application\UI\Form;
            $editForm->setTranslator($this->translator);
            $editForm->setRenderer(new BootstrapRenderer());

            foreach ($this->productModel->loadUnit('') as $id => $unit) {
                $units[$id] = $unit->UnitShort;
            }
            $prompt = Html::el('option')->setText("-- Select --")->class('prompt');

            foreach ($this->parameters as $id => $param) {
                $editForm->addGroup($param->AttribName);
                $editForm->addText($param->ParameterID, 'Value:')
                        ->setDefaultValue($param->Val);
                $editForm->addSelect('unit' . $param->ParameterID, 'Select unit:', $units, 1, 4)
                        ->setPrompt($prompt)
                        ->setDefaultValue($param->UnitID);
            }

            $editForm->addSubmit('edit', 'Save Specs')
                    ->setAttribute('class', 'upl-edit btn btn-primary')
                    ->setAttribute('data-loading-text', 'Saving...');
            $editForm->onSuccess[] = $this->editParamFormSubmitted;
            return $editForm;
        }
    }

    public function editParamFormSubmitted($form) {
        if ($this->getUser()->isInRole('admin')) {
            $prevID = null;
            foreach ($form->values as $id => $value) {

                if ($id == 'unit' . $prevID) {
                    $this->productModel->updateParameter($prevID, $prevVal, $value);
                }
                $prevID = $id;
                $prevVal = $value;
            }

            $this->redirect('this');
        }
    }

    protected function createComponentAddParamForm() {
        if ($this->getUser()->isInRole('admin')) {
            $addForm = new Nette\Application\UI\Form;
            $addForm->setTranslator($this->translator);
            $addForm->setRenderer(new BootstrapRenderer);

            foreach ($this->productModel->loadAttribute('') as $id => $param) {
                $options[$id] = $param->AttribName;
            }

            foreach ($this->productModel->loadUnit('') as $id => $unit) {
                $units[$id] = $unit->UnitShort;
            }

            $addForm->addGroup('Select one of already created:');
            $prompt = Html::el('option')->setText("-- Select --")->class('prompt');
            $addForm->addSelect('options', 'Select spec:', $options)
                    ->setPrompt($prompt);
            $addForm->addText('paramValue', 'Enter Value:');
            $addForm->addSelect('unit', 'Select unit:', $units)
                    ->setPrompt($prompt);
            $addForm->addGroup('Create a new one:');
            $addForm->addText('newParam', 'Name of new Spec:');
            $addForm->addSelect('unit2', 'Select unit:', $units)
                    ->setPrompt($prompt);
            $addForm->addHidden('productID', $this->row['ProductID']);
            $addForm->addSubmit('edit', 'Add Spec')
                    ->setAttribute('class', 'upl-add btn btn-primary')
                    ->setAttribute('data-loading-text', 'Adding...');
            $addForm->onSuccess[] = $this->addParamFormSubmitted;

            return $addForm;
        }
    }

    public function addParamFormSubmitted($form) {
        if ($this->getUser()->isInRole('admin')) {

            if ($form->values->options != '') {
                $this->productModel->insertParameter($form->values->productID, $form->values->options, $form->values->paramValue, $form->values->unit);
            }
            if ($form->values->newParam) {
                $attrib = $this->productModel->insertAttribute($form->values->newParam);
                $this->productModel->insertParameter($form->values->productID, $attrib, NULL, $form->values->unit);
            }
            $this->edit->param = 1;
            $this->redirect('this');
        }
    }

    protected function createComponentDeleteParamForm() {
        if ($this->getUser()->isInRole('admin')) {
            $editForm = new Nette\Application\UI\Form;
            $editForm->setTranslator($this->translator);
            $editForm->setRenderer(new BootstrapRenderer());
            foreach ($this->parameters as $id => $param) {
                $editForm->addCheckbox($param->ParameterID, $param->AttribName)
                        ->setDefaultValue(FALSE);
            }

            $editForm->addSubmit('delete', 'Delete Specs')
                    ->setAttribute('class', 'upl-del btn btn-primary')
                    ->setAttribute('data-loading-text', 'Deleting...');
            $editForm->onSuccess[] = $this->deleteParamFormSubmitted;
            return $editForm;
        }
    }

    public function deleteParamFormSubmitted($form) {
        if ($this->getUser()->isInRole('admin')) {

            foreach ($form->values as $id => $value) {
                if ($value == TRUE) {
                    $this->productModel->deleteParameter($id);
                }
            }
            $this->redirect('this');
        }
    }

    public function handleDeleteDocument($product, $id) {
        if ($this->getUser()->isInRole('admin')) {
            $row = $this->productModel->loadDocumentation($product)->fetch();
            if (!$row) {
                $this->flashMessage('There is no Docs to delete', 'alert');
            } else {


                $docUrl = $this->context->parameters['wwwDir'] . '/docs/' . $row->ProductID . '/' . $row->DocumentURL;
                if ($docUrl) {
                    unlink($docUrl);
                }

                $e = 'Doc ' . $row->DocumentName . ' was sucessfully deleted.';

                $this->productModel->deleteDocumentation($id);
                $this->flashMessage($e, 'alert');
            }

            $this->redirect('Product:product', $product);
        }
    }

    /*
     * Adding product photos
     */

    protected function createComponentAddDocumentationForm() {
        if ($this->getUser()->isInRole('admin')) {
            $addPhoto = new Nette\Application\UI\Form;
            $addPhoto->setRenderer(new BootstrapRenderer);
            $addPhoto->setTranslator($this->translator);
            $addPhoto->addText('name', 'Name:');
            $addPhoto->addHidden('productid', $this->row['ProductID']);
            $addPhoto->addUpload('doc', 'Document:')
                    ->addRule(FORM::MAX_FILE_SIZE, 'Maximálně 2MB', 6400 * 1024);
            $addPhoto->addText('desc', 'Description', 20, 100);
            $addPhoto->addSubmit('add', 'Add Document')
                    ->setAttribute('class', 'btn-primary upl')
                    ->setAttribute('data-loading-text', 'Uploading...');
            $addPhoto->onSuccess[] = $this->addDocumentationFormSubmitted;
            return $addPhoto;
        }
    }

    /*
     * Adding submit form for adding photos
    */ 

    public function addDocumentationFormSubmitted($form) {
        if ($this->getUser()->isInRole('admin')) {
            if ($form->values->doc->isOK()) {

                $this->productModel->insertDocumentation(
                        $form->values->name, $form->values->doc->name, $form->values->productid, $form->values->desc
                );
                $imgUrl = $this->context->parameters['wwwDir'] . '/docs/' . $form->values->productid . '/' . $form->values->doc->name;
                $form->values->doc->move($imgUrl);

                $e = HTML::el('span', ' Docs ' . $form->values->doc->name . ' was sucessfully uploaded');
                $ico = HTML::el('i')->class('icon-ok-sign left');
                $e->insert(0, $ico);
                $this->flashMessage($e, 'alert');
            }

            $this->redirect('this');
        }
    }

    
    protected function createComponentProduct() {
        $productControl = new productControl();
        $productControl->setTranslator($this->translator);
        $productControl->setProduct($this->productModel);
        $productControl->setCategory($this->categoryModel);
        $productControl->setBlog($this->blogModel);
        $productControl->setRow($this->row);
        return $productControl;
    }

    public function renderProduct($id) {

       if ($this->presenter->getUser()->isInRole('admin')) { 
            if ($this->edit->param != NULL) {
                $this->template->attr = 1;
                $this->edit->param = NULL;
            } else {
                $this->template->attr = 0;
            }
            
            $this->template->categories = $this->categoryModel->loadCategoryList();
            $this->template->producers = $this->productModel->loadProducers();
       }
        
        $this->template->product = $this->productModel->loadProduct($id);
        $this->template->photo = $this->productModel->loadCoverPhoto($id);
        $this->template->album = $this->productModel->loadPhotoAlbum($id);
        $this->template->parameter = $this->productModel->loadParameters($id);
      
        $this->template->docs = $this->productModel->loadDocumentation($id)->fetchPairs('DocumentID');

    }

    /*     * ***********************************************************************
     *                      Render Default
     * 
     * ********************************************************************** */

    public function renderDefault() {
        $this->redirect('Products');
        $this->template->anyVariable = 'any value';
    }

}

