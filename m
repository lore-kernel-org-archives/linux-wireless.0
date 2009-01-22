Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40305 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZAVPat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 10:30:49 -0500
Date: Thu, 22 Jan 2009 10:18:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Glenn Burkhardt <gbburkhardt@verizon.net>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
Subject: Re: poor performance with ath5k; reverting to ath_pci
Message-ID: <20090122151810.GB3646@tuxdriver.com> (sfid-20090122_163054_810842_10D70F21)
References: <200901202238.08756.gbburkhardt@verizon.net> <20090121151435.GB3643@tuxdriver.com> <69e28c910901211022j7f9c67dfv6392ce043dcff522@mail.gmail.com> <20090121191141.GA14710@tuxdriver.com> <69e28c910901211133n25c1a151nc9ca7172a9de7d3a@mail.gmail.com> <40f31dec0901212032j65371fc6j5fcc1952f841d2ef@mail.gmail.com> <20090122134958.GA27560@tuxdriver.com> <1232633075.4224.6.camel@johannes.local> <20090122141734.GA3646@tuxdriver.com> <69e28c910901220645l66b76875jbbf1cc74afe17aac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910901220645l66b76875jbbf1cc74afe17aac@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 22, 2009 at 03:45:58PM +0100, Stefanik G=E1bor wrote:
> On Thu, Jan 22, 2009 at 3:17 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Thu, Jan 22, 2009 at 03:04:35PM +0100, Johannes Berg wrote:

> >> The reason it was originally under EMBEDDED is that this allows yo=
u to
> >> turn off _all_ algorithms, and that breaks, but might be desirable=
 if
> >> you have a system where you know you're using iwlagn or ath9k only=
 which
> >> have their own algorithms.
> >
> > I see.  But currently it limits you to only one generic algorithm, =
the
> > one chosen as the default.  I don't think that was really the inten=
t?
> >
>=20
> I think RC_NONE should depend on embedded, but not the chooser itself=
=2E

That makes sense to me.

John
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
