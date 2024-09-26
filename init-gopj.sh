#!/bin/bash

# 建立一個 golang 專案規範目錄:

# 1. 等待輸入專案名稱
read -p "請輸入專案名稱: " project_name

# 2. 建立專案目錄
mkdir $project_name

# 3. 建立專案目錄下的 cmd,internal,pkg,configs,init,scripts,build,deployments,docs 資料夾、README.md、.gitignore
# 並為每個資料夾增加 .gitkeep
cd $project_name
mkdir {cmd,internal,pkg,configs,init,scripts,build,deployments,docs}
touch README.md .gitignore
touch {cmd,internal,pkg,configs,init,scripts,build,deployments,docs}/.gitkeep

# 3-1. 將 .gitignore 加上 .DS_Store
echo ".DS_Store" >> .gitignore

# 3-2. 將 README.md 加上專案名稱
echo "# $project_name" >> README.md

# 3-3. 將 README.md 以下內容
cat >> README.md <<EOF

---

# 命名規範
## 1. 檔案命名

> 使用 小寫, 下劃線分隔單詞（snake_case）
> 例如：user_repository.go, error_handler.go

## 2. 結構體（Struct）命名

> 使用大駝峰命名法（PascalCase）
> 名稱要有描述性，避免縮寫（除非非常常見）
> 例如：type UserService struct {}, type HTTPClient struct {}

## 3. 接口（Interface）命名

> 使用大駝峰命名法
> 通常以 "er" 結尾
> 例如：type Reader interface {}, type UserRepository interface {}

## 4. 變量和函數命名

> 使用小駝峰命名法（camelCase）
> 簡潔但具有描述性
> 例如：userID, fetchUserDetails()

## 5. 常量命名

> 使用全大寫，下劃線分隔單詞
> 例如：const MAX_CONNECTIONS = 100

## 6. 單複數使用

包名(package)通常使用單數形式：package model, package controller
表示集合或組的變量使用複數形式：users := []User{}, productIDs := []int{}
接口通常使用單數：type UserRepository interface {}

## 7. 其他最佳實踐

- 遵循 Go 的官方風格指南和常見的約定
- 使用 go fmt 自動格式化代碼
- 使用 golint 和 go vet 進行代碼質量檢查
- 編寫清晰的註釋和文檔
- 保持一致性，特別是在大型專案中
---
## 主要目錄說明

- cmd/

用途：存放主要的應用程序入口點
命名：使用小寫，通常是應用程序的名稱
例如：cmd/myapp/main.go, cmd/cli/main.go

- internal/

用途：存放不希望被外部導入的包
命名：使用小寫，描述性名稱
例如：internal/database/, internal/auth/

- pkg/

用途：可以被外部專案導入的庫代碼
命名：使用小寫，描述性名稱
例如：pkg/middleware/, pkg/validator/

- api/

用途：OpenAPI/Swagger 規範，協議定義文件等
命名：使用小寫，版本號可以大寫
例如：api/proto/, api/swagger/, api/v1/

- configs/

用途：配置文件模板或默認配置
命名：使用小寫，通常使用配置類型作為名稱
例如：configs/production.yaml, configs/development.json

EOF


# 3-4. 等待讀入 mod 名稱
read -p "請輸入 mod 名稱: " mod_name

# 4. go mod init mod 名稱
go mod init $mod_name

# 4.1 初始化 git
git init

echo "專案建立完成，請開始開發！"

