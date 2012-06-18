Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58153 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab2FRPER (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 11:04:17 -0400
Message-ID: <1340031856.4615.10.camel@jlt3.sipsolutions.net> (sfid-20120618_170421_374309_78C99192)
Subject: Re: [PATCH 0/7] nl/cfg/mac80211: add DFS master ability
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 18 Jun 2012 17:04:16 +0200
In-Reply-To: <CAK80WHYDTiAYDD91RUE+V60iogEeKct2o9qLg7Y_iCZHjp+z9A@mail.gmail.com>
References: <1340030798-28992-1-git-send-email-victorg@ti.com>
	 <1340031558.4615.9.camel@jlt3.sipsolutions.net>
	 <CAK80WHYDTiAYDD91RUE+V60iogEeKct2o9qLg7Y_iCZHjp+z9A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-18 at 18:02 +0300, Goldenshtein, Victor wrote:
> On Mon, Jun 18, 2012 at 5:59 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2012-06-18 at 17:46 +0300, Victor Goldenshtein wrote:
> >> In continuation to proposed RFC, this patch set (with hostap patch
> >> series) adds support for DFS (Dynamic Frequency Selection) according
> >> 802.11h.
> >
> > Please fix coding style in this patchset first. There are various places
> > with bad indentation etc.
> >
> > johannes
> >
> 
> I have checked all patches with checkpatch, zero warnings.
> Maybe only the cover letter has some style problems?

checkpatch isn't a replacement for reviewing code :-)

try --strict anyway

e.g.

+       if ((!(chan->flags & IEEE80211_CHAN_RADAR) || !dfs_supported) &&
+           ((chan->flags & (IEEE80211_CHAN_NO_IBSS | IEEE80211_CHAN_RADAR |
+           IEEE80211_CHAN_PASSIVE_SCAN))))
                goto fail;

johannes

