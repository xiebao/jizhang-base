// 获取余额并显示
async function fetchBalance() {
  try {
    const response = await fetch(`https://api.trongrid.io/v1/accounts/${walletAddress}`);
    const result = await response.json();

    if (result.success && result.data && result.data.length > 0) {
      const accountData = result.data[0];
      const trc20Array = accountData.trc20 || [];
      
      // 查找TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t的余额
      let balanceSun = 0;
      for (const token of trc20Array) {
        if (token.hasOwnProperty('TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t')) {
          balanceSun = token['TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t'];
          break;
        }
      }
      
      const balanceTRX = (balanceSun / 1e6).toFixed(6); // 保留6位小数

      document.getElementById("balance").textContent = `${balanceTRX} TRX`;

      const now = new Date().toLocaleTimeString();
      document.getElementById("last-updated").textContent = `上次更新时间：${now}`;
    } else {
      document.getElementById("balance").textContent = "数据格式错误";
      document.getElementById("last-updated").textContent = "";
    }
  } catch (error) {
    console.error("获取余额失败：", error);
    document.getElementById("balance").textContent = "获取失败";
    document.getElementById("last-updated").textContent = "";
  }
}

// 更简洁的写法（如果你确定数据结构）
async function fetchBalanceSimple() {
  try {
    const response = await fetch(`https://api.trongrid.io/v1/accounts/${walletAddress}`);
    const result = await response.json();

    if (result.success && result.data?.[0]?.trc20) {
      const trc20Array = result.data[0].trc20;
      
      // 使用find方法查找包含TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t的对象
      const usdtToken = trc20Array.find(token => 
        Object.keys(token).includes('TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t')
      );
      
      if (usdtToken) {
        const balanceSun = usdtToken['TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t'];
        const balanceTRX = (balanceSun / 1e6).toFixed(6);
        
        document.getElementById("balance").textContent = `${balanceTRX} TRX`;
        
        const now = new Date().toLocaleTimeString();
        document.getElementById("last-updated").textContent = `上次更新时间：${now}`;
      } else {
        document.getElementById("balance").textContent = "未找到USDT余额";
        document.getElementById("last-updated").textContent = "";
      }
    } else {
      document.getElementById("balance").textContent = "数据格式错误";
      document.getElementById("last-updated").textContent = "";
    }
  } catch (error) {
    console.error("获取余额失败：", error);
    document.getElementById("balance").textContent = "获取失败";
    document.getElementById("last-updated").textContent = "";
  }
}