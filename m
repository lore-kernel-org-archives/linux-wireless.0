Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24811 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZLRQXL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 11:23:11 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2009 08:23:11 -0800
Date: Fri, 18 Dec 2009 08:23:09 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Shahar Or <mightyiampresence@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: add support for Dell Vostro A860
 LED
Message-ID: <20091218162309.GD6231@tux>
References: <bf87febf0912030507u1c36f6a9h7cac0efabf3d016@mail.gmail.com>
 <20091204192315.GA5786@tuxdriver.com>
 <bf87febf0912070205k40a7286dpbb48cfcc494203d2@mail.gmail.com>
 <20091207215903.GC18939@tuxdriver.com>
 <b6c5339f0912080657s7cfccd4dp6525702e609bdd5f@mail.gmail.com>
 <43e72e890912080801s52607743s738ed6cdad7d154e@mail.gmail.com>
 <20091208160659.GG15172@tuxdriver.com>
 <43e72e890912080830v40ff214co178fb17c38439e70@mail.gmail.com>
 <bf87febf0912180342w134d92eblc24f326cfa751b08@mail.gmail.com>
 <43e72e890912180737s382c24c5q8720f1e3138fefb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <43e72e890912180737s382c24c5q8720f1e3138fefb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 18, 2009 at 07:37:24AM -0800, Luis Rodriguez wrote:
> On Fri, Dec 18, 2009 at 3:42 AM, Shahar Or <mightyiampresence@gmail.com> wrote:
> > On Tue, Dec 8, 2009 at 6:30 PM, Luis R. Rodriguez
> > <lrodriguez@atheros.com> wrote:
> >>>> IIRC this is all mapped in the INF file, I thought I had released an
> >>>> INF file under the ISC license but it seems that's not the case, I can
> >>>> try to do that if it helps. Anyway, if we can move this sort of map to
> >>>> userspace it'd be neat as you'd just need a userspace file update.
> >>>> Only thing is how to do this in a generic way for all wireless drivers
> >>>> and if this is indeed useful for other drivers.
> >>>
> >>> Export something through sysfs and use a udev rule?
> >>
> >> True. Is sysfs the preferred fs nowadays, what about configfs? Or
> >> maybe even udev rule --> nl80211 ?
> >
> > If we have all the IDs from the INF file, then why do we need this in
> > userspace? Is the list growing?
> 
> No, but for other newer hardware/drivers it can likely grow, so my
> comment was more of a generic driver approach to this.

Actually AR2425 still sells it seems, so yeah I guess it can grow even
for ath5k.

  Luis
