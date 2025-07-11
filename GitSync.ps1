<#
.SYNOPSIS
�Զ�ͬ�� Git �ֿ⣺����ȡ���´��룬�����ͱ��ظ���

.DESCRIPTION
�˽ű�������� Windows ����ƻ�����ʵ�� Git �ֿ���Զ�ͬ��
- �Զ�����������⣬������־����
- ���ƵĴ��������־��¼
- ֧���Զ����֧�Ͳֿ�·��

.PARAMETER RepoPath
Git �ֿ�ı���·����Ĭ��Ϊ�ű�����Ŀ¼��

.PARAMETER Branch
Ҫͬ���� Git ��֧��Ĭ��Ϊ 'main'��

.EXAMPLE
.\GitSync.ps1
ʹ��Ĭ������ͬ����ǰĿ¼�Ĳֿ�

.EXAMPLE
.\GitSync.ps1 -RepoPath "C:\MyProject" -Branch "develop"
ͬ��ָ��·���ͷ�֧�Ĳֿ�
#>

param(
    [string]$RepoPath = $PWD.Path,
    [string]$Branch = "main"
)

# ��������
$LogFile = Join-Path $RepoPath "git_sync.log"
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# ������־����
function Write-Log {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [ValidateSet("INFO", "WARNING", "ERROR", "SUCCESS")]
        [string]$Level = "INFO"
    )
    
    $logEntry = "[$Timestamp] [$Level] $Message"
    $logEntry | Out-File -FilePath $LogFile -Append -Encoding UTF8
    
    # ͬʱ�ڿ���̨��ʾ�����������ƻ���������ʾ��
    if ($Host.Name -eq "ConsoleHost") {
        switch ($Level) {
            "INFO"    { Write-Host $logEntry -ForegroundColor Gray }
            "WARNING" { Write-Host $logEntry -ForegroundColor Yellow }
            "ERROR"   { Write-Host $logEntry -ForegroundColor Red }
            "SUCCESS" { Write-Host $logEntry -ForegroundColor Green }
        }
    }
}

# ���ֿ�·���Ƿ����
if (-not (Test-Path -Path $RepoPath)) {
    Write-Log "���󣺲ֿ�·�� '$RepoPath' ������" -Level ERROR
    exit 1
}

# ��� Git �Ƿ�װ
try {
    $gitVersion = git --version
    Write-Log "��⵽ Git: $gitVersion"
} catch {
    Write-Log "����δ�ҵ� Git����ȷ�� Git �Ѱ�װ����ӵ�ϵͳ PATH" -Level ERROR
    exit 1
}

# ����ֿ�Ŀ¼
Set-Location -Path $RepoPath

# ����Ƿ��� Git �ֿ�
if (-not (Test-Path -Path ".git")) {
    Write-Log "����'$RepoPath' ���� Git �ֿ�" -Level ERROR
    exit 1
}

Write-Log "��ʼͬ���ֿ�: $RepoPath (��֧: $Branch)"
Write-Log "----------------------------------------"

# ���� 1: ��ȡ���´���
try {
    Write-Log "������ȡ���´���..."
    $pullResult = git pull origin $Branch 2>&1
    Write-Log "��ȡ���: $pullResult" -Level SUCCESS
} catch {
    Write-Log "��ȡʧ��: $_" -Level ERROR
    exit 1
}

# ���� 2: ����Ƿ��б��ظ�����Ҫ����
$statusResult = git status --porcelain
if ([string]::IsNullOrEmpty($statusResult)) {
    Write-Log "û�б��ظ�����Ҫ����" -Level INFO
    exit 0
}

# ���� 3: ��Ӳ��ύ���и���
try {
    Write-Log "��⵽���ظ���: $($statusResult.Replace("`n", ", "))"
    git add --all 2>&1 | Out-Null
    $commitMessage = "�Զ��ύ�� $Timestamp"
    git commit -m $commitMessage 2>&1 | Out-Null
    Write-Log "���ύ����: $commitMessage" -Level SUCCESS
} catch {
    Write-Log "�ύʧ��: $_" -Level ERROR
    exit 1
}

# ���� 4: ���͸���
try {
    Write-Log "�������͸��ĵ� origin/$Branch..."
    $pushResult = git push origin $Branch 2>&1
    Write-Log "���ͽ��: $pushResult" -Level SUCCESS
} catch {
    Write-Log "����ʧ��: $_" -Level ERROR
    exit 1
}

Write-Log "ͬ�����"
Write-Log "========================================"
exit 0