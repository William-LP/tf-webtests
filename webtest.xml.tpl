<WebTest Name="${name}" Id="${id}" Enabled="True" CssProjectStructure="" CssIteration=""
    Timeout="${timeout}" WorkItemIds="" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Description=""
    CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False"
    RecordedResultFile="" ResultsLocale="">
    <Items>
        <Request Method="${method}" Guid="${guid}" Version="1.1" Url="${url}"
            ThinkTime="0" Timeout="${timeout}" ParseDependentRequests="${parse_dependent_requests}" FollowRedirects="True" RecordResult="True"
            Cache="False" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="${expected_http_status_code}" ExpectedResponseUrl=""
            ReportingName="" IgnoreHttpStatusCode="False" />
    </Items>
    %{ if match_content != null }
    <ValidationRules>
        <ValidationRule
            Classname="Microsoft.VisualStudio.TestTools.WebTesting.Rules.ValidationRuleFindText, Microsoft.VisualStudio.QualityTools.WebTestFramework, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
            DisplayName="Find Text" Description="Verifies the existence of the specified text in the response."
            Level="High" ExectuionOrder="BeforeDependents">
            <RuleParameters>
                <RuleParameter Name="FindText" Value="${match_content}" />
                <RuleParameter Name="IgnoreCase" Value="False" />
                <RuleParameter Name="UseRegularExpression" Value="False" />
                <RuleParameter Name="PassIfTextFound" Value="True" />
            </RuleParameters>
        </ValidationRule>
    </ValidationRules>
    %{ endif }
</WebTest>
