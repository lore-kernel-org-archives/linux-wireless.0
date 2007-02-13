Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48461 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbXBMTEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 14:04:39 -0500
Subject: Re: [PATCH] prism54: correct assignment of DOT1XENABLE in WE-19   codepaths
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1171393222.5329.11.camel@localhost.localdomain>
References: <1171393222.5329.11.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C67BjNKW2pXgzFB+uYDJ"
Date: Tue, 13 Feb 2007 20:02:11 +0100
Message-Id: <1171393331.10344.106.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C67BjNKW2pXgzFB+uYDJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-02-13 at 14:00 -0500, Dan Williams wrote:
> Correct assignment of DOT1XENABLE in WE-19 codepaths.
> RX_UNENCRYPTED_EAPOL =3D 1 really means setting DOT1XENABLE _off_, and
> vice versa.  The original WE-19 patch erroneously reversed that.  This
> patch fixes association with unencrypted and WEP networks when using
> wpa_supplicant.
>=20
> It also adds two missing break statements that, left out, could result
> in incorrect card configuration.
>=20
> Please commit to both development and stable branches.

I guess it could also be applicable for stable?

johannes

--=-C67BjNKW2pXgzFB+uYDJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF0gsy/ETPhpq3jKURAomrAJ9+spk+YcwB1y6QqRA9Z5kARkRMpACfTj4W
6wHcJ/Bh0CAXGpJrPTdNd08=
=m06P
-----END PGP SIGNATURE-----

--=-C67BjNKW2pXgzFB+uYDJ--

