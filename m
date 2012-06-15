Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51800 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab2FOR45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 13:56:57 -0400
Date: Fri, 15 Jun 2012 23:28:12 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>, <c_manoha@qca.qualcomm.com>
Subject: Re: [PATCH 5/9] ath9k_hw: remove the old ANI implementation
Message-ID: <20120615175810.GC648@vmraj-lnx.qca.qualcomm.com> (sfid-20120615_195700_999832_A7B0AFA9)
References: <1339766727-61926-1-git-send-email-nbd@openwrt.org>
 <1339766727-61926-2-git-send-email-nbd@openwrt.org>
 <1339766727-61926-3-git-send-email-nbd@openwrt.org>
 <1339766727-61926-4-git-send-email-nbd@openwrt.org>
 <1339766727-61926-5-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1339766727-61926-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 15, 2012 at 03:25:23PM +0200, Felix Fietkau wrote:
> It was found to be buggy on a variety of chipsets from AR913x to AR928x.
> The new version (which was introduced along with AR93xx support) is more
> reliable in preventing connectivity dropouts and also fixes MIB interrupt
> storm issues.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

I dont think it is good idea to completely removing old ANI for all AR9002
family chips. No one have ever tested the new ANI with all ar9002 chips. May
be there could be some regressions with old ANI. As we discussed in irc did
you get any feedback from openwrt users with partial revert patch? So it is
not viable to wipe out old ani support for older chips.

-Rajkumar
