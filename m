Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51633 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758562AbZKJXPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 18:15:06 -0500
Subject: Re: [PATCH v3 11/20] mac80211: implement RANN processing and
 forwarding
From: Johannes Berg <johannes@sipsolutions.net>
To: Rui Paulo <rpaulo@gmail.com>
Cc: "John W.Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1E46D638-5BD4-4B59-9800-9A70595720B9@gmail.com>
References: <20091110134802.GA55552@asus-p5b.lan>
	 <20091110214350.GF12682@tuxdriver.com>
	 <1E46D638-5BD4-4B59-9800-9A70595720B9@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pxP3jNYQ22GoE2mVNu49"
Date: Wed, 11 Nov 2009 00:14:39 +0100
Message-ID: <1257894879.7037.70.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pxP3jNYQ22GoE2mVNu49
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-10 at 23:03 +0000, Rui Paulo wrote:
> Hi John,
>=20
> On 10 Nov 2009, at 21:43, John W. Linville wrote:
> > In file included from net/wireless/lib80211.c:19:
> > include/linux/ieee80211.h:566: error: =E2=80=98ETH_ALEN=E2=80=99 undecl=
ared here (not in a function)
>=20
> Hmm, I must've busted my testing procedure. I'm sorry.
>=20
> Anyway, I noticed that nothing uses ETH_ALEN in ieee80211.h and there
> are quite some places we could use it. Should we include if_ether.h in
> ieee80211.h (probably too evil) or should I just keep using 6 instead
> of ETH_ALEN ?

When John mentioned this I remembered falling into that trap before ..
maybe better to just keep using 6, sorry!

johannes

--=-pxP3jNYQ22GoE2mVNu49
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+fPbAAoJEODzc/N7+QmaU9UQANPa6VkaVs1Ccb7R0WdEOiTH
rEWEjwWoQsaMeKvFtv0rjkJaOROKwRLwmg85jFqwair+m0VAMi9CbaLNW/JglCd1
QTR0o5qJzn0YL/um5t7KS8kV+KlH1GjRtLNxcgIGFSjhvUub4S/KQDt10A+YvXN7
weTYjnD9znwOOEqUt92cicd17cDfDH3msk+6YdcKkrzTojXwsayQFcgmdm7xCAJt
IncnfdPnYlkA0Amw8aAD1ixUhURmHXakPsucZCU1r71C8i43c05hJmTygsRz9n4R
bu2MwZzoAlGxa6IUme8pVWZ7BhP3QmzQ6pofdaYTZ8y3+3UOFC2kCwRTUxkT20Q5
KltvrpksOeGT64Q0XddjJObgLb0DWIjcl1I1sZY3EKurV0mM4M1XrUBCOG5xF5HT
epFgJ9zufXrkTOAIs4U3MgolixfkZr4sHOezkG26UNbc97onixkTEpozrZbk4FuR
NU6QMPr8g63sRg+gHhVsu2OXr0lf/cCyyYdPeU20x32I6B+q8wLlR1UksNkUX0ko
DWauudM2DFx0O6pqsc69HhdKW44MHdGseDcGor3HS/+mhUfiGtXmaUwDpGuzy3kq
kxOXEGVmW/gW+kL821pEcmjjbASqwOXPGDOt9R6wmCym+0FZnN9p3VnGPI2wn7QP
BAJi3XRa7w8pEDtaYbui
=qy1s
-----END PGP SIGNATURE-----

--=-pxP3jNYQ22GoE2mVNu49--

