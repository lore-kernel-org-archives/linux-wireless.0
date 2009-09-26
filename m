Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60538 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbZIZKGt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 06:06:49 -0400
Message-ID: <4ABDE7AC.1090409@hauke-m.de>
Date: Sat, 26 Sep 2009 12:06:36 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Malte Gell <malte.gell@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: cannot compile compate-wirless snapshots
References: <200909260457.21103.malte.gell@gmx.de>
In-Reply-To: <200909260457.21103.malte.gell@gmx.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0A8F8C241722E40EFB85B109"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0A8F8C241722E40EFB85B109
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Malte Gell wrote:
> Hello,
>=20
> actually I can build the stable compat-wirless-2.6.30.ta.bz2 just fine.=

>=20
> But I get make errors, when I try to build the daily snapshot, see belo=
w. I=20
> use openSUSE on a 2.6.27 kernel.
>=20
> Thanx, Malte
>=20
>=20
> 2[malte_gell@linux-61r3]12535 04:50~/download/src/wifi/compat-
> wireless-2009-09-25> make
> make -C /lib/modules/2.6.27.29-0.1-k7/build=20
> M=3D/home/malte_gell/download/src/wifi/compat-wireless-2009-09-25 modul=
es
> make[1]: Entering directory `/usr/src/linux-2.6.27.29-0.1'
>   CC [M]  /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-25/drivers/net/wireless/ath/main.o
> In file included from /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-25/include/net/compat.h:19,
>                  from <command-line>:0:
> /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-25/include/net/compat-2.6.28.h:152: error: redefinitio=
n of=20
> 'struct tracepoint'
> In file included from /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-25/include/net/compat.h:19,
>                  from <command-line>:0:
> /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-25/include/net/compat-2.6.28.h:182:1: warning: "DEFINE=
_TRACE"=20
> redefined
> In file included from include/linux/module.h:19,
>                  from include/linux/textsearch.h:7,
>                  from include/linux/skbuff.h:26,
>                  from /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-25/include/net/compat-2.6.28.h:10,
>                  from /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-25/include/net/compat.h:19,
>                  from <command-line>:0:
> include/linux/tracepoint.h:86:1: warning: this is the location of the p=
revious=20
> definition
> /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-25/include/net/compat-2.6.28.h:186: error: redefinitio=
n of=20
> 'tracepoint_update_probe_range'
> include/linux/tracepoint.h:100: error: previous definition of=20
> 'tracepoint_update_probe_range' was here
Hi,

what kernel are you using? It looks to me you are using 2.6.27, but the
2.6.27 mainline kernel does *not* contain the tracepoint infrastructure
and include/linux/tracepoint.h, like your kernel. Did you made some big
 modifications to your kernel or is it the default openSUSE kernel?

Does this file exists in your installation?
/lib/modules/`uname -r`/build/include/linux/tracepoint.h ?

Compat-wireless checks the kernel version and adds some compat code
based on the things the mainline kernel misses in this version, but this
is not working correctly with kernel, because it looks like it contains
some "bad" modifications.

Hauke


--------------enig0A8F8C241722E40EFB85B109
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJKveewAAoJEIZ0px9YPRMy+eAP/iudBKatB/7p9wcAa1fZDIie
P6D4UBHCXvFtf1mal2Oek6p05bDWXphmsajj53Wq0zfzU6OicP4v7ztOIzDzoxz7
aL2e+KJpvDO8feSXIm4g10SzVbFP0P3unvSpoLytYuuMVEY5wHX7d9xwJix21fXI
Nbv96EVbgXYeYnq8fzDAUA2Jfh9sC/zuGeF+246LVe3cQVpokuDcYyi+1trXgHeJ
ldM+7G0nlgvBhz4u7/JwHOexr940vSayi2cnYPe3wuRETfg8kiUNxPIIoKtpDg+/
Rdr9DNWqQocu2MRDDez84G6II6WrAVemNMBO/QwRYg3YSK2FkdTkz4LO6BL9SIWl
hqChu+N5HKRBIEqR4DcE22prhftf+daldiOPTq2UhRAXQooLtSjsW3R/LN2xFHTA
C6AI+oVCHmKon4IEmMyKvYk3YdLSFUTxUQBj4pGDK1cLux2pL9Z4PayPiRc2vDAq
O1gbWSl/tycPXNpc4PyPiXy5rmkb/JLZewsyXh336KNP5PC5j6sLIoMh+EMPoEsX
xhovV4FB0qSdRdZ2Z78NeZPY9Jr7tAJDQeoLbEhzfcxg2g0Yh4H5xduyb7zNBRlc
fUDCrm5neH4dyA1JtRWmepAXdKfxDkXXTF3QQsmOSbuOkryY9oKj4wUsvmpG/Qvq
9t70+IxSGq+v8fOaGtBl
=O/W7
-----END PGP SIGNATURE-----

--------------enig0A8F8C241722E40EFB85B109--
