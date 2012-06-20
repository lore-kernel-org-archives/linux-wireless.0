Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:43368 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756634Ab2FTMED (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 08:04:03 -0400
Received: by lboj14 with SMTP id j14so555202lbo.35
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 05:03:56 -0700 (PDT)
Message-ID: <1340193834.1631.227.camel@cumari.coelho.fi> (sfid-20120620_140414_435967_84F0CBA1)
Subject: Re: [PATCH 0/7] nl/cfg/mac80211: add DFS master ability
From: Luciano Coelho <coelho@ti.com>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, adrian.chadd@gmail.com, j@w1.fi,
	assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Wed, 20 Jun 2012 15:03:54 +0300
In-Reply-To: <CAK80WHbX795ewfKTqFe8D19w3g1mkvni-fX+Et98guC54kD8RQ@mail.gmail.com>
References: <1340030798-28992-1-git-send-email-victorg@ti.com>
	 <4FE1A734.4090100@neratec.com>
	 <CAK80WHbJZMsoV625hT_sQaEvVx3A5XC8M7PH6KfjdCx=MhdtEw@mail.gmail.com>
	 <1340189345.4655.56.camel@jlt3.sipsolutions.net>
	 <CAK80WHbX795ewfKTqFe8D19w3g1mkvni-fX+Et98guC54kD8RQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 14:02 +0300, Goldenshtein, Victor wrote:
> On Wed, Jun 20, 2012 at 1:49 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2012-06-20 at 13:47 +0300, Goldenshtein, Victor wrote:
> >> On Wed, Jun 20, 2012 at 1:34 PM, Zefir Kurtisi
> >> <zefir.kurtisi@neratec.com> wrote:
> >> > On 06/18/2012 04:46 PM, Victor Goldenshtein wrote:
> >> >> In continuation to proposed RFC, this patch set (with hostap patch series) adds support for DFS (Dynamic Frequency Selection) according 802.11h.
> >> >>
> >> >> [...]
> >> >
> >> > Thanks for the updated patches, Victor.
> >> >
> >> > Going to test them by preparing the ath9k interface.
> >> >
> >> > Right now they do not apply on top of wireless-testing, could you please
> >> > rebase? Thanks.
> >>
> >> The patches are on top of the master branch from:
> >> git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
> >
> > Why would you use that instead of mac80211-next?
> >
> 
> Will rebase on top of the mac80211-next.

Sorry, I think this was my mistake, because I told Victor to use this
tree.  I associated mac80211.git with wireless-testing.git.  Now I
realize that mac80211.git is like wireless.git (ie. contains patches
that should go to the current kernel, at the moment, 3.5).

I guess the best thing to do is to keep basing mac80211 patches on top
of linux-wireless.

--
Luca.

