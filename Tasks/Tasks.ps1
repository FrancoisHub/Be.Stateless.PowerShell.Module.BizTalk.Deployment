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

# TODO option switches to skip tasks (e.g. SkipBamDeployment)

Set-StrictMode -Version Latest

Enter-Build {
    $script:ApplicationName = $ItemGroups.Application.Name
    $script:ApplicationDescription = $ItemGroups.Application.Description
}

. $PSScriptRoot\Tasks.Shim.ps1
. $PSScriptRoot\Tasks.Bam.ps1
. $PSScriptRoot\Tasks.Bts.ps1

# Synopsis: Deploy a Whole Microsoft BizTalk Server Solution
task Deploy Undeploy, `
    Deploy-BizTalkApplication, `
    Deploy-Bam

# Synopsis: Patch a Whole Microsoft BizTalk Server Solution
task Patch { $Script:SkipMgmtDbDeployment = $true }, `
    Patch-BizTalkApplication

# Synopsis: Undeploy a Whole Microsoft BizTalk Server Solution
task Undeploy -If { -not $SkipUndeploy } `
    Undeploy-Bam, `
    Undeploy-BizTalkApplication

Import-Module $PSScriptRoot\..\Application
Import-Module $PSScriptRoot\..\Assembly
Import-Module $PSScriptRoot\..\Bindings
Import-Module $PSScriptRoot\..\Component
Import-Module $PSScriptRoot\..\Resource
