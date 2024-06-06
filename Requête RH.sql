CREATE OR REPLACE VIEW RH AS(
					-- Info nécessaire dans les différentes tables
                    SELECT
						-- products
                           products.productName,
                           products.buyPrice,
                           products.MSRP,
						-- orders
						   date_format(orders.orderdate," %Y/%m/01") as Date,
						-- orderdetails
						   orderdetails.quantityordered,
						   orderdetails.priceEach,
						-- customers
						   customers.customerNumber,
                           customers.customerName,
                           customers.city AS customer_city,
                           customers.state AS customer_state,
                           customers.country AS customer_country,
						-- employees (côté employé)
                           employees.employeeNumber,
                           employees.lastname,
                           employees.firstname,
                           employees.jobtitle AS rang_employee,
						-- employees (côté managers)
						   managers.lastname AS `n+1_lastname`,
                           managers.firstname AS `n+1_firstname`,
                           managers.jobtitle AS rang_manager,
						-- offices  
						   offices.city,
                           offices.addressLine1 AS address,
                           offices.addressLine2 AS complement,
                           offices.state,
                           offices.country
                           
					FROM offices
				-- On join les tables
					-- tables employees
                    LEFT JOIN employees USING(officecode)
                    -- tables employees (pour managers)
                    LEFT JOIN employees AS managers ON managers.employeeNumber = employees.reportsTo
                    -- table clients
                    LEFT JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
                    -- table commandes
                    LEFT JOIN orders USING (customerNumber)
                    -- le détail des commandes
                    LEFT JOIN orderdetails USING (orderNumber)
                    -- table produits
                    LEFT JOIN products USING (productCode)
                    WHERE orders.`status` = "Shipped"
                    );

