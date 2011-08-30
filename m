Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47946 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab1H3SAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 14:00:24 -0400
Date: Tue, 30 Aug 2011 13:48:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: Re: [PATCH] ath9k: add missing AR9340 in ath_mac_bb_names
Message-ID: <20110830174810.GA2660@tuxdriver.com> (sfid-20110830_200109_338654_1145BACB)
References: <201108252133.48605.florian@openwrt.org>
 <201108301101.27843.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201108301101.27843.florian@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 11:01:27AM +0200, Florian Fainelli wrote:
> Luis, John,
> 
> On Thursday 25 August 2011 21:33:48 Florian Fainelli wrote:
> > AR9340 is not listed in ath_mac_bb_names, which leads to such a message:
> > ieee80211 phy0: Atheros AR???? Rev:0 mem=0xb8100000, irq=2
> > 
> > Signed-off-by: Florian Fainelli <florian@openwrt.org>
> 
> Can you pick this up? Thanks.

Did you actually check to see if it had been merged into wireless-next?

commit 397e5d5b93ba99ad3dc56f1e294f487e77d2daa8
Author: Florian Fainelli <florian@openwrt.org>
Date:   Thu Aug 25 21:33:48 2011 +0200

    ath9k: add missing AR9340 in ath_mac_bb_names
    
    AR9340 is not listed in ath_mac_bb_names, which leads to such a message:
    ieee80211 phy0: Atheros AR???? Rev:0 mem=0xb8100000, irq=2
    
    Signed-off-by: Florian Fainelli <florian@openwrt.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
