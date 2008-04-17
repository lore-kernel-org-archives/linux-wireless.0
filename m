Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37768 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764557AbYDQR4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 13:56:39 -0400
Subject: FYI: hostapd status
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EwO7XJkJg4OcE/F/4DNv"
Date: Thu, 17 Apr 2008 19:56:30 +0200
Message-Id: <1208454990.4066.42.camel@johannes.berg> (sfid-20080417_185653_145558_2F1F3D9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EwO7XJkJg4OcE/F/4DNv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Since we just talked about it on IRC and I made a list, here it is. This
lists what we're missing in mac80211 and nl80211 for proper AP support.

=EF=BB=BF * short slot        =20
 * short preamble
 * basic rate set=20
 * rts/cts
 * channel flag/regulatory domain
 * tx queue params (the plan is to make them qdisc settings after
   Ron's/my qos patch)
 * multi-bss support (no kernel changes, just hostapd keep track of
   BSSes)
 * internal bridge setting (separated STAs in AP, local->bridge_packets)
 * CTS-protect setting for AP
 * check why we see data frames on cooked monitor
 * investigate the skb truesize bug

johannes

--=-EwO7XJkJg4OcE/F/4DNv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAePTaVg1VMiehFYAQKolg//Xidi8Hyvlccos6Vphr3NCmInq5bZs1/B
gmlOxGRjVItYUSv1/wCSE8wtVu3B6hkgPpCMGLIufJ/jAXuj3zSD29zPQExTGctY
8BQBEZA2xjks3/0CJ7wxkFlAOdpXyKxGMCOOYiQG6MlRfY59th1B8ka4IVB0GPJ6
lb+9DdtwnxqUFTyERt5w6n2ST9oYdpaLBg8czU30fucbz8hLlzH1yxG2mI4s2QjD
06PnTG6laeKnuFHJ5ICjla6K+wc13e2jnhUZEIUTsl72qyyKTlSMeekDVcvz3kzn
MN55UAklLO7hjzH3WJ3ALIYdYItqpS7TdgJIIDl2Hec8yyQv/4mbx2BBH1zOIyvK
tv8rR3P4bhlNuyUvYTKw+FBAcTp4cZYYCl4PUXu32aXStyr1gtRUKgs1fSRnSIR1
b8G9lRJAqv5WWUn01R19xWZXT5rxPAj62m9tcjhpxp5i4XSqw5wd76SzdAvdoSfu
YpU4eqOu1lSo0H2Z6+jBirDLr7JnGZpc6gx7ZULOOO88bQ872TvUGB7xOdXPqIgG
fhrutto/nGnbYHjk34nT2pde/sGcnPNtDukh7KLJBuTuM4S/qSNKTvCMF1g3A6Wh
IlChwdqd9CFTM3/U5G9+4/iPSIcyuWzulRddiP72tr3aQoPtx9+UurkYcD91VYz4
A5ed6NkqaU0=
=dpck
-----END PGP SIGNATURE-----

--=-EwO7XJkJg4OcE/F/4DNv--

