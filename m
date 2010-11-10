Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36658 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab0KJSaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:30:17 -0500
Date: Wed, 10 Nov 2010 13:16:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/16] update for 2.6.37
Message-ID: <20101110181609.GB2714@tuxdriver.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 10, 2010 at 09:56:34AM -0800, Wey-Yi Guy wrote:
> We make the correction for the latest PCI ID used for multiple NICs
> We also fix the low tpt problem cause by mac80211 changes
> Number of code clean up to separate new agn devices from legacy devices
> 
> Johannes Berg (5):
>   iwlagn: fix non-5000+ build
>   iwlagn: fix needed chains calculation
>   iwlagn: fix RXON issues
>   iwlagn: re-enable calibration
>   iwlagn: fix RXON HT
> 
> Shanyu Zhao (2):
>   iwlwifi: seperate disconnected antenna function
>   iwlwifi: disable disconnected antenna for advanced bt coex
> 
> Wey-Yi Guy (8):
>   iwlagn: update PCI ID for 6000g2b series devices
>   iwlagn: update PCI ID for 6000g2a series devices
>   iwlagn: update PCI ID for 100 series devices
>   iwlwifi: Legacy isr only used by legacy devices
>   iwlwifi: put all the isr related function under ops
>   iwlwifi: legacy tx_cmd_protection function
>   iwlwifi: resending QoS command when HT changes
>   iwlagn: enabel shadow register
> 
> Winkler, Tomas (1):
>   iwlwlifi: update rx write pointer w/o request mac access in the CAM
>     mode

Is this really intended for 2.6.37?  Some of these might be
appropriate, although at first glance even some of the fixes may be
for code in -next.

Fixes only for 2.6.37 -- it has been that way for weeks.  Perhaps you
actually intended this for 2.6.38?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
