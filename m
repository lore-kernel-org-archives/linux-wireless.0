Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52225 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1H3SIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 14:08:40 -0400
Received: by fxh19 with SMTP id 19so5571352fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 11:08:39 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: add missing AR9340 in ath_mac_bb_names
Date: Tue, 30 Aug 2011 20:08:36 +0200
Cc: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
References: <201108252133.48605.florian@openwrt.org> <201108301101.27843.florian@openwrt.org> <20110830174810.GA2660@tuxdriver.com>
In-Reply-To: <20110830174810.GA2660@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201108302008.36262.florian@openwrt.org> (sfid-20110830_200843_489343_8CDEC154)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Tuesday 30 August 2011 19:48:11 John W. Linville wrote:
> On Tue, Aug 30, 2011 at 11:01:27AM +0200, Florian Fainelli wrote:
> > Luis, John,
> > 
> > On Thursday 25 August 2011 21:33:48 Florian Fainelli wrote:
> > > AR9340 is not listed in ath_mac_bb_names, which leads to such a
> > > message: ieee80211 phy0: Atheros AR???? Rev:0 mem=0xb8100000, irq=2
> > > 
> > > Signed-off-by: Florian Fainelli <florian@openwrt.org>
> > 
> > Can you pick this up? Thanks.
> 
> Did you actually check to see if it had been merged into wireless-next?

No I did not sorry about. For your information, David Miller mentions when a 
patch has been applied to his tree, would you mind doing the same?

> 
> commit 397e5d5b93ba99ad3dc56f1e294f487e77d2daa8
> Author: Florian Fainelli <florian@openwrt.org>
> Date:   Thu Aug 25 21:33:48 2011 +0200
> 
>     ath9k: add missing AR9340 in ath_mac_bb_names
> 
>     AR9340 is not listed in ath_mac_bb_names, which leads to such a
> message: ieee80211 phy0: Atheros AR???? Rev:0 mem=0xb8100000, irq=2
> 
>     Signed-off-by: Florian Fainelli <florian@openwrt.org>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>

-- 
Florian
