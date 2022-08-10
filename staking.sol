// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Ecommerce{

    address payable manger;

    bool destroyed; // false

    constructor() {
        manger = payable(msg.sender);
    }

    modifier Notdestroyed() {
        require(!destroyed, "does not exist");
        _;
    }

   require(msg.sender == manger, "not you")

    struct product{
        string name;
        string des; 
        uint price;
        address buyer;
        address seller;
        uint productId;
        bool delivered;
    } 

    event registered(address indexed seller, uint price, string name );
    
    product[] public products;
    uint id = 1;
    
    function RegisterProduct(string memory _name, string memory _des, uint _price) destroyed external {
        require(_price > 0 , "price must be greater than zero");
        product memory tempProduct;
        tempProduct.name = _name;
        tempProduct.des = _des;
        tempProduct.price = _price * 10**18;
        tempProduct.seller = payable(msg.sender);
        tempProduct.productId = id;
        products.push(tempProduct);
        id++;

        emit registered(msg.sender, _price , _name);
    }    
  
    function buy(uint _productId) external destroyed payable {
        require(products[_productId - 1].price == msg.value, "not enough money for this product");
        require(products[_productId - 1].seller != msg.sender, "not allowed to buy your product");
        products[_productId - 1].buyer = msg.sender;
    }
    
    function delivered(uint _productId) external destroyed returns(bool){
        require(products[_productId -1].seller == msg.sender, "only seller can access this");
        products[_productId - 1].delivered = true;
        (bool sent,) = payable(msg.sender).call{value: products[_productId - 1].price}(""); 
        return sent;
    } 

    function balance() external view destroyed returns(uint){
        return address(this).balance;
    } 

    
    function retPr() external view destroyed returns(product[] memory){
        return products;
    }

    // function destroy() external {
    //     require(msg.sender == manger, "not manger");
    //     selfdestruct(manger);
    // }

    function destroing() external returns(bool){
        require(msg.sender == manger, "not allowed");
        (bool sent,) = payable(manger).call{value: address(this).balance}("");
        destroy = true;
        return sent;
    }

    fallback() external payable {
        payable(msg.sender).transfer(msg.value);
       
    }
}  