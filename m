Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8054 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab0BSRbo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 12:31:44 -0500
Subject: Re: [PATCH 2/6] iwlwifi: enable iwl_send_static_wepkey_cmd to sleep
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1266600137.10689.0.camel@jlt3.sipsolutions.net>
References: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
	 <1266559387-19637-3-git-send-email-reinette.chatre@intel.com>
	 <1266570799.3991.52.camel@jlt3.sipsolutions.net>
	 <1266584399.14781.1.camel@jlt3.sipsolutions.net>
	 <1266599736.2551.2713.camel@rchatre-DESK>
	 <1266600137.10689.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 09:30:30 -0800
Message-ID: <1266600630.2551.2719.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-19 at 09:22 -0800, Johannes Berg wrote:
> On Fri, 2010-02-19 at 09:15 -0800, reinette chatre wrote:
>  
> > John, could you please replace "iwlwifi: enable
> > iwl_send_static_wepkey_cmd to sleep" with "iwlwifi: change WEP key
> > protection to use mutex" ?
> 
> Not replace though, my patch didn't include the ASYNC->SYNC change. And
> it probably wants a better changelog too?

ah - right. Seems like we need to clean up here. John, please drop both
these patches. I'll take them into our repo and submit it later. This is
only needed for future work. 

Reinette


