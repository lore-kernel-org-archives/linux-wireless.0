Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30081 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbYDJUiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 16:38:06 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: iwlwifi integer overflow warnings
Date: Thu, 10 Apr 2008 13:29:45 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004289DB4@orsmsx416.amr.corp.intel.com> (sfid-20080410_213814_747828_62118C06)
In-Reply-To: <Pine.SOC.4.64.0804101121160.13294@math.ut.ee>
References: <Pine.SOC.4.64.0804101121160.13294@math.ut.ee>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Meelis Roos" <mroos@linux.ee>, <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On , Meelis Roos  wrote:

> (In case anyone is interested)
> 
> This is todays 2.6.25-rc8+git on ppc (not powerpc) arch (32-bit),
> gcc version 4.3.1 20080401 (prerelease) (Debian 4.3.0-3)
> 
> drivers/net/wireless/iwlwifi/iwl3945-base.c: In function
> 'iwl3945_enqueue_hcmd':
> drivers/net/wireless/iwlwifi/iwl3945-base.c:719: warning: integer
> overflow in expression drivers/net/wireless/iwlwifi/iwl-3945.c: In
> function 'iwl3945_add_radiotap':
> drivers/net/wireless/iwlwifi/iwl-3945.c:326: warning: integer
> overflow in expression drivers/net/wireless/iwlwifi/iwl4965-base.c:
> In function 'iwl4965_enqueue_hcmd':
> drivers/net/wireless/iwlwifi/iwl4965-base.c:723: warning: integer
> overflow in expression drivers/net/wireless/iwlwifi/iwl-4965.c: In
> function 'iwl4965_add_radiotap':
> drivers/net/wireless/iwlwifi/iwl-4965.c:3617: warning: integer
> overflow in expression   
> 

(adding Johannes and John)

These problems have been fixed by Johannes with his patch "iwlwifi:fix
some warnings". If this is an issue in 2.6.25 then that kernel may take
this patch to address the problem.

Reinette
	
