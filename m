Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYBTSWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:22:07 -0500
Subject: ath5k 64 bit warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	bruno randolf <bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dbhj4jzxIuRMNI6eTDEo"
Date: Tue, 19 Feb 2008 19:15:42 +0100
Message-Id: <1203444942.12887.1.camel@johannes.berg> (sfid-20080220_182215_689152_EAAD1F7E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dbhj4jzxIuRMNI6eTDEo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

drivers/net/wireless/ath5k/base.c: In function =E2=80=98ath5k_beacon_update=
_timers=E2=80=99:
drivers/net/wireless/ath5k/base.c:2186: warning: format =E2=80=98%llx=E2=80=
=99 expects type =E2=80=98long long unsigned int=E2=80=99, but argument 5 h=
as type =E2=80=98u64=E2=80=99
drivers/net/wireless/ath5k/base.c:2186: warning: format =E2=80=98%llx=E2=80=
=99 expects type =E2=80=98long long unsigned int=E2=80=99, but argument 6 h=
as type =E2=80=98u64=E2=80=99
drivers/net/wireless/ath5k/base.c: In function =E2=80=98ath5k_intr=E2=80=99=
:
drivers/net/wireless/ath5k/base.c:2446: warning: format =E2=80=98%llx=E2=80=
=99 expects type =E2=80=98long long unsigned int=E2=80=99, but argument 7 h=
as type =E2=80=98u64=E2=80=99
drivers/net/wireless/ath5k/debug.c: In function =E2=80=98read_file_tsf=E2=
=80=99:
drivers/net/wireless/ath5k/debug.c:203: warning: format =E2=80=98%016llx=E2=
=80=99 expects type =E2=80=98long long unsigned int=E2=80=99, but argument =
4 has type =E2=80=98u64=E2=80=99
drivers/net/wireless/ath5k/debug.c: In function =E2=80=98read_file_beacon=
=E2=80=99:
drivers/net/wireless/ath5k/debug.c:274: warning: format =E2=80=98%016llx=E2=
=80=99 expects type =E2=80=98long long unsigned int=E2=80=99, but argument =
4 has type =E2=80=98u64=E2=80=99

please fix by appropriate casts to unsigned long long.

johannes

--=-dbhj4jzxIuRMNI6eTDEo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7sczaVg1VMiehFYAQLtgRAAp+ib0lFkDw4jI5GudzDwtPTLrwaUuTjv
ODzv/3RYBhtw229ri+3EELLfcw+QAGl/chNODVQMvPhTMxPcdD6wk6IKiQAZZARU
sdCrK9peKTm/ubz3dhJbjtbH6Q6N6ZF9BCFhwYszI5R2glPADBna00ON0V1UWilH
JBwxMf9dK3AlDMhxJLzL1C30SX18OThJLJHxoItXi2a/cL18EiJZ+QtIZDzjkd2m
l5zSw7Z9ALSwT9dhwPCVuVxa4vS1aZeDlmThYXzpgwYfOCaLGg6jk54v/jU589k4
2UvELS21wQ6C/VdjxrLptFnOQopPRvEJIrywL1s/8nFXB0pDD9o4ZeEZ2k6PhDOu
jranSUfv/EBk+2elpx2jbBUeTJlIOKgQdQqjTwSb6Jazh3qLBumQot+HLWQzt523
KejKBV6am6hPw03mS/JEjVb8i1rQBZFFCFEes26KssE9o3h+1Wcp1l3zuMi/IP6e
Zs+ds6ZFMUsBvRvRcWjwA0CoP1rKt0YUwhdDsWXxKPgublXoacPZMZkM/+krTd3H
4NTgoCscfcJyp6ybeRyZVZjBqkN/kvat+M6UY4yu6KhEqDa2WXWB+Tbsagn9Qekq
ovseT1og4jyjfGlW9hWuTCqv/y6XHKsHVNueou4W4KVlcs1YgsWEru0i331HQjzT
hnLdJlI2BFw=
=W9Iz
-----END PGP SIGNATURE-----

--=-dbhj4jzxIuRMNI6eTDEo--

