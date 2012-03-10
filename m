Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab2CJHfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 02:35:38 -0500
Subject: Re: [PATCH] mac80211: Disable MCS > 7 in minstrel_ht when STA uses
 static SMPS
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	nbd@openwrt.org
In-Reply-To: <CAJ-Vmo=WLa6Lc7u4fjPNDjVP5MT9+OJ-qNP-zBL+T=ajOHSN7g@mail.gmail.com> (sfid-20120310_074059_038114_F8B300B5)
References: <1331298825-22314-1-git-send-email-helmut.schaa@googlemail.com>
	 <CAGXE3d_58okToGOH146vDsgZ_Jf01iZAxDX0pxwBMGSo0BvZYg@mail.gmail.com>
	 <CAJ-Vmo=WLa6Lc7u4fjPNDjVP5MT9+OJ-qNP-zBL+T=ajOHSN7g@mail.gmail.com>
	 (sfid-20120310_074059_038114_F8B300B5)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Mar 2012 08:35:31 +0100
Message-ID: <1331364931.3348.0.camel@jlt3.sipsolutions.net> (sfid-20120310_083607_700740_578FC5D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-09 at 22:40 -0800, Adrian Chadd wrote:
> .. hm, I was wondering about SMPS. Why not RTS? Wouldn't that
> wake up the other RX chains?

(corrected to RTS)

That would be "dynamic SMPS", "static SMPS" means your chains are truly
turned off and can't even be revived by RTS.

johannes

