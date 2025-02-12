Describe Get-PackagesPath {
    InModuleScope DITUtils {
        $testConfigPath = Join-Path ($env:TEMP) 'DITUtils.json'
        Mock Get-DITUtilsConfigPath {
            return $testConfigPath
        }
        It 'should return the packages path from the config when the config has value' {
            Set-DITUtilsConfig -KeyName 'packagesPath' -KeyValue 'C:\temp\.alpackages'
            Get-PackagesPath | Should Be 'C:\temp\.alpackages'
        }
        It 'should return the .alpackages under the current path when the config file does not have value' {
            Set-DITUtilsConfig -KeyName 'packagesPath' -KeyValue ''
            Get-PackagesPath | Should Be (Join-Path (Get-Location) '.alpackages')
        }
    }
}