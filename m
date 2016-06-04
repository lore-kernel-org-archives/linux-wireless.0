Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49143 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbcFDLza (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 07:55:30 -0400
Date: Sat, 4 Jun 2016 13:55:13 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Hugh =?UTF-8?B?U2lwacOocmU=?= <hgsipiere@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: ssb: Change bare unsigned to unsigned int to
 suit coding style
Message-ID: <20160604135513.7e905c3c@wiggum> (sfid-20160604_135553_205229_79BC305A)
In-Reply-To: <1465041005-5511-1-git-send-email-hgsipiere@gmail.com>
References: <1465041005-5511-1-git-send-email-hgsipiere@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/GLkzHrpXbrgrOubiXYMwQZD"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/GLkzHrpXbrgrOubiXYMwQZD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat,  4 Jun 2016 12:50:05 +0100
Hugh Sipi=C3=A8re <hgsipiere@gmail.com> wrote:

> These lines just have unsigned gpio rather than unsigned int gpio.
> I changed it to suit the coding style.
>=20
> Signed-off-by: Hugh Sipi=C3=A8re <hgsipiere@gmail.com>

Acked-by: Michael Buesch <m@bues.ch>

Please send this to the MIPS tree, because this basically is MIPS-only
code:

MIPS
M:      Ralf Baechle <ralf@linux-mips.org>
L:      linux-mips@linux-mips.org


--=20
Michael

--Sig_/GLkzHrpXbrgrOubiXYMwQZD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXUsGhAAoJEPUyvh2QjYsORLIQAMEAbIWEON42ZtZYytY9JLBP
+ZgEoSy7Dl/9WZyBAhwXmsBpaY4Ba8y6gL/JZY3tKNFURSnXAJtSWUrqC/x9X/qR
se7mN9D4xTyq+fu0/iSfofr+z3cJ0iWnS3AvOhqyZpTM6Ioi5wc2otH3D3SeSs9v
3frbJBKTrKWTwjWx34NRhluNR13PBN/qd1Jbkc74gwi2nGQDXmbzDMrPGsLCx4jb
JyNc2IZRKAdefF89U/AE1/Z7zaDOv6tNp2hqC/OFtBx9FI5F5MC/VjIGfdAaasCN
GKBwmthc46BULVDh+jyywsGCjBwJSWuxV6LCTxkwJCOp/XMKkjPEnZ6laX2vPkY6
ocVwuxVAc/nPoPihPbCgcynp5BB7EYctqMmFlDGppKTISSeBdIKLMVU++Ja0TcRg
z7EEiWmC+F7jS9Y1HczBOqilon+j0W1x2D7V2XPqyL0eXDx6cUAntOnSnSA7x5wa
/T8F77fz89SsNgqeJTjy1FJUv9baizx+ieyU+pn2Fgk7zaBelgofIibkeLbI7kus
FjBJOEXlPV71B3pZ/U6t3j20Tk6y8T7dBiUjGn4wZego0abKVFptel65Ccu9arMI
HnUw+uOWofTLTamJsevoT78mvRIx2zqvETAzj+JzwEoXBtw6+Io5HDc9tIOG2sl0
WwNOUGpQsb8sUbDGe5uN
=B2EL
-----END PGP SIGNATURE-----

--Sig_/GLkzHrpXbrgrOubiXYMwQZD--
