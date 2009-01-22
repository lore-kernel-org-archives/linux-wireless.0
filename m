Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52142 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660AbZAVOAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 09:00:47 -0500
Date: Thu, 22 Jan 2009 08:49:59 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	Glenn Burkhardt <gbburkhardt@verizon.net>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
Subject: Re: poor performance with ath5k; reverting to ath_pci
Message-ID: <20090122134958.GA27560@tuxdriver.com> (sfid-20090122_150113_735117_2FF31F66)
References: <200901140003.31693.gbburkhardt@verizon.net> <200901151734.46144.gbburkhardt@verizon.net> <b6c5339f0901160733u433b1154sfb8b5662c4fe991c@mail.gmail.com> <200901202238.08756.gbburkhardt@verizon.net> <20090121151435.GB3643@tuxdriver.com> <69e28c910901211022j7f9c67dfv6392ce043dcff522@mail.gmail.com> <20090121191141.GA14710@tuxdriver.com> <69e28c910901211133n25c1a151nc9ca7172a9de7d3a@mail.gmail.com> <40f31dec0901212032j65371fc6j5fcc1952f841d2ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <40f31dec0901212032j65371fc6j5fcc1952f841d2ef@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 22, 2009 at 06:32:55AM +0200, Nick Kossifidis wrote:
> 2009/1/21 Stefanik G=E1bor <netrolller.3d@gmail.com>:
> >
> > I think EMBEDDED is for options that replace full-featured Linux
> > components with dumbed-down, "low-profile" equivalents (like SLOB) =
-
> > PID vs. minstrel is more like SLAB vs. SLUB.
> >
> > G=E1bor
> >
>=20
> Minstrell performs very well even on embedded devices, i don't think
> it's that heavy compared to pid.

I think his point was that people should be able to select multiple
algorithms without having to select EMBEDDED.

John
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
