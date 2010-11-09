Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49059 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab0KIVO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 16:14:57 -0500
Date: Tue, 9 Nov 2010 16:12:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/8]  update for 2.6.38
Message-ID: <20101109211209.GD2374@tuxdriver.com>
References: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 23, 2010 at 09:15:38AM -0700, Wey-Yi Guy wrote:
> We make number of changes to prepare upcoming P2P supports
> We also turn on dynamic smps to improve WiFi rx throughput
> for WiFi/BT coex case.
> We also change the new 130 series devices to using 6000g2b uCode
> 
> Johannes Berg (5):
>   iwlwifi: make mac80211 ops a device config
>   iwlagn: don't resent RXON timing
>   iwlagn: new RXON processing for modern devices
>   iwlwifi: fix IBSS beaconing
>   iwlwifi: implement switching iftype while up
> 
> Wey-Yi Guy (3):
>   iwlagn: turn dynamic smps on while BT is on
>   iwlwifi: add new devices to Kconfig
>   iwlagn: use 6000g2b uCode for 130 series devices
> 
> these patches are also available from wireless-next-2.6 branch on
>  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

I figured-out what happened with that other pull request -- you put
that patch on the wireless-next-2.6 branch instead of the wireless-2.6
branch. :-(

I'll apply these manually to wireless-next-2.6...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
