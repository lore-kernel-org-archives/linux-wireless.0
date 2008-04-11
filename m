Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15104 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758488AbYDKO4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2008 10:56:36 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: iwlwifi integer overflow warnings
Date: Fri, 11 Apr 2008 07:55:25 -0700
Message-ID: <D936D925018D154694D8A362EEB089200428A233@orsmsx416.amr.corp.intel.com> (sfid-20080411_155639_050534_B4B53F9C)
In-Reply-To: <1207916204.13354.63.camel@johannes.berg>
References: <Pine.SOC.4.64.0804101121160.13294@math.ut.ee> <D936D925018D154694D8A362EEB0892004289DB4@orsmsx416.amr.corp.intel.com> <1207916204.13354.63.camel@johannes.berg>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Meelis Roos" <mroos@linux.ee>, <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, April 11, 2008 5:17 AM, Johannes Berg  wrote:

>>> drivers/net/wireless/iwlwifi/iwl3945-base.c: In function
>>> 'iwl3945_enqueue_hcmd':
>>> drivers/net/wireless/iwlwifi/iwl3945-base.c:719: warning: integer
>>> overflow in expression drivers/net/wireless/iwlwifi/iwl-3945.c: In
>>> function 'iwl3945_add_radiotap':
>>> drivers/net/wireless/iwlwifi/iwl-3945.c:326: warning: integer
>>> overflow in expression drivers/net/wireless/iwlwifi/iwl4965-base.c:
>>> In function 'iwl4965_enqueue_hcmd':
>>> drivers/net/wireless/iwlwifi/iwl4965-base.c:723: warning: integer
>>> overflow in expression drivers/net/wireless/iwlwifi/iwl-4965.c: In
>>> function 'iwl4965_add_radiotap':
>>> drivers/net/wireless/iwlwifi/iwl-4965.c:3617: warning: integer
>>> overflow in expression  
>>> 
>> 
>> (adding Johannes and John)
>> 
>> These problems have been fixed by Johannes with his patch
>> "iwlwifi:fix some warnings". If this is an issue in 2.6.25 then that
>> kernel may take this patch to address the problem.
> 
> That patch never was applied though and Tomas had
> reservations. I didn't
> have time to look at it again.

I did find it in the current wireless-testing as commit
cb08e71a7bc92a5ad518758584f077ed81d62b5c

Reinette
