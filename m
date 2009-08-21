Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54587 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbZHUVX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 17:23:57 -0400
Subject: Re: mac80211: reassociate in STA mode after AP was power-cycled
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Albert <jal2@gmx.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A8F0D8D.7000508@gmx.de>
References: <4A8F0D8D.7000508@gmx.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-b4xi6RA0jNszi4z6cYNI"
Date: Fri, 21 Aug 2009 23:23:56 +0200
Message-Id: <1250889836.4600.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-b4xi6RA0jNszi4z6cYNI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-21 at 23:11 +0200, Joerg Albert wrote:
> I had a ar9170usb device in STA mode associated to an AP and power-cycled=
 the AP - slowly enough to get the
> STA disassociated.=20
>=20
> I wonder why the STA doesn't re-associate again to the AP once it's up ag=
ain. Waited for 5+ minutes.

It told userspace that it disconnected, and as such it can't do anything
any more. Just run wpa_supplicant.

johannes

--=-b4xi6RA0jNszi4z6cYNI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKjxBoAAoJEODzc/N7+QmabqsP/2UH5kNqgA9Yvlyf7KPVAjhI
dNTB59LIMk+JfRCwE56zgx9R5sxibKuJiO7CBuq1w4/hXBFtrxdOLxHlYkBPzliR
MbRppCTqJSnnQT374nFaNrN7cVVg54oXKrZ1Mzbp2bFWpceEYdLCPf7ob9mciv5s
rPOuI7pir1yjtXYFKpCeVWpItL2QGmwxPDA93JYEQMGCpt6dggROZ4Umawow25VQ
ba/qPHpm+2l5ZPCu7xuOIx2s852PxUHZSTLbv9nMp1urI322yxYAwhkylCVIyfkB
ry+fOHFQOPMn9QzVKBWTdxHNbgdra9gpiGkM4NOQOFWdhsEpLptSLzPKMaJ40CQl
6PiIO/fHpyM3IX1tJ8vdhv8/tFUJsYmpQmZY/s8egKNRB71zJ7lmY6hpWIRu4+fK
U/bFVf4PDW2YEzpTVL9uAvEy9diGTtGIErNRzgd42PheltJGHFLRMl5NhSz9I4UQ
1pMVp5IubuICgCfHEVzp3CP2uUP//N3vZ1ykws3HgKK7/K9sIkMRPw8tKRl7BS8d
U02OAxRO9NnXPH2DIUs3H+GQMh44zxsmxoSBfRXhk0vS0QoUy/YttqG/vZuVxY9C
a03JFPDYYQ+FUaHxHe/VsgbvLjM3EswiNm6TDIodyd7t6Q61enJtmi2OWYaTdfli
WyxzPLieP0cbucbXtwIK
=MAW/
-----END PGP SIGNATURE-----

--=-b4xi6RA0jNszi4z6cYNI--

