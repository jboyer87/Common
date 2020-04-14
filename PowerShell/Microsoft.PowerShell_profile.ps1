$psVersion = $host.Version.Major

$Host.UI.RawUI.WindowTitle = "PS v$psVersion" 

function Write-BranchName () {
	try {
		$branch = git rev-parse --abbrev-ref HEAD

		if ($branch -eq "HEAD") {
			# we're probably in detached HEAD state, so print the SHA
			$branch = git rev-parse --short HEAD
			Write-Host " [$branch]" -ForegroundColor "red"
		}
		else {
			# we're on an actual branch, so print it
			Write-Host " [$branch]" -ForegroundColor "blue"
		}
	}
 catch {
		# we'll end up here if we're in a newly initiated git repo
		Write-Host " [no branches]" -ForegroundColor "yellow"
	}
}

function prompt {
	$path = "$($executionContext.SessionState.Path.CurrentLocation)"
	$userPrompt = "$('>>>' * ($nestedPromptLevel + 1))"

	Write-Host "`n" -NoNewline

	if (Test-Path .git) {
		Write-Host "$path>" -ForegroundColor "green" -NoNewline
		Write-BranchName
	}
	else {
		# we're not in a repo so don't bother displaying branch name/sha
		Write-Host "$path>" -ForegroundColor "green"
	}

	return $userPrompt
}
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
