Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbZLOPhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 10:37:05 -0500
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for
 libertas+cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
In-Reply-To: <200912151606.46549.hs4233@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
	 <200912151544.00402.hs4233@mail.mn-solutions.de>
	 <1260888730.10356.9.camel@johannes.local>
	 <200912151606.46549.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1vgtIJEyHuTpxNuu79Nr"
Date: Tue, 15 Dec 2009 16:37:02 +0100
Message-ID: <1260891422.10356.36.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1vgtIJEyHuTpxNuu79Nr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-15 at 16:06 +0100, Holger Schurig wrote:
> > I'd rather have new mesh commands. Right now, mesh
> > joining/leaving is implicit with interface up/down after you
> > set mesh parameters, but that's not very flexible.
>=20
> The mesh of Libertas' seems to be very different from "other"=20
> meshes, do you really want new nl80211 commands that seems=20
> almost proprietary?
>=20
> For example, "iw dev wlan0 set mesh_param" gives me lots of=20
> parameters, but none of them is a SSID. And many of those=20
> parameters don't seem to have an equivalent of Libertas' mesh.

Well the mesh_id is comparable in that case, I'd think.

But I don't really know.

johannes


--=-1vgtIJEyHuTpxNuu79Nr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLJ60aAAoJEODzc/N7+QmaansQAIsMPOKD5lCqu6fhGzQJJjf3
lQJa6q3vgSSAqgNzHP7GbsglfJsgu3YTc0nmBi8zsSAlR+45yXzLj92sTmuW8T9L
ql8id49d1s/25CSsiypq9k8LqPegF/6fuH19j7kKnvx6JaoB/ZMCg1rXLlL722Lj
ieKB07s5AsytGPmGPUD8pc5XXClOxtMJ7ZhU3bcQYt+b7S1ODyaFAtHMdAFZn3Ls
tK/ZhYghgRANx5+4O3J87tte9rSmV6bGxO3BnHoXXycnIN6SKRsC4LrMZWPdFQYc
fGEcwNK0/atR9BxYve3HG18KZvp5I+AM8SyOPykVTH1qZLusrsomvnaNUpmXQRss
9i0M3xK+nH2ZHpOxawMGd+zosKdmKfdcT7iKi+eBNo1tOXkQtpQiSTwqUIJSrvUw
kljgXoOFE20ALRqKnTAHC93XoYElQvYVXORYRgYe1wWvy17Xm7gJDLPhLxCrHsZJ
vGsEsbdudKI7rqPg0+87oiUD3WnLGN9HON5JkmVcQdl8k/+CJlvc3f5xoII2tJJM
KCaSO5wFMUZznx1MAGYZT2fRzoJeUmh8UM3tYQaeRlyYCUgJGG7R/m9xT9CeiH1P
OyP22YviG/ELZoUu1vQJjHyz7CsGDmnM0qLTy3xDekqZ9/YxRsriMlg+Ms0dHTEK
c8U/ADHFVIR/CYCV2oVb
=J2T2
-----END PGP SIGNATURE-----

--=-1vgtIJEyHuTpxNuu79Nr--

