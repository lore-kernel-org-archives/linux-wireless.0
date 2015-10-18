Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57515 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734AbbJRScF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 14:32:05 -0400
Message-ID: <1445193116.31451.78.camel@decadent.org.uk> (sfid-20151018_203212_908422_35A5705E)
Subject: Re: [PATCH 1/5] ath10k: QCA988X hw2.0: add board.bin
From: Ben Hutchings <ben@decadent.org.uk>
To: Kalle Valo <kvalo@qca.qualcomm.com>, linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Sun, 18 Oct 2015 19:31:56 +0100
In-Reply-To: <1445192636.31451.74.camel@decadent.org.uk>
References: <1444905644-16296-1-git-send-email-kvalo@qca.qualcomm.com>
	 <1445192636.31451.74.camel@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-NzPf6A/jMeFiavFvmkTH"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NzPf6A/jMeFiavFvmkTH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2015-10-18 at 19:23 +0100, Ben Hutchings wrote:
> On Thu, 2015-10-15 at 13:40 +0300, Kalle Valo wrote:
> > In commit 40d14143b787 ("ath10k: add firmware 10.2.4.45 as firmware-4.b=
in") I
> > forgot to commit board.bin file and that's why it was not included in t=
he
> > commit even I had added an entry to WHENCE. Add that now.
> >=20
> > At the same time also add Version field for firmware-4.bin.
> >=20
> > Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> [...]
>=20
> I've applied this and the following 4 patches. =C2=A0However, I'm not
> entirely happy with copyright acknowledgements going into the
> notice_ath10k*.txt files which aren't referenced anywhere. =C2=A0It would=
 be
> easy for downstream distributors to miss that they should be packaged
> along with the firmware blobs they relate to. =C2=A0Please can you combin=
e
> these with the QCA licence file or add references to these files from
> WHENCE?
>=20

Also please make sure that all text files are encoded as UTF-8 (or
ASCII). =C2=A0A couple of the notices had quote characters which I
eventually worked out to be GB2312-encoded.

Ben.

--=20
Ben Hutchings
A free society is one where it is safe to be unpopular. - Adlai Stevenson
--=-NzPf6A/jMeFiavFvmkTH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAViPlnOe/yOyVhhEJAQq0LQ//UBT1r3CBNjLGZ8zI2pxvEY+wvO2GHGnT
G92zw8td7FnA+tjIRgFolP5j5C+jK+YU7m2IXywJHiTagUBUG+Ea4rMIZNaO7kv7
BSWqrc/JPr8lyYUv379iRMM+nDb5PySomv9VXCBbcaP27QFI9LM1cJi+APvZqXgy
OF9y5XZcoFRwvU8Cg9Ze5WDOoOhv9G5iuvBbDVxZkRQUpY2pGivYv+eth7AUr4il
P/TpRN53kw5cwqSEJJi73dC9htf9htHz/uqnPxm1lI3GXr0mnxBVfqYw909RTMUd
XyAxy/iWqzQ5EXe16pWdYrEBFqEbVE1Q7c9g4LJDYsO/TdNsVZC55cAHYWkLnVwD
htvy2c+z+sEO3NSCj2uNYNWGKXkyrB0GhJvX9E2Fjdo479PL3Wpxlo51/+4EpTcZ
9K0O7rwEX7lY/PaPG+H8IdQynmRNb1DxLhIX7C6gmk2ezacGl/sziVWBR6p7svIG
DNvD/FrPK1xhrhyJSZdB+bKqJWirc1BQyGSHG5rpMOjsjYp0cgq/QguC66/h0Sjl
WFv3DFrTBUaKGVw0mUVue8wgfrZe4gkwNh/J4NPbVEegU2mDISSwIqGQZ123dRlv
rXaWASpGb0xsVJ1DfEdiZz5OXLKvcZAnrNEm5EKkkip8a4AtNe23uEP2RoXAjEsE
jvIDA030C/8=
=tp5S
-----END PGP SIGNATURE-----

--=-NzPf6A/jMeFiavFvmkTH--
