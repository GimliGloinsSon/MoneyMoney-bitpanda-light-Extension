-- Inofficial Bitpanda-Light Extension (www.bitpanda.com) for MoneyMoney 
-- Fetches available data from Bitpanda API
-- 
-- Username: API-Key
--
-- MIT License
--
-- Copyright (c) 2021 GimliGloinsSon
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.


WebBanking{version     = 1.2,
           url         = "https://api.bitpanda.com/v1/",
           services    = {"bitpanda-light"},
           description = "Loads current Balances for FIATs, Krypto, Indizes, Stocks, ETFs, ETCs (Ressources) and Commodities from bitpanda"}

local connection = Connection()
local apiKey
local walletCurrency = "EUR"
local coinDict = {
  -- Krypto
  [1] = "Bitcoin",
  [3] = "Litecoin",
  [5] = "Etherum",
  [6] = "Lisk",
  [7] = "Dash",
  [8] = "Ripple",
  [9] = "Bitcoin Cash",
  [11] = "Pantos",
  [12] = "Komodo",
  [13] = "IOTA",
  [14] = "EOS",
  [15] = "OmiseGo",
  [16] = "Augur",
  [17] = "0x",
  [18] = "ZCash",
  [19] = "NEM",
  [20] = "Stellar",
  [21] = "Tezos",
  [22] = "Cardano",
  [23] = "NEO",
  [24] = "Etherum Classic",
  [25] = "Chainlink",
  [26] = "Waves",
  [27] = "Tether",
  [30] = "USD Coin",
  [31] = "Tron",
  [32] = "Cosmos",
  [33] = "Bitpanda Ecosystem Token",
  [34] = "Basic Attention Token",
  [37] = "Chiliz",
  [38] = "Tron",
  [39] = "Doge",
  [43] = "Qtum",
  [44] = "Vechain",
  [51] = "Polkadot",
  [52] = "Yearn.Finance",
  [53] = "Maker",
  [54] = "Compound",
  [55] = "Synthetix Network Token",
  [56] = "Uniswap",
  [57] = "Filecoin",
  [58] = "Aave",
  [59] = "Kyber Network",
  [60] = "Band Protocol",
  [61] = "REN",
  [63] = "UMA",
  [66] = "Ocean Protocol",
  [69] = "Aragon",
  [129] = "1inch",
  [131] = "The Graph",
  [133] = "Terra",
  [134] = "Polygon",
  [138] = "Dedentraland",
  [139] = "PancakeSwap",
  [141] = "SushiSwap",
  [143] = "Symbol",
  [151] = "Axie Infinity Shard",
  [193] = "SHIBA INU",
  -- Metals
  [28] = "Gold",
  [29] = "Silver",
  [35] = "Palladium",
  [36] = "Platinum",
  -- Indizes
  [40] = "Bitpanda Crypto Index 5",
  [41] = "Bitpanda Crypto Index 10",
  [42] = "Bitpanda Crypto Index 25",
  -- Stocks
  [75] = "Apple",
  [78] = "Microsoft",
  [89] = "Allianz",
  [106] = "Boeing",
}
local priceTable = {}
local allAssetWallets = {}
local allFiatWallets = {}

function SupportsBank (protocol, bankCode)
    return protocol == ProtocolWebBanking and bankCode == "bitpanda-light"
end

function InitializeSession (protocol, bankCode, username, username2, password, username3)
    -- Login.
    apiKey = username
    prices = connection:request("GET", "https://api.bitpanda.com/v1/ticker", nil, nil, nil)
    priceTable = JSON(prices):dictionary()
    allAssetWallets = queryPrivate("asset-wallets")
    allFiatWallets = queryPrivate("fiatwallets")
    urlStock = "https://api.bitpanda.com/v2/masterdata" 
    stocks = connection:request("GET", urlStock, nil, nil, nil)
    stockPriceTable = JSON(stocks):dictionary()
    stockPrices = stockPriceTable.data.attributes.stocks
    etfPrices = stockPriceTable.data.attributes.etfs
    etcPrices = stockPriceTable.data.attributes.etcs
end

function ListAccounts (knownAccounts)
    -- Return array of accounts.
    local accounts = {}

    -- FIAT Wallets
    table.insert(accounts, 
      {
        name = "FIAT Wallets",
        owner = user,
        accountNumber = "FIAT Accounts",
        currency = walletCurrency,
        portfolio = true,
        type = AccountTypePortfolio,
        subAccount = "fiat"
      })

    -- Crypto Wallets
    table.insert(accounts, 
      {
        name = "Krypto Wallets",
        owner = user,
        accountNumber = "Krypto Accounts",
        currency = walletCurrency,
        portfolio = true,
        type = AccountTypePortfolio,
        subAccount = "cryptocoin"
      })

    -- Indizes Wallets
    table.insert(accounts, 
      {
        name = "Index Wallets",
        owner = user,
        accountNumber = "Index Accounts",
        currency = walletCurrency,
        portfolio = true,
        type = AccountTypePortfolio,
        subAccount = "index.index"
      })
  
    -- Commodity Wallets
    table.insert(accounts, 
      {
        name = "Commoditie Wallets",
        owner = user,
        accountNumber = "Comm Accounts",
        currency = walletCurrency,
        portfolio = true,
        type = AccountTypePortfolio,
        subAccount = "commodity.metal"
      })

    -- Stock Wallets
    table.insert(accounts, 
      {
        name = "Stock Wallets",
        owner = user,
        accountNumber = "Stock Accounts",
        currency = walletCurrency,
        portfolio = true,
        type = AccountTypePortfolio,
        subAccount = "security.stock"
      })

    -- ETF Wallets
    table.insert(accounts, 
    {
      name = "ETF Wallets",
      owner = user,
      accountNumber = "ETF Accounts",
      currency = walletCurrency,
      portfolio = true,
      type = AccountTypePortfolio,
      subAccount = "security.etf"
    })

     -- ETC Wallets (Ressources)
     table.insert(accounts, 
     {
       name = "Ressource Wallets",
       owner = user,
       accountNumber = "Ressource Accounts",
       currency = walletCurrency,
       portfolio = true,
       type = AccountTypePortfolio,
       subAccount = "security.etc"
     })
  
      return accounts
end

function RefreshAccount (account, since)
    MM.printStatus("Refreshing account " .. account.name)
    local sum = 0
    local getTrans = {}
    local getBal = {}
    local t = {} -- List of transactions to return

    -- transactions for Depot
    if account.portfolio then
      if account.subAccount == "cryptocoin" then 
        getTrans = allAssetWallets.data.attributes.cryptocoin.attributes.wallets
      elseif account.subAccount == "index.index" then
        getTrans = allAssetWallets.data.attributes.index.index.attributes.wallets
      elseif account.subAccount == "commodity.metal" then
        getTrans = allAssetWallets.data.attributes.commodity.metal.attributes.wallets
      elseif account.subAccount == "security.stock" then
        getTrans = allAssetWallets.data.attributes.security.stock.attributes.wallets
      elseif account.subAccount == "security.etf" then
        getTrans = allAssetWallets.data.attributes.security.etf.attributes.wallets
      elseif account.subAccount == "security.etc" then
        getTrans = allAssetWallets.data.attributes.security.etc.attributes.wallets
      elseif account.subAccount == "fiat" then
        getTrans = allFiatWallets.data
      else
        return
      end
      for index, cryptTransaction in pairs(getTrans) do
        if tonumber(cryptTransaction.attributes.balance) >= 0 then
          local transaction = transactionForCryptTransaction(cryptTransaction, account.currency, account.subAccount)
          t[#t + 1] = transaction
        end
      end
      return {securities = t}
    else
      return      
    end

end

function transactionForCryptTransaction(transaction, currency, type)
    local symbol = nil
    local currPrice = 0
    local currQuant = tonumber(transaction.attributes.balance) 
    local currAmount = 0 
    local isinString = ""
    local wpName = transaction.attributes.name
    local calcCurrency = currency
    
    if type == "fiat" then
      calcCurrency = transaction.attributes.fiat_symbol
      symbol = transaction.attributes.fiat_symbol
      currAmount = currQuant
      currQuant = nil
    elseif type == "index.index" then
      symbol = transaction.attributes.cryptocoin_symbol
      currAmount = currQuant
      currQuant = nil
    elseif type == "security.stock" then  
      symbol = transaction.attributes.cryptocoin_symbol
      currPrice = tonumber(queryStockMasterdata(symbol, "avg_price", stockPrices))
      isinString = queryStockMasterdata(symbol, "isin", stockPrices)
      wpName = wpName .. " - " .. queryStockMasterdata(symbol, "name", stockPrices)
      currAmount = currPrice * currQuant
      calcCurrency = nil
    elseif type == "security.etf" then  
      symbol = transaction.attributes.cryptocoin_symbol
      currPrice = tonumber(queryStockMasterdata(symbol, "avg_price", etfPrices))
      isinString = queryStockMasterdata(symbol, "isin", etfPrices)
      wpName = wpName .. " - " .. queryStockMasterdata(symbol, "name", etfPrices)
      currAmount = currPrice * currQuant
      calcCurrency = nil
    elseif type == "security.etc" then  
      symbol = transaction.attributes.cryptocoin_symbol
      currPrice = tonumber(queryStockMasterdata(symbol, "avg_price", etcPrices))
      isinString = queryStockMasterdata(symbol, "isin", etcPrices)
      wpName = wpName .. " - " .. queryStockMasterdata(symbol, "name", etcPrices)
      currAmount = currPrice * currQuant
      calcCurrency = nil
    else
      symbol = transaction.attributes.cryptocoin_symbol
      currPrice = tonumber(queryPrice(symbol, currency))
      currAmount = currPrice * currQuant
      calcCurrency = nil
    end

    t = {
      --String name: Bezeichnung des Wertpapiers
      name = wpName,
      --String isin: ISIN
      isin = isinString,
      --String securityNumber: WKN
      securityNumber = symbol,
      --String market: Börse
      market = "bitpanda",
      --String currency: Währung bei Nominalbetrag oder nil bei Stückzahl
      currency = calcCurrency,
      --Number quantity: Nominalbetrag oder Stückzahl
      quantity = currQuant,
      --Number amount: Wert der Depotposition in Kontowährung
      amount = currAmount,
      --Number originalCurrencyAmount: Wert der Depotposition in Originalwährung
      originalCurrencyAmount = currAmount,
      --String currencyOfOriginalAmount: Originalwährung
      currencyOfOriginalAmount = calcCurrency,
      --Number exchangeRate: Wechselkurs zum Kaufzeitpunkt
      --Number tradeTimestamp: Notierungszeitpunkt; Die Angabe erfolgt in Form eines POSIX-Zeitstempels.
      tradeTimestamp = os.time(),
      --Number price: Aktueller Preis oder Kurs
      price = currPrice,
      --String currencyOfPrice: Von der Kontowährung abweichende Währung des Preises
      currencyOfPrice = calcCurrency,
      --Number purchasePrice: Kaufpreis oder Kaufkurs
      --String currencyOfPurchasePrice: Von der Kontowährung abweichende Währung des Kaufpreises
    }

    return t
end

function EndSession ()
    -- Logout.
end

function queryPrivate(method, params)
    local path = method
  
    if not (params == nil) then
      local queryParams = httpBuildQuery(params)
      if string.len(queryParams) > 0 then
        path = path .. "?" .. queryParams
      end
    end
  
    local headers = {}
    headers["X-API-KEY"] = apiKey
  
    content = connection:request("GET", url .. path, nil, nil, headers)
  
    return JSON(content):dictionary()
end

function queryPrice(symbol, currency)
  return priceTable[symbol][currency]
end

function queryStockMasterdata(symbol, field, table)

  for key, value in pairs(table) do
    if value.attributes.symbol == symbol then
      return value.attributes[field]
    end
  end

  return 0
end


function httpBuildQuery(params)
    local str = ''
    for key, value in pairs(params) do
      str = str .. key .. "=" .. value .. "&"
    end
    str = str.sub(str, 1, -2)
    return str
end
