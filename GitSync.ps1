<#
.SYNOPSIS
自动同步 Git 仓库：先拉取最新代码，再推送本地更改

.DESCRIPTION
此脚本设计用于 Windows 任务计划程序，实现 Git 仓库的自动同步
- 自动处理编码问题，避免日志乱码
- 完善的错误处理和日志记录
- 支持自定义分支和仓库路径

.PARAMETER RepoPath
Git 仓库的本地路径（默认为脚本所在目录）

.PARAMETER Branch
要同步的 Git 分支（默认为 'main'）

.EXAMPLE
.\GitSync.ps1
使用默认设置同步当前目录的仓库

.EXAMPLE
.\GitSync.ps1 -RepoPath "C:\MyProject" -Branch "develop"
同步指定路径和分支的仓库
#>

param(
    [string]$RepoPath = $PWD.Path,
    [string]$Branch = "main"
)

# 配置设置
$LogFile = Join-Path $RepoPath "git_sync.log"
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# 创建日志函数
function Write-Log {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [ValidateSet("INFO", "WARNING", "ERROR", "SUCCESS")]
        [string]$Level = "INFO"
    )
    
    $logEntry = "[$Timestamp] [$Level] $Message"
    $logEntry | Out-File -FilePath $LogFile -Append -Encoding UTF8
    
    # 同时在控制台显示（如果从任务计划运行则不显示）
    if ($Host.Name -eq "ConsoleHost") {
        switch ($Level) {
            "INFO"    { Write-Host $logEntry -ForegroundColor Gray }
            "WARNING" { Write-Host $logEntry -ForegroundColor Yellow }
            "ERROR"   { Write-Host $logEntry -ForegroundColor Red }
            "SUCCESS" { Write-Host $logEntry -ForegroundColor Green }
        }
    }
}

# 检查仓库路径是否存在
if (-not (Test-Path -Path $RepoPath)) {
    Write-Log "错误：仓库路径 '$RepoPath' 不存在" -Level ERROR
    exit 1
}

# 检查 Git 是否安装
try {
    $gitVersion = git --version
    Write-Log "检测到 Git: $gitVersion"
} catch {
    Write-Log "错误：未找到 Git。请确保 Git 已安装并添加到系统 PATH" -Level ERROR
    exit 1
}

# 进入仓库目录
Set-Location -Path $RepoPath

# 检查是否是 Git 仓库
if (-not (Test-Path -Path ".git")) {
    Write-Log "错误：'$RepoPath' 不是 Git 仓库" -Level ERROR
    exit 1
}

Write-Log "开始同步仓库: $RepoPath (分支: $Branch)"
Write-Log "----------------------------------------"

# 步骤 1: 拉取最新代码
try {
    Write-Log "正在拉取最新代码..."
    $pullResult = git pull origin $Branch 2>&1
    Write-Log "拉取结果: $pullResult" -Level SUCCESS
} catch {
    Write-Log "拉取失败: $_" -Level ERROR
    exit 1
}

# 步骤 2: 检查是否有本地更改需要推送
$statusResult = git status --porcelain
if ([string]::IsNullOrEmpty($statusResult)) {
    Write-Log "没有本地更改需要推送" -Level INFO
    exit 0
}

# 步骤 3: 添加并提交所有更改
try {
    Write-Log "检测到本地更改: $($statusResult.Replace("`n", ", "))"
    git add --all 2>&1 | Out-Null
    $commitMessage = "自动提交于 $Timestamp"
    git commit -m $commitMessage 2>&1 | Out-Null
    Write-Log "已提交更改: $commitMessage" -Level SUCCESS
} catch {
    Write-Log "提交失败: $_" -Level ERROR
    exit 1
}

# 步骤 4: 推送更改
try {
    Write-Log "正在推送更改到 origin/$Branch..."
    $pushResult = git push origin $Branch 2>&1
    Write-Log "推送结果: $pushResult" -Level SUCCESS
} catch {
    Write-Log "推送失败: $_" -Level ERROR
    exit 1
}

Write-Log "同步完成"
Write-Log "========================================"
exit 0