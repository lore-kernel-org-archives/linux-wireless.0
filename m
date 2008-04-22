Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:5092 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957AbYDVXCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2008 19:02:13 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: iwl3945 problem with 2.6.25-rc9
Date: Tue, 22 Apr 2008 16:02:11 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004415152@orsmsx416.amr.corp.intel.com> (sfid-20080423_010256_199650_7E9B2DB8)
In-Reply-To: <BAY109-W5276443C777EAD90F53A43C9E70@phx.gbl>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com> <fu5iel$c45$1@ger.gmane.org> <fu5l5r$pm8$1@ger.gmane.org> <1208376292.27708.3.camel@localhost.localdomain> <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com> A<fu931e$k1b$1@ger.gmane.org> <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com> (sfid-20080418_224627_648936_DECA7576) <1208555842.4848.56.camel@johannes.berg> <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com> <BAY109-W5276443C777EAD90F53A43C9E70@phx.gbl>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Marcus Furlong" <furlongm@hotmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, April 18, 2008 7:33 PM, Marcus Furlong  wrote:


> Both dmesg logs here:
> 
> https://www.cs.tcd.ie/~furlongm/iwlwifi/2.6.25-dmesg-with-patch
> https://www.cs.tcd.ie/~furlongm/iwlwifi/2.6.25-dmesg-with-patch
> -disable_hw_scan 

This is very strange. Did anything change in your setup since you sent
the logs that created the debug file named
"2.6.25-dmesg-wirelesstools-only"? In the above log
2.6.25-dmesg-with-patch hardware scanning is indeed being used ... while
it was not in the previous test runs. Note the debug message
"iwl3945_mac_hw_scan enter" and "iwl3945_mac_hw_scan leave". This
message only appears in this log (2.6.25-dmesg-with-patch) and none of
the others.
I find it very hard to believe that this patch caused hw scanning to
work all of a sudden. 

Reinette
