#region Copyright & License

# Copyright © 2012 - 2020 François Chabot
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#endregion

Set-StrictMode -Version Latest

Enter-BuildTask {
    # assign task's matching Manifest's Resources to Resources variables
    $taskObject = $Task.Name -split '-' | Select-Object -Skip 1
    if (-not [string]::IsNullOrEmpty($taskObject)) {
        $taskResourceGroup = @(Get-TaskResourceGroup -Name $taskObject)
        Set-Variable -Name Resources -Option ReadOnly -Scope Local -Value $taskResourceGroup -Force
    }
}

Exit-BuildTask {
    # ignore error to prevent failure should the variable Resources not be defined
    Remove-Variable -Name Resources -Scope Local -Force -ErrorAction Ignore
}

function Get-TaskResourceGroup {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [switch]
        $ThrowOnError
    )
    if ($Manifest.ContainsKey($Name)) {
        @($Manifest.$Name | Where-Object { -not(Get-Member -InputObject $_ -Name Condition) -or $_.Condition() })
    } elseif ($ThrowOnError) {
        throw "Resource group '$Name' has not been defined."
    } else {
        @()
    }
}
