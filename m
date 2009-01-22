Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55777 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZAVOaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 09:30:46 -0500
Date: Thu, 22 Jan 2009 09:17:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	Glenn Burkhardt <gbburkhardt@verizon.net>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
Subject: Re: poor performance with ath5k; reverting to ath_pci
Message-ID: <20090122141734.GA3646@tuxdriver.com> (sfid-20090122_153052_305593_93A44537)
References: <200901151734.46144.gbburkhardt@verizon.net> <b6c5339f0901160733u433b1154sfb8b5662c4fe991c@mail.gmail.com> <200901202238.08756.gbburkhardt@verizon.net> <20090121151435.GB3643@tuxdriver.com> <69e28c910901211022j7f9c67dfv6392ce043dcff522@mail.gmail.com> <20090121191141.GA14710@tuxdriver.com> <69e28c910901211133n25c1a151nc9ca7172a9de7d3a@mail.gmail.com> <40f31dec0901212032j65371fc6j5fcc1952f841d2ef@mail.gmail.com> <20090122134958.GA27560@tuxdriver.com> <1232633075.4224.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1232633075.4224.6.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 22, 2009 at 03:04:35PM +0100, Johannes Berg wrote:
> On Thu, 2009-01-22 at 08:49 -0500, John W. Linville wrote:
> > On Thu, Jan 22, 2009 at 06:32:55AM +0200, Nick Kossifidis wrote:
> > > 2009/1/21 Stefanik G=E1bor <netrolller.3d@gmail.com>:
> > > >
> > > > I think EMBEDDED is for options that replace full-featured Linu=
x
> > > > components with dumbed-down, "low-profile" equivalents (like SL=
OB) -
> > > > PID vs. minstrel is more like SLAB vs. SLUB.
> > > >
> > > > G=E1bor
> > > >
> > >=20
> > > Minstrell performs very well even on embedded devices, i don't th=
ink
> > > it's that heavy compared to pid.
> >=20
> > I think his point was that people should be able to select multiple
> > algorithms without having to select EMBEDDED.
>=20
> The reason it was originally under EMBEDDED is that this allows you t=
o
> turn off _all_ algorithms, and that breaks, but might be desirable if
> you have a system where you know you're using iwlagn or ath9k only wh=
ich
> have their own algorithms.

I see.  But currently it limits you to only one generic algorithm, the
one chosen as the default.  I don't think that was really the intent?

John
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
