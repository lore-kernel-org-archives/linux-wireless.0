Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46406 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0BSRWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 12:22:25 -0500
Subject: Re: [PATCH 2/6] iwlwifi: enable iwl_send_static_wepkey_cmd to sleep
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1266599736.2551.2713.camel@rchatre-DESK>
References: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
	 <1266559387-19637-3-git-send-email-reinette.chatre@intel.com>
	 <1266570799.3991.52.camel@jlt3.sipsolutions.net>
	 <1266584399.14781.1.camel@jlt3.sipsolutions.net>
	 <1266599736.2551.2713.camel@rchatre-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 18:22:17 +0100
Message-ID: <1266600137.10689.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-19 at 09:15 -0800, reinette chatre wrote:
> On Fri, 2010-02-19 at 04:59 -0800, Johannes Berg wrote:
> > Or probably better would be this:
> > 
> > iwlwifi: change WEP key protection to use mutex
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> 
> This was a terrible mistake - thank you very much for catching this.
> Your solution looks good. 
> 
> Acked-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> John, could you please replace "iwlwifi: enable
> iwl_send_static_wepkey_cmd to sleep" with "iwlwifi: change WEP key
> protection to use mutex" ?

Not replace though, my patch didn't include the ASYNC->SYNC change. And
it probably wants a better changelog too?

johannes

