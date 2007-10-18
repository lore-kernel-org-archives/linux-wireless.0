Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60858 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765018AbXJRLzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 07:55:24 -0400
Subject: Re: [PATCH] mac80211: make ieee802_11_parse_elems return void
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071017140444.GA5744@tuxdriver.com>
References: <1192588723322-git-send-email-linville@tuxdriver.com>
	 <1192608911.8841.6.camel@johannes.berg>
	 <20071017140444.GA5744@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OleWsM74qjWBtFDRruKi"
Date: Thu, 18 Oct 2007 13:56:17 +0200
Message-Id: <1192708577.15285.0.camel@johannes.berg> (sfid-20071018_125532_286528_8B8BBCE2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OleWsM74qjWBtFDRruKi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-17 at 10:04 -0400, John W. Linville wrote:
> On Wed, Oct 17, 2007 at 10:15:11AM +0200, Johannes Berg wrote:
> > On Tue, 2007-10-16 at 22:38 -0400, John W. Linville wrote:
> >=20
> > Looks good to me, but
> >=20
> > > -	/* Do not trigger error if left =3D=3D 1 as Apple Airport base stat=
ions
> > > -	 * send AssocResps that are one spurious byte too long. */
> > > -
> > > -	return unknown ? ParseUnknown : ParseOK;
> > > +	return;
> >=20
> > huh?
>=20
> You don't like the bare return at the end?  Or are you questioning
> something else?

Bare return at the end of a void functions seems.. pointless.

johannes

--=-OleWsM74qjWBtFDRruKi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxdJ4KVg1VMiehFYAQKuyA/+MIO/b83lM+bCSfex/MfQoK4TrpAWos9r
KXEdIBcZDEbTId8cxMiQsY8tJh73wasEvJbY5on4Rh2RIDV0xH4oO8b036ThgMOT
P0m17p0CkH5sLozaafHCPTIWdm0EHEq9+r+bSYelVs6rXLhXpgLoxuXzSXvsX5JP
LPBltEiFtemgAeu//N+k1H2694DYA0C/rra0wy3WmkXsqKJEb+0nhdypWh8+YEg1
6hpLrTAg35pOeiouo0tXVDE/xRCFCDdagLH/arTTzGT5FiSKSmw/DT6owA0zQWUK
kxlvZAKky88oczl6toymBIfVLWJKpA+WADcvDEZ8/eVl4uX9t2wqgQDZqjVeWp6F
TkDrg09V2z//9JgIMVYaM22Hi9Y1Uttwg4GgsmVcHcunrs2ETE/529agfEZZPNvp
yyD+yEaDhNtibZ4Qrzhhez8MvIbdNaDvOjA5l8ulGgI4MFlEpBU8+V/a3Hdf9D4l
wcUipbHNQwjNLyuKxCur034U9y0nGJJEsa1aTwvaTk4ZCZ5jJgsnI9IXxHvZzyqL
UYfkFwXsTobqw5YAiWw+0DiFhiD6GdcahYlxFN/whLj/6+z/PFMOo6wlNGeNWqUd
vfMYT2caNAPLkD4IYskcTHw9K/aOGIwMhyavsRfA/4AIgAPvWB3RinwJqu2n0uWD
knWv+c16bXI=
=2Sbw
-----END PGP SIGNATURE-----

--=-OleWsM74qjWBtFDRruKi--

