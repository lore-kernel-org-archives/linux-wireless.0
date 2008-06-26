Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4451 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758312AbYFZRrT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 13:47:19 -0400
Date: Thu, 26 Jun 2008 13:36:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Pavel Roskin <proski@gnu.org>,
	Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>, cs010101@gmail.com,
	linux-wireless@vger.kernel.org
Subject: Re: [Q] ath5k : doesn't support AP mode?
Message-ID: <20080626173645.GB22075@tuxdriver.com> (sfid-20080626_194730_970695_0BE1096A)
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3> <69e28c910806260846s3b02cdddlca3ac138acadd8bd@mail.gmail.com> <1214496086.30722.14.camel@dv> <200806261821.31643.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200806261821.31643.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 26, 2008 at 06:21:31PM +0200, Michael Buesch wrote:
> On Thursday 26 June 2008 18:01:26 Pavel Roskin wrote:
> > On Thu, 2008-06-26 at 17:46 +0200, Stefanik G=E1bor wrote:
> >=20
> > > Maybe we had more people working on/debugging AP mode if we didn'=
t
> > > intentionally disable the existing limited support for it... Poss=
ibly
> > > print a big warning that "THIS IS NOT STANDARDS_COMPLIANT YET!", =
but
> > > outright disabling it and requiring an external patch is IMHO stu=
pid.
> > > Perhaps a Kconfig option with EXPERIMENTAL and default=3Dn would =
be
> > > better.
> >=20
> > I agree.  More people would be looking into AP support for individu=
al
> > drivers if mac80211 didn't need a patch.
>=20
> I'd also like to get something like the following merged:

> Subject: mac80211: allow AP and VLAN modes
>=20
> This patch is based on a patch by Johannes Berg.
> It allows switching interfaces into AP/VLAN modes using
> cfg80211 (nl80211). Don't allow doing it with wext because then
> people will just attempt to do it manually (without hostapd) and
> complain that it doesn't work.

I dunno...that last thing I want is to let this go in and then be
locked-in to the current API no-matter-what like we now are with WEXT.

John
--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
