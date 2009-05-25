Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47412 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZEYFNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 01:13:51 -0400
Subject: Re: [RFT 5/4] iwm: port to new cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <samuel@sortiz.org>
In-Reply-To: <1243214537.24825.703.camel@debian>
References: <20090521215940.344214804@sipsolutions.net>
	 <1243068775.4606.56.camel@johannes.local>
	 <1243214537.24825.703.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EHXhWLiqqJxq3gsQHpBu"
Date: Mon, 25 May 2009 07:13:41 +0200
Message-Id: <1243228421.29222.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EHXhWLiqqJxq3gsQHpBu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-25 at 09:22 +0800, Zhu Yi wrote:
> On Sat, 2009-05-23 at 16:52 +0800, Johannes Berg wrote:
> > Which means removing all rfkill code since it only does
> > soft-kill which cfg80211 will now handle in exactly the
> > same way the driver did.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> Looks good to me. I think we can remove the "select RFKILL" in Kconfig
> also.

Indeed, thanks.

johannes

--=-EHXhWLiqqJxq3gsQHpBu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKGikAAAoJEODzc/N7+QmaZxUP/Au8/ZPGzx9ZHFWkD8nYq8y0
U0cIwb97T6ZkLcbG9LZhCuSAYZ/t/jeembK5cp8IiaeN43DUZEokbZVyeZscUzje
bRGGLVTeZgkXgIe/3F0afQOu3MFMkhlzq8TlQB5QEY3bCRE8Y1CIMxKEbRq70Ikr
KUm1JcuMI+3RpTtFq4DV2OvbqxbdUcyqD4JWL5d5BOrVppXcYuL9mb1VZ1pJbfGU
27RtUr404lwdcdxrHWU9gwZ+6CtrBg1HhzgcVhhYwbJVT0Pddl2EIrr2qVGULnQ2
s90GGONrx4MsDcRQiO7/eJUF9CltX3tdyBGUTh8gOR7lMJ7fUcf1RJ0nbA8BPrK+
iZryKUXRnZAwuTPRnsTVAwVbjA/mczJLCHJhdnuashf/YeOL2wAkGgasFl2dMp5M
HqhOsXy6Ue4XmkQTL5ZwAAUBX53/3mATHboKklm9fuaUMPITr09hYVXTzeWYdwvS
aX72mqc6eVs4L09tjWr31fSsM10Zvy9KFyAJf4UJm+1fVqMmCs85EALS4UOwA4lr
5KkVVI4bG3wC7lxhuN6ETuNRAa4m92u5AGnFFIdBvrkOtisZk1Kv3YQBEyS5blXC
TwZy9Ezs3+jLAM2aVhAk24jHoBRLzlxW+vJXM8HxnQ0txj6tsRecKZLOhC+s10Cz
WZZdKDv83luKSVAwtvip
=pFRQ
-----END PGP SIGNATURE-----

--=-EHXhWLiqqJxq3gsQHpBu--

