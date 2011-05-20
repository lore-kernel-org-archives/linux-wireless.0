Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46028 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934005Ab1ETSiz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 14:38:55 -0400
Subject: Re: linux-next: Tree for May 20 (iwlwifi)
From: wwguy <wey-yi.w.guy@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
In-Reply-To: <20110520105421.3766ea12.randy.dunlap@oracle.com>
References: <20110520165507.cba539d5.sfr@canb.auug.org.au>
	 <20110520105421.3766ea12.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 11:35:24 -0700
Message-ID: <1305916524.10450.27.camel@wwguy-ubuntu> (sfid-20110520_203919_010679_017E3513)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Randy,

On Fri, 2011-05-20 at 10:54 -0700, Randy Dunlap wrote:
> On Fri, 20 May 2011 16:55:07 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> 
> 
> drivers/net/wireless/iwlwifi/iwl-agn-rs.c:351: error: 'struct iwl_lq_sta' has no member named 'dbg_fixed_rate'
> drivers/net/wireless/iwlwifi/iwl-agn-rs.c:1076: error: 'struct iwl_lq_sta' has no member named 'dbg_fixed_rate'
> 
> when CONFIG_MAC80211_DEBUGFS is not enabled.
> 
> ---
This was introduced by a new "SVTOOL" we have. I will push the patch to
fix this.

Sorry

Wey 

