Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965384AbXIGNXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 09:23:14 -0400
Subject: iwlwifi sparse warnings with __CHECK_ENDIAN__
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Tomas Winkler <tomasw@gmail.com>, Zhu Yi <yi.zhu@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tFWdbYotRvuu3VakZ4XM"
Date: Thu, 06 Sep 2007 19:33:47 +0200
Message-Id: <1189100027.28781.104.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tFWdbYotRvuu3VakZ4XM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

drivers/net/wireless/iwl-3945.c:949:3: warning: incorrect type in argument =
3 (different base types)
drivers/net/wireless/iwl-3945.c:949:3:    expected int=20
drivers/net/wireless/iwl-3945.c:949:3:    got restricted unsigned short [us=
ertype] board_revision
drivers/net/wireless/iwl-3945.c:954:3: warning: incorrect type in argument =
3 (different base types)
drivers/net/wireless/iwl-3945.c:954:3:    expected int=20
drivers/net/wireless/iwl-3945.c:954:3:    got restricted unsigned short [us=
ertype] board_revision
drivers/net/wireless/iwl-3945.c:1650:15: warning: cast from restricted type
drivers/net/wireless/iwl-base.c:1703:17: warning: cast to restricted type
drivers/net/wireless/iwl-base.c:2168:4: warning: incorrect type in initiali=
zer (different base types)
drivers/net/wireless/iwl-base.c:2168:4:    expected restricted unsigned sho=
rt [usertype] flags
drivers/net/wireless/iwl-base.c:2168:4:    got restricted unsigned int [use=
rtype] [force] <noident>
drivers/net/wireless/iwl-base.c:2169:4: warning: incorrect type in initiali=
zer (different base types)
drivers/net/wireless/iwl-base.c:2169:4:    expected restricted unsigned sho=
rt [usertype] flags
drivers/net/wireless/iwl-base.c:2169:4:    got restricted unsigned int [use=
rtype] [force] <noident>
drivers/net/wireless/iwl-base.c:2170:4: warning: incorrect type in initiali=
zer (different base types)
drivers/net/wireless/iwl-base.c:2170:4:    expected restricted unsigned sho=
rt [usertype] flags
drivers/net/wireless/iwl-base.c:2170:4:    got restricted unsigned int [use=
rtype] [force] <noident>
drivers/net/wireless/iwl-base.c:2171:4: warning: incorrect type in initiali=
zer (different base types)
drivers/net/wireless/iwl-base.c:2171:4:    expected restricted unsigned sho=
rt [usertype] flags
drivers/net/wireless/iwl-base.c:2171:4:    got restricted unsigned int [use=
rtype] [force] <noident>
drivers/net/wireless/iwl-base.c:2172:4: warning: incorrect type in initiali=
zer (different base types)
drivers/net/wireless/iwl-base.c:2172:4:    expected restricted unsigned sho=
rt [usertype] flags
drivers/net/wireless/iwl-base.c:2172:4:    got restricted unsigned int [use=
rtype] [force] <noident>
drivers/net/wireless/iwl-base.c:2178:4: warning: incorrect type in initiali=
zer (different base types)
drivers/net/wireless/iwl-base.c:2178:4:    expected restricted unsigned sho=
rt [usertype] flags
drivers/net/wireless/iwl-base.c:2178:4:    got restricted unsigned int [use=
rtype] [force] <noident>
drivers/net/wireless/iwl-base.c:2180:4: warning: incorrect type in initiali=
zer (different base types)
drivers/net/wireless/iwl-base.c:2180:4:    expected restricted unsigned sho=
rt [usertype] flags
drivers/net/wireless/iwl-base.c:2180:4:    got restricted unsigned int [use=
rtype] [force] <noident>
drivers/net/wireless/iwl-base.c:2182:4: warning: incorrect type in initiali=
zer (different base types)
drivers/net/wireless/iwl-base.c:2182:4:    expected restricted unsigned sho=
rt [usertype] flags
drivers/net/wireless/iwl-base.c:2182:4:    got restricted unsigned int [use=
rtype] [force] <noident>
drivers/net/wireless/iwl-base.c:2184:4: warning: incorrect type in initiali=
zer (different base types)
drivers/net/wireless/iwl-base.c:2184:4:    expected restricted unsigned sho=
rt [usertype] flags
drivers/net/wireless/iwl-base.c:2184:4:    got restricted unsigned int [use=
rtype] [force] <noident>
drivers/net/wireless/iwl-base.c:2185:4: warning: incorrect type in initiali=
zer (different base types)
drivers/net/wireless/iwl-base.c:2185:4:    expected restricted unsigned sho=
rt [usertype] flags
drivers/net/wireless/iwl-base.c:2185:4:    got restricted unsigned int [use=
rtype] [force] <noident>
drivers/net/wireless/iwl-base.c:2220:16: warning: incorrect type in assignm=
ent (different base types)
drivers/net/wireless/iwl-base.c:2220:16:    expected restricted unsigned sh=
ort [usertype] flags
drivers/net/wireless/iwl-base.c:2220:16:    got restricted unsigned int [us=
ertype] [force] <noident>
drivers/net/wireless/iwl-base.c:2222:16: warning: incorrect type in assignm=
ent (different base types)
drivers/net/wireless/iwl-base.c:2222:16:    expected restricted unsigned sh=
ort [usertype] flags
drivers/net/wireless/iwl-base.c:2222:16:    got restricted unsigned int [us=
ertype] [force] <noident>
drivers/net/wireless/iwl-base.c:2267:14: warning: incorrect type in assignm=
ent (different base types)
drivers/net/wireless/iwl-base.c:2267:14:    expected restricted unsigned sh=
ort [usertype] flags
drivers/net/wireless/iwl-base.c:2267:14:    got restricted unsigned int [us=
ertype] [force] <noident>
drivers/net/wireless/iwl-base.c:2271:14: warning: incorrect type in assignm=
ent (different base types)
drivers/net/wireless/iwl-base.c:2271:14:    expected restricted unsigned sh=
ort [usertype] flags
drivers/net/wireless/iwl-base.c:2271:14:    got restricted unsigned int [us=
ertype] [force] <noident>
drivers/net/wireless/iwl-base.c:2279:2: warning: incorrect type in argument=
 3 (different base types)
drivers/net/wireless/iwl-base.c:2279:2:    expected int=20
drivers/net/wireless/iwl-base.c:2279:2:    got restricted unsigned short [u=
sertype] flags
drivers/net/wireless/iwl-4965.c:490:18: warning: restricted degrades to int=
eger


--=-tFWdbYotRvuu3VakZ4XM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4Dn7/ETPhpq3jKURAv9fAJ0ff46PKS66CsF3UgkAq0dQ9uOMrgCfTxeb
r/Ey9f7m7gdrcklN/kQAT7w=
=qmSo
-----END PGP SIGNATURE-----

--=-tFWdbYotRvuu3VakZ4XM--

