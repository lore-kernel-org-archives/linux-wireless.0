Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29733 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab0BSRPh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 12:15:37 -0500
Subject: Re: [PATCH 2/6] iwlwifi: enable iwl_send_static_wepkey_cmd to sleep
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1266584399.14781.1.camel@jlt3.sipsolutions.net>
References: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
	 <1266559387-19637-3-git-send-email-reinette.chatre@intel.com>
	 <1266570799.3991.52.camel@jlt3.sipsolutions.net>
	 <1266584399.14781.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 09:15:36 -0800
Message-ID: <1266599736.2551.2713.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-19 at 04:59 -0800, Johannes Berg wrote:
> Or probably better would be this:
> 
> iwlwifi: change WEP key protection to use mutex
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

This was a terrible mistake - thank you very much for catching this.
Your solution looks good. 

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

John, could you please replace "iwlwifi: enable
iwl_send_static_wepkey_cmd to sleep" with "iwlwifi: change WEP key
protection to use mutex" ?

Reinette


