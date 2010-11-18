Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15150 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759929Ab0KRRhP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 12:37:15 -0500
Subject: Re: iwlwifi: fix modular legacy build errors
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20101118091138.80875baf.randy.dunlap@oracle.com>
References: <1290011797.12056.255.camel@wwguy-huron>
	 <1290012580.3777.1.camel@jlt3.sipsolutions.net>
	 <4CE40CF9.8090404@oracle.com>	<1290013876.12056.260.camel@wwguy-huron>
	 <20101118091138.80875baf.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Thu, 18 Nov 2010 09:36:00 -0800
Message-Id: <1290101760.6131.1.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

On Thu, 2010-11-18 at 09:11 -0800, Randy Dunlap wrote:
> On Wed, 17 Nov 2010 09:11:16 -0800 Guy, Wey-Yi wrote:
> 
> > Hi Randy,
> > 
> > On Wed, 2010-11-17 at 09:12 -0800, Randy Dunlap wrote:
> > > On 11/17/10 08:49, Johannes Berg wrote:
> > > > On Wed, 2010-11-17 at 08:36 -0800, Guy, Wey-Yi wrote:
> > > >> Hi Randy,
> > > >>
> > > >> the "iwlwifi: fix modular legacy build errors" patch cause the following
> > > >> WARNING when compile 
> > > > 
> > > > I thought we already had had a fix for that issue anyway?
> > > 
> > > Not that I know of.  I reported a different build error and
> > > included a patch, which is now causing problems, so I asked
> > > John to drop/revert my patch.
> > > 
> > > Here is part of the patch description that I sent:
> > > 
> > > 
> > > With CONFIG_IWLWIFI=m, CONFIG_IWLAGN=m, and CONFIG_IWL3945=m,
> > > a kernel build has errors as below.  Changing a few lines in the
> > > Makefile is one possible fix for these build errors.
> > > 
> > > ERROR: "iwl_legacy_mac_config" [drivers/net/wireless/iwlwifi/iwl3945.ko] undefined!
> > > ERROR: "iwl_isr_legacy" [drivers/net/wireless/iwlwifi/iwl3945.ko] undefined!
> > > ERROR: "iwl_legacy_tx_cmd_protection" [drivers/net/wireless/iwlwifi/iwl3945.ko] undefined!
> > > ERROR: "iwl_legacy_mac_bss_info_changed" [drivers/net/wireless/iwlwifi/iwl3945.ko] undefined!
> > > ERROR: "iwl_legacy_mac_reset_tsf" [drivers/net/wireless/iwlwifi/iwl3945.ko] undefined!
> > > 
> > > 
> > > So John can revert my patch and then let the iwlwifi maintainers fix this problem,
> > > please.
> > > 
> > 
> > "iwlagn: fix non-5000+ build" send by Johannes should have this problem
> > addressed.
> 
> 
> Can we get this patch into linux-next, please?
> linux-next of 2010.1118 is still having these build errors.
> 

Could you help?

Thanks
Wey

