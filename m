Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758078AbZEDQSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 12:18:12 -0400
Subject: Re: [PATCH] add basic support for parsing country information
 element
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241453361.2903.15.camel@localhost.localdomain>
References: <1241413787-3185-1-git-send-email-marcel@holtmann.org>
	 <1241423772.8683.8.camel@johannes.local>
	 <1241423924.8683.9.camel@johannes.local>
	 <1241427107.2899.9.camel@localhost.localdomain>
	 <1241435567.8683.35.camel@johannes.local>
	 <1241437035.8683.37.camel@johannes.local>
	 <1241452364.2903.3.camel@localhost.localdomain>
	 <1241452664.8683.51.camel@johannes.local>
	 <1241453361.2903.15.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-F559KpTBdY+uZVWzkhxg"
Date: Mon, 04 May 2009 18:17:42 +0200
Message-Id: <1241453862.8683.59.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F559KpTBdY+uZVWzkhxg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 09:09 -0700, Marcel Holtmann wrote:

> > Certainly. I just don't want to have it crash on an AP that advertises
> > completely bogus information :)
>=20
> if nobody beats me to it, then I will fix this. Just have to deal with
> some other stuff first.

Alright, thanks. Not too pressing I guess. Just should be done before I
cut the next release.

> tried the RSN/WPA2 too, but it is too long :)
>=20
> On a different note, what is your preferred coding style for loops?
>=20
> 	for (i =3D 0; i < len; i++) {
>=20
> or
>=20
> 	for(i=3D0; i<len-3; i++)
>=20
> I was using the latter one since I assumed that is what you want (it is
> not my preferred one). Then I realized that you are using both or that
> something slipped in. Do you want me to send a patch to fix this?

Oh, well, I prefer the former, but some other people put in the latter,
and I didn't really care too much. No need to send a patch though.

johannes

--=-F559KpTBdY+uZVWzkhxg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/xUhAAoJEKVg1VMiehFYdaEP/2eWbfpKcjtRixC35Zgqvj5I
gVLVCVTz2o6dynTQNo3S9+L9iHSbaBbIvcdogBgy9Dc+XZ/6irNVCm2vEur50Ndm
9eteC60fklUscwL/x7a1/xcQE3OO5zu4VXhz/3wJTS16WeupIRZa5yOL+LNXERwG
LcpHGLv3nOwOGEmsvMdk4cbX7s9IfwGXg6rKkklOycq16h4d1xfjDWyQmNTkvpcX
kmawSwP9rR8/bBQoECFeBNxq2YaxHp8LWrbXsBkzQiz0P7alvfAWTcARmdA8Cfwp
p1A2gESBM/hAujvcFAom2X2/bGYsMUz3iGUDsFghrL43r8DbJGpTMu8xJGJBuNJW
5dKFCy+m4cNvv19MNlUwbA2XGP/TFiGzaCD6YBiPmSofXaLSLieqbR9TJQPnGVqe
6EqGXsQalvjkQ5+guRQxnWtDfWx5iekQvJf+YeQeTHMnpJWkM30TK0hYqqsPbCPe
n0+R7RmZDOH7/FjCQXL13Wd9rYfF/XBNLvD6rsFPKYLDFl/iXzySX1jwDxnKrB7L
XJe42VnKui+J237/NSxI6rAfAPZacsKIcRcRe13jxZNeI1c1bgsLWg7mwAbAo23Z
E0NVlWfJr82McWKSVE0aIAiEkxee3jSQF3yleUfN2X8N16uBuYH5d9WmIjh5BEv3
NE+1CmOlxiZ2hGetV6Tu
=eJ3B
-----END PGP SIGNATURE-----

--=-F559KpTBdY+uZVWzkhxg--

