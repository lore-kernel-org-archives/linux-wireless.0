Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41520 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYFUSL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2008 14:11:27 -0400
Subject: Re: [mac80211] Implement EU regulatory domain
From: Johannes Berg <johannes@sipsolutions.net>
To: Tony Vroon <tony@linx.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1212606324.14371.43.camel@johannes.berg> (sfid-20080604_210658_453842_6356D7D8)
References: <1212605479.4235.1.camel@localhost>
	 <1212606324.14371.43.camel@johannes.berg>
	 (sfid-20080604_210658_453842_6356D7D8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-K/aIuFSwK6VzAqMiXw33"
Date: Sat, 21 Jun 2008 20:10:35 +0200
Message-Id: <1214071835.8967.247.camel@johannes.berg> (sfid-20080621_201131_908324_6106B319)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K/aIuFSwK6VzAqMiXw33
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-06-04 at 21:05 +0200, Johannes Berg wrote:
> > =EF=BB=BFImplement missing EU regulatory domain for mac80211. Based on =
the=20
> > information in IEEE 802.11-2007 (specifically pages 1142, 1143 &
> > 1148)=20
> > and ETSI 301 893 (V1.4.1).
> > With thanks to Johannes Berg.
>=20
> Technically not mac80211 but cfg80211 ;)
>=20
> > Signed-off-by: Tony Vroon <tony@linx.net>
>=20
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

John, can we have that commit in 2.6.26? It fixes a problem that users
in the EU are not able to properly use the spectrum they are allowed to.

johannes

--=-K/aIuFSwK6VzAqMiXw33
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIXUQXAAoJEKVg1VMiehFY5AwP+wfFeWdJOCtXh99z6HSaNhuo
aDSZa4XXzANko/isiwth2p6rkn5NWSJOQSPPvGmDnjUIZU1OFvRHafwWuAheJ7CB
UFnK1Bw7HJI5kuIiGkNkAv/u0TmjHLT3czhp4hxIGMFqMvhDFAZtmXe8plc8aJZz
iB5m6xpRIe44g0SHtKaYCEKNM5WtUptljXiAfMOeSZfVZjWBLBxkP/KXWYiJW0FE
OTJPuq08nqK5jKHo6A2fJ5XDQra4k10JuTAh83d5J75cJYkFZa86JXVvIqAq2AJA
4UIbqCMWXmXE0CUJmPcvzfOS+Q5KvfBs9YxCNm5HApZAkG+EsKSlzHEyVdPF3sRT
Ox46lXI9qAOM2/q2M5zhycrxWxx0AcWpja4ScD3ho+Q4obHCWGi3S4+bTdj78xy5
UMRLhs60NUZiwbRPKtQsQvI9//DFzYMh5urMgj5wddbo1LeJYHl8pWAnls2LgnXl
k+VdskUlUdOi5yeDjYE5+MT7+hEZpnuBEqsaTKp/KGyLTT6W6ti04OgD9TgMJTt5
+UoM+1LUakX6EN1T6KPv0LT3o/A8QVNZmr5RKzctA6tkIhT7O3TCpcTU0N+c1Hqt
pudPKEMMiOQuERIYp/Th6tDd+ON8eHrwwrFMkqVrFCVDUzbouFOSztX4eeQAesLM
LnFiwRsfKqMXqI+cUPla
=y7Qn
-----END PGP SIGNATURE-----

--=-K/aIuFSwK6VzAqMiXw33--

