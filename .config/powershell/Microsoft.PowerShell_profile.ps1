$PSStyle.OutputRendering = 'PlainText'
Register-ArgumentCompleter -Native -CommandName aws -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
        $env:COMP_LINE=$wordToComplete
        $env:COMP_POINT=$cursorPosition
        aws_completer | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
        Remove-Item Env:\COMP_LINE     
        Remove-Item Env:\COMP_POINT    
}
Remove-Item Env:AWS_CONTAINER_AUTHORIZATION_TOKEN_FILE -ErrorAction SilentlyContinue
Remove-Item Env:__MDE_ENV_API_AUTHORIZATION_TOKEN_FILE -ErrorAction SilentlyContinue
