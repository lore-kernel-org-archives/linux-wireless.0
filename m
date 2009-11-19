Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55639 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZKSO2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 09:28:14 -0500
Subject: mesh endian bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: Rui Paulo <rpaulo@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MYW5yyqXeQQgCrFbCIT+"
Date: Thu, 19 Nov 2009 14:51:31 +0100
Message-ID: <1258638691.7094.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MYW5yyqXeQQgCrFbCIT+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

  CHECK   /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:471:41: war=
ning: incorrect type in argument 4 (different base types)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:471:41:    =
expected restricted __le16 [usertype] target_rcode
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:471:41:    =
got int
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:617:36: war=
ning: incorrect type in argument 4 (different base types)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:617:36:    =
expected restricted __le16 [usertype] target_rcode
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:617:36:    =
got int


--=-MYW5yyqXeQQgCrFbCIT+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBU1gAAoJEODzc/N7+Qma8AMQALyQSennvinPGGBJW2GoK/uc
IXh/9Rdb6ceXRRTuyg+7wosJFJ/5JouI3cqCcGfK1bwt8yqN/7Yjcs5TZRuwhk7s
rDW+GZuaAoOFQ3hAifrPZTRmI3pxyOpu9dXs3q53pkpB1bgq1HNW+eq2mWBWKN5V
v76WWXqNvRwAC54l8Bo8ImpmAkg/ymI9mBijD7vl1Tv5hcjZOnwDfGbDalsB3mRh
YYxh1jqJZFMYjBb/fBnbvnZPJA67mSGfzxb7EWovmagn1+lMs82iNMF0435dsSlY
PVE8ozfrAWBiaFnHDQtc3L2oCaJJhJJUKykVDalXGzPM1wmoq6+ezHx1oKD0Tqvw
fk98wvksJxNjRfQ0BVfdI35WHpb4f4gfb7hCSZlU9OtyDv7mwPMPErNlPN2hR3UG
eWyvPF4vKBy+wuTUek9ntQxwNRcSjJQZF+u6pcNMaiNebBNtxmXGAZEmhh8zj/6R
AwQtTbX1I8UUzxBRFod0a1Lkk0tsaJ31T8rxUKCdYSWSDba694hY5ifSGeAK4PIT
2SFJYB1BU+BJWq5fQfpwxf7JkwyTqoH8omSrsl/kzr78RkSiCmcaGzXggkD6MkUC
w4dNnHIej8tp6JfmnY6fC7G+t4kodzaEeJ8a0baU7IRFi5/IG/NKlOyvMgNLDbew
AJn8Lvf/4ot55BUwjSfW
=5N+M
-----END PGP SIGNATURE-----

--=-MYW5yyqXeQQgCrFbCIT+--

