# Diretório do usuário (ex: C:\Users\João)
$diretorioUsuario = [Environment]::GetFolderPath("UserProfile")

# Filtra apenas OneDrive com nome da organização (ex: OneDrive - MinhaEmpresa)
$pastasOneDrive = Get-ChildItem -Path $diretorioUsuario -Directory | Where-Object {
    $_.Name -like "OneDrive - *" -and (Test-Path $_.FullName)
}

# Exibe menu
Write-Host "Onde deseja organizar os arquivos?" -ForegroundColor Cyan
Write-Host "0 - Pasta local do usuário (Downloads, Documentos, etc.)"

for ($i = 0; $i -lt $pastasOneDrive.Count; $i++) {
    Write-Host "$($i + 1) - $($pastasOneDrive[$i].Name)"
}

$opcao = Read-Host "Digite o número correspondente à opção desejada"

# Validação da entrada do usuário
if ($opcao -eq "0") {
    $base = $diretorioUsuario
} elseif ($opcao -match '^\d+$' -and [int]$opcao -ge 1 -and [int]$opcao -le $pastasOneDrive.Count) {
    $base = $pastasOneDrive[[int]$opcao - 1].FullName
} else {
    Write-Host "Opção inválida. Encerrando." -ForegroundColor Red
    exit
}

# Solicita a subpasta (ex: Documentos, Downloads)
$subpasta = Read-Host "Digite o NOME da pasta que deseja organizar dentro de '$base'"

# Constrói caminho completo da pasta a organizar
$pastaOrigem = Join-Path $base $subpasta

# Verifica se a pasta existe
if (!(Test-Path $pastaOrigem)) {
    Write-Host "A pasta '$subpasta' não foi encontrada em '$base'." -ForegroundColor Red
    exit
}

# Dicionário com extensões e subpastas de destino
$extensoes = @{
    ".pdf"  = "PDF"
    ".jpg"  = "Imagens"
    ".jpeg" = "Imagens"
    ".png"  = "Imagens"
    ".gif"  = "Imagens"
    ".docx" = "Documentos"
    ".doc"  = "Documentos"
    ".txt"  = "Textos"
    ".xlsx" = "Planilhas"
    ".xls"  = "Planilhas"
    ".csv"  = "Planilhas"
    ".mp4"  = "Vídeos"
    ".avi"  = "Vídeos"
    ".mp3"  = "Audios"
    ".wav"  = "Audios"
    ".pptx" = "Apresentações"
    ".odp"  = "Apresentações"
    ".zip"  = "Compactados"
    ".rar"  = "Compactados"
    ".exe"  = "Executáveis"
    ".msi"  = "Executáveis"
    ".json" = "Dados"
    ".xml"  = "Dados"
    ".ps1"  = "Scripts"
}

# Lista os arquivos da pasta, ignorando ocultos e temporários
$arquivos = Get-ChildItem -Path $pastaOrigem -File | Where-Object {
    $_.Attributes -notmatch 'Hidden' -and $_.Name -notmatch '^~\$|^Thumbs\.db$'
}

# Lista de ações planejadas
$acoesPlanejadas = @()

foreach ($arquivo in $arquivos) {
    $ext = $arquivo.Extension.ToLower()
    if ($extensoes.ContainsKey($ext)) {
        $subpastaDestino = Join-Path $pastaOrigem $extensoes[$ext]
        $acoesPlanejadas += [PSCustomObject]@{
            Arquivo = $arquivo.Name
            Destino = $subpastaDestino
        }
    }
}

# Exibe pré-visualização
if ($acoesPlanejadas.Count -eq 0) {
    Write-Host "Nenhum arquivo para organizar em '$pastaOrigem'." -ForegroundColor Yellow
    exit
}

Write-Host "`nOs seguintes arquivos serão movidos:" -ForegroundColor Cyan
$acoesPlanejadas | Format-Table

$confirmar = Read-Host "`nDeseja continuar com a organização? (S/N)"

if ($confirmar -eq "S" -or $confirmar -eq "s") {
    for ($i = 0; $i -lt $acoesPlanejadas.Count; $i++) {
        $acao = $acoesPlanejadas[$i]
        $origem = Join-Path $pastaOrigem $acao.Arquivo
        $destino = $acao.Destino

        Write-Progress -Activity "Organizando arquivos..." `
            -Status "$($acao.Arquivo)" `
            -PercentComplete (($i / $acoesPlanejadas.Count) * 100)

        if (!(Test-Path $destino)) {
            try {
                New-Item -Path $destino -ItemType Directory -Force | Out-Null
            } catch {
                Write-Host "Erro ao criar a pasta '$destino': $_" -ForegroundColor Red
                continue
            }
        }

        try {
            Move-Item -Path $origem -Destination $destino -ErrorAction Stop
        } catch {
            Write-Host "Erro ao mover '$($acao.Arquivo)': $_" -ForegroundColor Red
        }
    }

    Write-Host "`nOrganização concluída com sucesso!" -ForegroundColor Green
} else {
    Write-Host "`nOrganização cancelada pelo usuário." -ForegroundColor Yellow
}

