#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests.
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#

$CommandName = 'Update-GitModule'

Describe "$CommandName basic testing" -Tag 'Functionality' {


    $moduleName = 'FIFA2018'
    $moduleURL = 'https://github.com/iricigor/' + $moduleName

    $ExistingModule = Get-InstalledModule $moduleName -ea 0
    It 'Should uninstall module if installed' -Skip:($ExistingModule -eq $null) {
        {Uninstall-Module $moduleName} | Should -Not -Throw
    }

    # its not so easy to remove PowerShell module
    $ExistingModule = Get-Module $moduleName -ListAvailable
    It 'Should delete module if still found' -Skip:($ExistingModule -eq $null) {
        {Split-Path ($ExistingModule.Path) -Parent | Remove-Item -Force -Recurse} | Should -Not -Throw
    }

    It 'Should install module from PSGallery' {
        $OldProgressPreference = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        {Install-Module $moduleName -Repository PSGallery -Scope CurrentUser -Force} | Should -Not -Throw
        $ProgressPreference = $OldProgressPreference
    }

    It 'Should update module to newer version' {
        Update-GitModule -ProjectUri $moduleURL -Force | Should -Not -Be $null
    }

}

Describe "$CommandName byName testing" -Tag 'Functionality' {


    $moduleName = 'FIFA2018'
    $moduleURL = 'https://github.com/iricigor/' + $moduleName

    $ExistingModule = Get-InstalledModule $moduleName -ea 0
    It 'Should uninstall again module if installed' -Skip:($ExistingModule -eq $null) {
        {Uninstall-Module $moduleName} | Should -Not -Throw
    }

    # its not so easy to remove PowerShell module
    $ExistingModule = Get-Module $moduleName -ListAvailable
    It 'Should delete again module if still found' -Skip:($ExistingModule -eq $null) {
        {Split-Path ($ExistingModule.Path) -Parent | Remove-Item -Force -Recurse} | Should -Not -Throw
    }

    It 'Should install again module from PSGallery' {
        $OldProgressPreference = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        {Install-Module $moduleName -Repository PSGallery -Scope CurrentUser -Force} | Should -Not -Throw
        $ProgressPreference = $OldProgressPreference
    }

    It 'Should update module byName to newer version' {
        Update-GitModule -Name $moduleName -Force | Should -Not -Be $null
    }

}


Describe "$CommandName error handling" -Tag 'Functionality' {

    $moduleName = 'dbatools'
    $moduleURL = 'https://github.com/sqlcollaborative/' + $moduleName

    It "Should not update non existing module" -Skip:((Get-Module $moduleName -ListAvailable) -ne $null) {
        {Update-GitModule -ProjectUri $moduleURL -ea Stop} | Should -Throw
    }

}