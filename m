Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4145 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYDKMbu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2008 08:31:50 -0400
Date: Fri, 11 Apr 2008 08:27:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	Meelis Roos <mroos@linux.ee>, linux-wireless@vger.kernel.org,
	"Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: iwlwifi integer overflow warnings
Message-ID: <20080411122732.GA4192@tuxdriver.com> (sfid-20080411_135615_102204_2D5405B0)
References: <Pine.SOC.4.64.0804101121160.13294@math.ut.ee> <D936D925018D154694D8A362EEB0892004289DB4@orsmsx416.amr.corp.intel.com> <1207916204.13354.63.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1207916204.13354.63.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 11, 2008 at 02:16:44PM +0200, Johannes Berg wrote:
> 
> > > drivers/net/wireless/iwlwifi/iwl3945-base.c: In function
> > > 'iwl3945_enqueue_hcmd':
> > > drivers/net/wireless/iwlwifi/iwl3945-base.c:719: warning: integer
> > > overflow in expression drivers/net/wireless/iwlwifi/iwl-3945.c: In
> > > function 'iwl3945_add_radiotap':
> > > drivers/net/wireless/iwlwifi/iwl-3945.c:326: warning: integer
> > > overflow in expression drivers/net/wireless/iwlwifi/iwl4965-base.c:
> > > In function 'iwl4965_enqueue_hcmd':
> > > drivers/net/wireless/iwlwifi/iwl4965-base.c:723: warning: integer
> > > overflow in expression drivers/net/wireless/iwlwifi/iwl-4965.c: In
> > > function 'iwl4965_add_radiotap':
> > > drivers/net/wireless/iwlwifi/iwl-4965.c:3617: warning: integer
> > > overflow in expression   
> > > 
> > 
> > (adding Johannes and John)
> > 
> > These problems have been fixed by Johannes with his patch "iwlwifi:fix
> > some warnings". If this is an issue in 2.6.25 then that kernel may take
> > this patch to address the problem.
> 
> That patch never was applied though and Tomas had reservations. I didn't
> have time to look at it again.

Actually, I factored-out the parts Tomas didn't like and applied it.

-- 
John W. Linville
linville@tuxdriver.com
