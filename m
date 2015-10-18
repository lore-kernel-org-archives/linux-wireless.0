Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57474 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393AbbJRSYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 14:24:12 -0400
Message-ID: <1445192636.31451.74.camel@decadent.org.uk> (sfid-20151018_202416_133447_2397BAFE)
Subject: Re: [PATCH 1/5] ath10k: QCA988X hw2.0: add board.bin
From: Ben Hutchings <ben@decadent.org.uk>
To: Kalle Valo <kvalo@qca.qualcomm.com>, linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Sun, 18 Oct 2015 19:23:56 +0100
In-Reply-To: <1444905644-16296-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1444905644-16296-1-git-send-email-kvalo@qca.qualcomm.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vdJEA4LPcNMYdiDMFA4s"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vdJEA4LPcNMYdiDMFA4s
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-10-15 at 13:40 +0300, Kalle Valo wrote:
> In commit 40d14143b787 ("ath10k: add firmware 10.2.4.45 as firmware-4.bin=
") I
> forgot to commit board.bin file and that's why it was not included in the
> commit even I had added an entry to WHENCE. Add that now.
>=20
> At the same time also add Version field for firmware-4.bin.
>=20
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
[...]

I've applied this and the following 4 patches. =C2=A0However, I'm not
entirely happy with copyright acknowledgements going into the
notice_ath10k*.txt files which aren't referenced anywhere. =C2=A0It would b=
e
easy for downstream distributors to miss that they should be packaged
along with the firmware blobs they relate to. =C2=A0Please can you combine
these with the QCA licence file or add references to these files from
WHENCE?

Ben.

--=20
Ben Hutchings
A free society is one where it is safe to be unpopular. - Adlai Stevenson
--=-vdJEA4LPcNMYdiDMFA4s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAViPjvOe/yOyVhhEJAQo/oQ//dzw4c4bjNVcTg7r2PxHNUgPTFmQFCIUL
rJN3ZYLeqzlF5c9Fs49DfMhTJ9uSem/x2zOpTlch0wZfBWL/H2l3F2EPJZsaBfzx
ymDnrO5A0Kf45sUiuEkR5dLG5PMziiQpYKyRWVNymREtTypOyy2FeB42GvVP3r9H
uXR/NAXehfLwHYoE9XWv8QXSiZy+uFNrY9A3+qK3wXlOWkFkWdqgWnLu47Eck64p
MS3HsSDmUAgAQw0Q/kT681ynBcNBpyuHgwkn17IVQqx2F+ofeAG+m0A78/0wul1F
edlF6eHa7UBl6dWrgclE/BrN2HjhOUbhlMwfOprEhdW96C+YDSlChK9IBWZdMUD6
bBbx0UyZy/TLMVib3ffiq4moTWYVh3ymoz5WXGq45QLsMY7j0V2aPlxNo18IdT61
7/eZnSqYj7k0XWtP/3qoGoTW1lno0yLzzrplxrYud3OwplVvwcFs169mvTqrc0qv
bsvFjox9DdD+4XmwMeifB5QAKBEwyf6LJ7CRSosgdJdnHYO2zP+X87PDz1tduBqm
pBwGaKxlB/VTiNN15d461RLyhQ/WttvcvXmGoLdw8AtMpUhbqYZJgvk6k7Jfur/i
GBIuOe+di1GRAi2SFWhAkAs/Qw6r0tzHKEHUL4KIx+QiwWbGLb4fNhizpyVTBq0x
aWsrw7ksMZI=
=S6fM
-----END PGP SIGNATURE-----

--=-vdJEA4LPcNMYdiDMFA4s--
