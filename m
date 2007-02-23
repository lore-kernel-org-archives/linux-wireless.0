Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37374 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbXBWVDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 16:03:11 -0500
Subject: Re: [PATCH] d80211: create net/wireless/Kconfig and make nl80211   optional
From: Johannes Berg <johannes@sipsolutions.net>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <45DF5514.8000304@linux.intel.com>
References: <45DF518B.5060809@linux.intel.com>
	 <45DF5514.8000304@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dw3c2CkwAXSSJppXa1dS"
Date: Fri, 23 Feb 2007 22:02:58 +0100
Message-Id: <1172264578.3870.89.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dw3c2CkwAXSSJppXa1dS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-02-23 at 12:56 -0800, James Ketrenos wrote:
> Hold on applying.
>=20
> > +cfg80211-$(CONFIG_NL80211) +=3D nl80211.o
>=20
> Should have been
>=20
> cfg80211-$(CONFIG_CFG80211_NL80211) +=3D nl80211.o

Or maybe just rename it if it's already confusing you ;)

johannes

--=-dw3c2CkwAXSSJppXa1dS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF31aC/ETPhpq3jKURAl2fAKCiP7w7Qd2O2BKUzB3nNrfJHSPA4ACfTxyu
6fdDZLOvCYCoI1cAX07iODw=
=CETP
-----END PGP SIGNATURE-----

--=-dw3c2CkwAXSSJppXa1dS--

