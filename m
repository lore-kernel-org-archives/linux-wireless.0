Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:46183 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755430Ab2CTSql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 14:46:41 -0400
Received: from mail95.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo2.mail-out.ovh.net (Postfix) with SMTP id 6715ADC2AB7
	for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2012 18:52:15 +0100 (CET)
Subject: Is there a patch for a bug?
From: Jean-Philippe MENGUAL <mengualjeanphi@free.fr>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eUKQw4CNe3WGpBr7gjKd"
Date: Tue, 20 Mar 2012 18:52:08 +0100
Message-Id: <1332265928.7247.1.camel@HP> (sfid-20120320_194645_269346_1D54BDEA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eUKQw4CNe3WGpBr7gjKd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

        I use the 2.6.32 kernel on a Debian system. I use the module
        mac80211 for my Wifi card. But in more and more numerous cases,
        I cannot get an IP with dhclient. It fails. While it searches
        for one, I get:
        wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 366/186
       =20
        Is it a bug in the module? I found some info but not about some
        patch or fix. Is there a fix in the recent kernel? What release
        should I use? If no patch, is there some workaround?
       =20
        Thanks,
       =20
        Sincerely,
       =20
Jean-Philippe MENGUAL


--=-eUKQw4CNe3WGpBr7gjKd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAABAgAGBQJPaMPEAAoJEJ3UrG5CoODaajwQAJ24yAEhpsENSt1yCrZeJjfk
oE26WYJnMEGVDO3Ucho5NPFvxAVbzW4+YiyEv1ZogjuKl26iK9SYULEGouY+bBMT
GuHOkiiKnaI0jD169b4guRuRfhyca8U73FXB9mRwpDFQ75mRn70vltaPmS1ecBbU
FQSkIdApNeAreKLnUC7HtsLv+C5AgALetmG8eMR1yeqX37qtgmoF/k5SuT2dPuzZ
5yYg6D6lcbK7RJjKRkS9eaHVUUaWH8xdJjTs+iqex706S3LeVOtW8HV518LSk3YE
Z/hQnwbTu7+QjY2sxmUCR2kEBboeBrp2WyFSs25o9PefQw0iSsGBdKl1oPaTOKMO
UUrAsxf2WZNdKzeoycGFh6ArHNzDYzeZ9bCBIBzEFnJq1LWWSaNrR1esbB0hPEF1
DGvI8p11Tp+pQ6X2bWygjV7Vzn8pU60uQDmjnu+DkPMF5etnQn/ZcYuEegW6S5KV
oisVhNHi6O3kijY+IOr6VvrMrkMt0sHSgCbJ7SyNtxy/ebNXHQQEMmGGzmpqmUV8
+W5hAyfyrw4xefxRzKlR+AQl/0ng/uuFV/WdAR5WQGmJAS8nEJzDb9+1PKDdMC1C
2M+khGIhYVtZkQ4lwFVPNCXjGvyBGFhNO467BF2Zqa9JXlGUhZ1YKJeDEgcRUTPl
VWMBfmmA8tM5thglVQl5
=jANq
-----END PGP SIGNATURE-----

--=-eUKQw4CNe3WGpBr7gjKd--

