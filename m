Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:29939 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752137Ab0HBD7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 23:59:20 -0400
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0329651556
	for <linux-wireless@vger.kernel.org>; Mon,  2 Aug 2010 12:59:17 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 1/3] cfg80211: Add nl80211 antenna configuration
Date: Mon, 2 Aug 2010 12:59:16 +0900
References: <20100727094732.27186.30900.stgit@tt-desk> <201007291111.27417.br1@einfach.org> <AANLkTinH-2VNYGGBVha-M2HOzYJYe_GBb3Ww1V6i6Hyc@mail.gmail.com>
In-Reply-To: <AANLkTinH-2VNYGGBVha-M2HOzYJYe_GBb3Ww1V6i6Hyc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201008021259.16623.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri July 30 2010 00:09:17 you wrote:
> On Wed, Jul 28, 2010 at 7:11 PM, Bruno Randolf <br1@einfach.org> wrote:
> > i already tried to explain several times why FIXED_A, FIXED_B, or
> > DIVERSITY is not enough even for "legacy". please re-read the mails and
> > the description of the first patch - i really don't want to re-iterate
> > it *again*. thanks :)
> 
> What legacy device and respective device driver do we support upstream
> on the kernel that has this sort of extra antenna setup? Do you
> foresee this happening?

right now, probably none. but it's easy to this to ath5k. madwifi supported it 
and it's just a matter of setting tx and rx antennas (it's already there as 
AR5K_ANTMODE_DEBUG). i might add it, just to make my case... ;)

anyhow, i can see your point of view now. but while you might not care about 
anything before 802.11n - there are millions of what you call 'legacy' chips 
out there (and you guys are actually still selling them!), so i think it's 
worth it to properly support them, especially since i still believe that my 
proposal is usable for both 802.11n and before.

bruno
