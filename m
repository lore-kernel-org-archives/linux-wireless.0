Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751245AbYDUN5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 09:57:36 -0400
Subject: Re: [ipw3945-devel] iwl3945: Disabled channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Morrison <bdm@fenrir.org.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <480C5AFF.5020005@fenrir.org.uk> (sfid-20080421_101455_395583_495A4EE6)
References: <fuhkfp$mnk$1@ger.gmane.org>  <480C5AFF.5020005@fenrir.org.uk>
	 (sfid-20080421_101455_395583_495A4EE6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZW1fWRdsSe/K6CQdYWfL"
Date: Mon, 21 Apr 2008 15:50:18 +0200
Message-Id: <1208785818.26186.101.camel@johannes.berg> (sfid-20080421_155828_409021_DB763FE4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZW1fWRdsSe/K6CQdYWfL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> If you're in the EU, I contributed a fix that has not yet made it into=20
> the iwlwifi code as it is under review (the whole regulatory aspect is=20
> difficult, there are so many caveats!).

Technically, it's cfg80211 code; the reason that it's not in yet is that
I'm unsure about the legal situation of the ETSI and the national
bodies, it seems to me that the ultimate decision is done by the
national bodies and last I heard France had quite different restrictions
than Germany, for example.

Does anyone have that info? I can dig up the info for Germany easily
(the "Frequenznutzungsplan" is available on the regulatory agency web
site as pdf)

johannes

--=-ZW1fWRdsSe/K6CQdYWfL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAybmKVg1VMiehFYAQJ25A/9Ex0q9sB+Yai9iZEpISrmlFNRBDcfOCbU
HpztAHUhJBXt5MpfoVNqmz0fbdwr++SqGLGAbSOddRbgICrfAy24M8oGsk25MaFc
VK5cTUAV9aTdhsn8YrBqFs8YhKvjo0H3muJDFjg3+L406N0sERrJ6qM1wBWaPWUi
FIuVD1GiPw5DlrPSTN7zOmyR1oGOf9GXuRlJ6d4FxfFEeJp6qDZOeQyZVblXPQaZ
bw2WLp1WyVivhYnxYJPQFtagWY2ksc/8P6BY85mKRHfyWBhJICuqc4DJK3udXMdz
AoI6G0z7OmivrNJUkFIF4D3KBJheCdTK4RduVGSKDcUCI0b6ee3G2VjAk04ybKNs
RvFVpqD5DjsAR/2qOEe8+wbdGEJBtbI6ueC0yjwLGT4/xMPiOPeB2nvRS5G61beY
N/h46QQw+2CLrbl2juMlZT5w6KPDeYTgontaLBNKw4+760KyUnPXxgWTSh6a6eXc
GNx6FMqaziDxdfFUH55thbxUG8P8x1Lcgq2/Lg2LiGg+9sUaERaztU2CdpVy6HQo
VIX5Yv8pqXJUIjHKlfTDjFSoWBy0xZ2fZOYskkemeJjumLGbIqqQX3xcpNEn86Rg
JGiV55Y2vhcbmxAlO2XZr/O4ex2aMqoY6PKvUF3Q30iSnEqzm4DTqAavkeJirng/
5RlrXI1XjU4=
=Jj/T
-----END PGP SIGNATURE-----

--=-ZW1fWRdsSe/K6CQdYWfL--

