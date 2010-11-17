Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:40708 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935027Ab0KQRQQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 12:16:16 -0500
Subject: Re: iwlwifi: fix modular legacy build errors
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CE40CF9.8090404@oracle.com>
References: <1290011797.12056.255.camel@wwguy-huron>
	 <1290012580.3777.1.camel@jlt3.sipsolutions.net>
	 <4CE40CF9.8090404@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 09:11:16 -0800
Message-ID: <1290013876.12056.260.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Randy,

On Wed, 2010-11-17 at 09:12 -0800, Randy Dunlap wrote:
> On 11/17/10 08:49, Johannes Berg wrote:
> > On Wed, 2010-11-17 at 08:36 -0800, Guy, Wey-Yi wrote:
> >> Hi Randy,
> >>
> >> the "iwlwifi: fix modular legacy build errors" patch cause the following
> >> WARNING when compile 
> > 
> > I thought we already had had a fix for that issue anyway?
> 
> Not that I know of.  I reported a different build error and
> included a patch, which is now causing problems, so I asked
> John to drop/revert my patch.
> 
> Here is part of the patch description that I sent:
> 
> 
> With CONFIG_IWLWIFI=m, CONFIG_IWLAGN=m, and CONFIG_IWL3945=m,
> a kernel build has errors as below.  Changing a few lines in the
> Makefile is one possible fix for these build errors.
> 
> ERROR: "iwl_legacy_mac_config" [drivers/net/wireless/iwlwifi/iwl3945.ko] undefined!
> ERROR: "iwl_isr_legacy" [drivers/net/wireless/iwlwifi/iwl3945.ko] undefined!
> ERROR: "iwl_legacy_tx_cmd_protection" [drivers/net/wireless/iwlwifi/iwl3945.ko] undefined!
> ERROR: "iwl_legacy_mac_bss_info_changed" [drivers/net/wireless/iwlwifi/iwl3945.ko] undefined!
> ERROR: "iwl_legacy_mac_reset_tsf" [drivers/net/wireless/iwlwifi/iwl3945.ko] undefined!
> 
> 
> So John can revert my patch and then let the iwlwifi maintainers fix this problem,
> please.
> 

"iwlagn: fix non-5000+ build" send by Johannes should have this problem
addressed.

Thanks for look into the problem and help address it.

Wey



