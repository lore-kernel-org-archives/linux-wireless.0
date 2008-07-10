Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYGJJKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 05:10:54 -0400
Subject: sparse warnings on iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GHlUVklxLgvrc98/Kkk2"
Date: Thu, 10 Jul 2008 11:10:08 +0200
Message-Id: <1215681008.3932.5.camel@johannes.berg> (sfid-20080710_111057_967741_B0F2E717)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GHlUVklxLgvrc98/Kkk2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Was just running sparse for something unrelated and noticed these:

drivers/net/wireless/iwlwifi/iwl-rx.c:832:2: warning: cast truncates bits f=
rom constant value (1c00 becomes 0)
drivers/net/wireless/iwlwifi/iwl-rx.c:836:2: warning: cast truncates bits f=
rom constant value (6f080000 becomes 0)
drivers/net/wireless/iwlwifi/iwl-rx.c:836:2: warning: cast truncates bits f=
rom constant value (6f080000 becomes 0)
drivers/net/wireless/iwlwifi/iwl-rx.c:856:3: warning: cast truncates bits f=
rom constant value (4001 becomes 1)
drivers/net/wireless/iwlwifi/iwl-rx.c:860:3: warning: cast truncates bits f=
rom constant value (a000 becomes 0)
drivers/net/wireless/iwlwifi/iwl-rx.c:864:3: warning: cast truncates bits f=
rom constant value (c000 becomes 0)

johannes

--=-GHlUVklxLgvrc98/Kkk2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIddHsAAoJEKVg1VMiehFYF28P/173zu1ziK5Amzuxchon+9nI
cY6h5gEh1nfSMq473bG/+6Oap8a4JOgZ9ozG8+jvHaXlnYIExLo+EVVppj+c1Ckx
xVsXK2PNbl8uT78Qg7XjSWtnTHD92OCBuhPcr6TFmM88rf+JoXYZ3HRgqQHhT2By
Zf4TQiLm1gspKjT3paOKSJOxcVEr9rj79hnyRkMDaXB11RNhRrvy0IPU2AK5Lp6z
GZPEJ+uQMPahkhmtvHKwuxnrUWE1/rVc1y09tJBWRRUVApAkJG2xCiMQK9oSa/oS
2RG1zbOC09eI0imsLF+DZokQEfmYsVfiFYItsOxErfkS+h20EkEM3kHroMExRXXp
na9eOrBvPt2bREMXyPZxFLKg8ZD6muByeH5BNRt86wQvY3ysVYh3aGg2Xf15v7NI
Qb7HTrHt/ykgXzRKEV4hmzlDZmo4S/0fa72hnGRDIT7hxlEBu2k2dtM4j727JW65
yleQDqxHX3/sirzKwx/LUsYB4VcpHmmwoinZzUOCWcAQ4eTSbZKvrOYJKBlxBc0a
5CcYYIWP7kGTL6hc252NRBADMis0nJslLflY/jAZOUs/wl6brlv3m8VSziRm2V3j
EzZDD1iZJbcHmxLAB1RMdQ9llCw4RDmQ1b8m6ODX8OXahNNK7zqhOLDdUY0rAIzC
V8rN8RrTnxfWqTAxgn3d
=vOI9
-----END PGP SIGNATURE-----

--=-GHlUVklxLgvrc98/Kkk2--

