<?php

/**
 * Homepage presenter.
 */
class HomepagePresenter extends BasePresenter {

    private $productModel;
    private $categoryModel;
    private $shopModel;
    
    protected $translator;

    protected function startup() {
        parent::startup();

        $this->productModel = $this->context->productModel;
        $this->categoryModel = $this->context->categoryModel;
        $this->shopModel = $this->context->shopModel;
        /* Kontrola přihlášení
         * 
         * if (!$this->getUser()->isInRole('admin')) {
          $this->redirect('Sign:in');
          } */
    }
    
    public function injectTranslator(NetteTranslator\Gettext $translator) {
        $this->translator = $translator;
    }

  
    
    public function renderDefault() {

         if ($this->getUser()->isInRole('admin')) {
            // load all products
        $this->template->products = $this->productModel->loadCatalogAdmin("");
        } else {
            // load published products
        $this->template->products = $this->productModel->loadCatalog("");
        }
       
        $this->template->category = $this->categoryModel->loadCategory("");
        $this->template->anyVariable = 'any value';
        
    }

}
