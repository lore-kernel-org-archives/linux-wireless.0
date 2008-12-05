Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:64261 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbYLEX04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 18:26:56 -0500
Received: by ug-out-1314.google.com with SMTP id 39so143544ugf.37
        for <linux-wireless@vger.kernel.org>; Fri, 05 Dec 2008 15:26:54 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Date: Sat, 6 Dec 2008 00:26:44 +0100
References: <200811252131.30161.hrogge@googlemail.com> <200812051051.52908.rogge@fgan.de> <1228470840.3970.15.camel@johannes.berg>
In-Reply-To: <1228470840.3970.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10327622.Hoc5TZN0vo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812060026.50636.hrogge@googlemail.com> (sfid-20081206_002659_429846_D1715CE3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart10327622.Hoc5TZN0vo
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I just did a few calculations about the tx/rx rates in 802.11n and I think =
I=20
can replace all of them with simple integer arithmetics. Only the 20Mhz rat=
es=20
with short guard interval are a little bit off (I think I miss two of them =
by=20
0.1 MBit/s and one of them by 0.2 MBit/s)...

do you think that's accurate enough ?

Henning

--nextPart10327622.Hoc5TZN0vo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk5uLoACgkQcenvcwAcHWd3WQCfQPcTkj0+NFcpvoRXH3nixrKJ
FKgAnR3FUs9Oy0K5xMWwX4mD6OQud1cY
=Hhcg
-----END PGP SIGNATURE-----

--nextPart10327622.Hoc5TZN0vo--
