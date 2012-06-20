Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55958 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2FTKtL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 06:49:11 -0400
Message-ID: <1340189345.4655.56.camel@jlt3.sipsolutions.net> (sfid-20120620_124914_910503_420EC6E1)
Subject: Re: [PATCH 0/7] nl/cfg/mac80211: add DFS master ability
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Wed, 20 Jun 2012 12:49:05 +0200
In-Reply-To: <CAK80WHbJZMsoV625hT_sQaEvVx3A5XC8M7PH6KfjdCx=MhdtEw@mail.gmail.com>
References: <1340030798-28992-1-git-send-email-victorg@ti.com>
	 <4FE1A734.4090100@neratec.com>
	 <CAK80WHbJZMsoV625hT_sQaEvVx3A5XC8M7PH6KfjdCx=MhdtEw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 13:47 +0300, Goldenshtein, Victor wrote:
> On Wed, Jun 20, 2012 at 1:34 PM, Zefir Kurtisi
> <zefir.kurtisi@neratec.com> wrote:
> > On 06/18/2012 04:46 PM, Victor Goldenshtein wrote:
> >> In continuation to proposed RFC, this patch set (with hostap patch series) adds support for DFS (Dynamic Frequency Selection) according 802.11h.
> >>
> >> [...]
> >
> > Thanks for the updated patches, Victor.
> >
> > Going to test them by preparing the ath9k interface.
> >
> > Right now they do not apply on top of wireless-testing, could you please
> > rebase? Thanks.
> 
> The patches are on top of the master branch from:
> git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git

Why would you use that instead of mac80211-next?

johannes


