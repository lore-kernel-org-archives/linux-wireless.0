Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from haggis.pcug.org.au ([203.10.76.10]:34247 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3DDJA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 05:00:56 -0400
Date: Thu, 4 Apr 2013 20:00:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8188ee: Fix linker warnings
Message-Id: <20130404200043.0aba7568bd61cdcef3fd6a98@canb.auug.org.au> (sfid-20130404_110101_654382_55B955AE)
In-Reply-To: <515cd906.MrKlPKWUlskAMZEB%Larry.Finger@lwfinger.net>
References: <515cd906.MrKlPKWUlskAMZEB%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_20_00_43_+1100_ZXOmN9/PRTg2NKgV"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Signature=_Thu__4_Apr_2013_20_00_43_+1100_ZXOmN9/PRTg2NKgV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 03 Apr 2013 20:36:06 -0500 Larry Finger <Larry.Finger@lwfinger.net>=
 wrote:
>
> Building rtl8188ee yields warnings such as the following:
>=20
> x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input fil=
e unused because linking not done
>=20
> The only potential cause is an extraneous space in the make file.
>=20
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Apr_2013_20_00_43_+1100_ZXOmN9/PRTg2NKgV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXUE7AAoJEECxmPOUX5FEqSkP/iEFI0784SpciEUxYoMbP1YG
T1WlvBSD3TCnK4IqgjOUTkYQ1et0FxPdVhY5/WJdPvtrKfFHhKLmtv/oP0rHZUBx
MkST4ovqoFnqwbJUuAZKGKV3y7US0usgdn84Xsm4V63h9eSo/pIw76lvxasd5mQ4
N/ri3u4llHp2w156+vi/0FpEZVZqzGCOP30LMWTJAUy/RNugkhXaQHWWxtutASQK
7iUYJ7ADXkRn1B+LU6JgXqazhDe61Zyh7AnRQjuxTkbhCiTfgtN+9W4pCHoxrT92
hl4c3j2ksRxjkZchzp/sqotCNDEmzyQsH8L5Lm7wecVOhZT1UPEsteYlzws00NA5
Ihi5S2TuxEoN4ipTlyGhuch2T11PvgmtZsCvMqbRPFmBuAc7drAn2+0HFIzphJN7
BY2Uj9G80Ye9XqZlCFNQwAVl9qwYiCjCvMPM5zmPVBc5+wnncUoW17+mClHf0UBF
OGz9KrGxgEs9xwTf/4GpVMNKfJ41ur3d5an8I2AZRp+uacuzX54MKz2brFClVqXp
F8/FM38UQI0awVMUg61X8E9T2b3GVNGv9nUrNSSxDCe4Ng7PgFq/mPpS0xHKWP2j
xhrg8UOs55iPeZyqrVpugmXNMXDQ2p4wvzB0NltCTFgStIIdLYVhao8kADH6c85p
Sc4W0lhgoHjoyIekF45X
=FBmy
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_20_00_43_+1100_ZXOmN9/PRTg2NKgV--
