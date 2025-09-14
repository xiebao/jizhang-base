#!/bin/bash

# Nginx配置部署脚本
# 用于修复403 Forbidden问题

echo "开始部署nginx配置..."

# 1. 备份当前配置
echo "备份当前nginx配置..."
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup.$(date +%Y%m%d_%H%M%S)

# 2. 复制新配置
echo "应用新的nginx配置..."
sudo cp nginx_config_fixed.conf /etc/nginx/sites-available/default

# 3. 检查nginx配置语法
echo "检查nginx配置语法..."
sudo nginx -t

if [ $? -eq 0 ]; then
    echo "nginx配置语法检查通过"
    
    # 4. 设置正确的文件权限
    echo "设置文件权限..."
    sudo chown -R www-data:www-data /www/wwwroot/XbxMask
    sudo chmod -R 755 /www/wwwroot/XbxMask
    
    # 5. 确保index.html可读
    sudo chmod 644 /www/wwwroot/XbxMask/index.html
    sudo chmod 644 /www/wwwroot/XbxMask/*.html
    
    # 6. 重启nginx
    echo "重启nginx服务..."
    sudo systemctl reload nginx
    
    if [ $? -eq 0 ]; then
        echo "✅ nginx配置部署成功！"
        echo "请访问你的网站测试是否正常"
    else
        echo "❌ nginx重启失败，请检查错误日志"
        sudo systemctl status nginx
    fi
else
    echo "❌ nginx配置语法错误，请检查配置文件"
    exit 1
fi

echo "部署完成！"
