Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37422 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab0BOOol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 09:44:41 -0500
Subject: Re: [PATCH 1/2] mac80211: Improved IBSS merges
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Benoit Papillault <benoit.papillault@free.fr>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100215134023.GA11947@jm.kir.nu>
References: <1266190435-2355-1-git-send-email-benoit.papillault@free.fr>
	 <20100215134023.GA11947@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wxPYsyBCFRj8jC4GzXZb"
Date: Mon, 15 Feb 2010 15:44:38 +0100
Message-ID: <1266245078.5081.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wxPYsyBCFRj8jC4GzXZb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-15 at 15:40 +0200, Jouni Malinen wrote:
> On Mon, Feb 15, 2010 at 12:33:54AM +0100, Benoit Papillault wrote:
> > According to $11.1.4 from IEEE 802.11-2007, TSF is reset
> (drv_reset_tsf)
> > on MLME-JOIN, ie only when a new IBSS is created or if an existing
> IBSS
> > is joined, but not on IBSS merges.
>=20
> While that may indeed be what the standard says, drv_reset_tsf() may
> be
> needed to allow the driver to actually learn the new timestamp
> correctly
> in the case of merge. Have you verified that the drivers that support
> IBSS do indeed update their timestamps without that call in case there
> is a large difference in the timestamp values that the separate IBSSes
> used before the merge?

Good point. Also, it shouldn't hurt to always reset it, so what's the
point?

johannes

--=-wxPYsyBCFRj8jC4GzXZb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLeV3SAAoJEODzc/N7+QmaV5IP/2/lE3Pg/sZKLNoTaau7zay4
TQfkOFfbdtNiybKHfGk4yEgPXNfcOXKXNbzNQXC/Q+LIoHPIdxo1p9dRlz+xMC0W
KpgZGAvvHUuD9jRgrpukOSEGMWKAmEFPnZj2yCyOPP/fXMH/VVw6q0lvlazue2SW
KpdgHgysTrerQ+ZxNKoVhBzpYOSYAQlV/2+jkMN6vGV8KssqwfRryFKJJlPEKtcY
WZRa2iw2GxHzNl/KeFRHkpAfsz7d4KypmcRSssIzgWAKWQc0NJvfRe2R24X20pl4
w+lP43F1FlKxEOeWJFzJwtWZjE5uM77tHB98Xv2zE1YRuMGzYoxTv+jj5ZUDA0Gt
skQuPlrhFebw9hbUKwRskkPAiqzF0YYSxgWdu3U7MFcaP1QRZkBeiTAqCjA/jpDi
yjvtDug9EfcuBc738Tz0ICNeTW9Jc+WhzonR2lHJWg302hySM1n5R/WV7Ur4IvvT
vZr0b+29RP7WnPIcXOXcTvo0xJyjiiFqG0RfmdVXwgMZGzKFPp84VAh9aTc+EppP
v7TLtbw+lzVfOZhmpjGh40Apt+dxDFVp7IeDF1zwo8wHr/uDwrIJnSaEcrEl4qAV
CVbtK5vC0dEWNn6eGsyf50SU4M+miZGT5yRmLeevslctxfcVkN6OrNH+5AVjac65
K2vYh8LpTdVNh1Dax7eP
=Ad+1
-----END PGP SIGNATURE-----

--=-wxPYsyBCFRj8jC4GzXZb--

