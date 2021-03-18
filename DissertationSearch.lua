-- About DissertationSearch.lua
--
-- DissertationSearch.lua does a Dissertation Abstracts search for the LoanTitle for loans.
-- autoSearch (boolean) determines whether the search is performed automatically when a request is opened or not.
--You must insert your client ID where the "XXXX". You can get this from your proquest url.

local autoSearch = GetSetting("AutoSearch");

local interfaceMngr = nil;
local browser = nil;
function Init()
	if GetFieldValue("Transaction", "RequestType") == "Loan" then
		interfaceMngr = GetInterfaceManager();
		
		-- Create browser
                browser = interfaceMngr:CreateBrowser("Proquest Dissertation Abstracts", "Proquest Dissertation Abstracts", "Script");
		
		-- Create buttons
	  
                browser:CreateButton("Search", GetClientImage("Search32"), "Search", "Proquest Dissertaion Abstracts");
	  		
		browser:Show();
		
		if autoSearch then
			Search();
		end
	end
end

function Search()
     
        browser:RegisterPageHandler("formExists", "searchForm","DissertationLoaded", false);
     
      
         browser:Navigate("http://search.proquest.com/dissertations/advanced?accountid=" .. GetSetting("ClientId"));      
      
end

      function DissertationLoaded()
      browser:SetFormValue("adv_search_form", "queryTermField", GetFieldValue("Transaction", "LoanTitle"));


        browser:SubmitForm("adv_search_form");
  
end

 
 