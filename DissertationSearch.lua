-- About DissertationSearch.lua
--
-- DissertationSearch.lua does a Dissertation Abstracts search for the LoanTitle for loans.
-- autoSearch (boolean) determines whether the search is performed automatically when a request is opened or not.
-- You must insert your client ID where the "XXXX". You can get this from your proquest url.

local settings = {};
settings.AutoSearch = GetSetting("AutoSearch");
settings.ClientId = GetSetting("ClientId");

local interfaceMngr = nil;

local proquestForm = {};
proquestForm.Form = nil;
proquestForm.Browser = nil;
proquestForm.RibbonPage = nil;

function Init()
	if GetFieldValue("Transaction", "RequestType") == "Loan" then
		interfaceMngr = GetInterfaceManager();

		-- Create form
		proquestForm.Form = interfaceMngr:CreateForm("ProQuest Dissertation Abstracts", "Script");

		-- Create browser
        proquestForm.Browser = proquestForm.Form:CreateBrowser("ProQuest Dissertation Abstracts", "ProQuest Dissertation Abstracts", "Script", "WebView2");

		-- Hide the text label
		proquestForm.Browser.TextVisible = false;

		-- Since we didn't create a ribbon explicitly before creating our browser, it will have created one using the name we passed the CreateBrowser method.  We can retrieve that one and add our buttons to it.
		proquestForm.RibbonPage = proquestForm.Form:GetRibbonPage("Script");

		-- Create buttons
        proquestForm.RibbonPage:CreateButton("Search", GetClientImage("Search32"), "Search", "Proquest Dissertaion Abstracts");

		proquestForm.Form:Show();

		if settings.AutoSearch then
			Search();
		end
	end
end

function Search()
	proquestForm.Browser:RegisterPageHandler("formExists", "searchForm","DissertationLoaded", false);

	proquestForm.Browser:Navigate("http://search.proquest.com/dissertations/advanced?accountid=" .. settings.ClientId);
end

function DissertationLoaded()
	local title = GetFieldValue("Transaction", "LoanTitle");

	local searchFormScript = [[
		(function (title) {
			document.getElementsByName("queryTermField")[0].value = title;

			document.getElementsByName("adv_search_form")[0].submit();
		})
	]];

	proquestForm.Browser:ExecuteScript(searchFormScript, {title})
end