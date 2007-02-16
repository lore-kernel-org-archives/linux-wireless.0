Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946251AbXBPVOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 16:14:52 -0500
Subject: Re: [PATCH v2] d80211: Add software sequence support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070216135827.7d262ae3@griffin.suse.cz>
References: <200702141423.27823.IvDoorn@gmail.com>
	 <20070215215722.3db7f3ca@griffin.suse.cz>
	 <20070216130329.5f1dffee@griffin.suse.cz>
	 <200702161325.47396.IvDoorn@gmail.com>
	 <20070216135827.7d262ae3@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OCQ9GsWAQX2idSPczT1d"
Date: Fri, 16 Feb 2007 22:14:44 +0100
Message-Id: <1171660484.3575.34.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OCQ9GsWAQX2idSPczT1d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-02-16 at 13:58 +0100, Jiri Benc wrote:

> Both.
>=20
> When you have a WDS link and some other wireless interface at the same
> time, their source addresses are (in most cases) the same. You want to
> have the sequence control counter shared by them. Actually, it will
> probably work most of time even when they have different counters. The
> situation where it won't work is if you have two virtual interfaces,
> one in STA and second in WDS mode, both connected to the same AP. I
> can't figure out how this particular setup could be useful but it's
> generally not disallowed.
>=20
> Anyway, using different counter for a WDS interface probably violates
> 802.11 (although it's not much specific in this case). I believe it
> will work in most cases, though.
>=20
> Any ideas how to solve that?

Make the counter per-mac address?

johannes

--=-OCQ9GsWAQX2idSPczT1d
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1h7E/ETPhpq3jKURAmXSAKC5jyEAYXAecUGj1wwSwGZDOObvBgCeNxK8
Wt5SDsJQAZ6+LcOrAN34YIU=
=hOvV
-----END PGP SIGNATURE-----

--=-OCQ9GsWAQX2idSPczT1d--

