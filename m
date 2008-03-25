Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59008 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbYCYP3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 11:29:22 -0400
Subject: is adm8211 capable of sending arbitrary frames?
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7E3o9jDI+9QyWkeEASB8"
Date: Tue, 25 Mar 2008 13:56:40 +0100
Message-Id: <1206449800.16475.255.camel@johannes.berg> (sfid-20080325_152925_481934_626002A2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7E3o9jDI+9QyWkeEASB8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Michael,

Quick question: it appears that the adm8211 driver pulls out the 802.11
header and instead inserts a custom TX header that only contains one/two
addresses (3/4-addr header format).

This appears to mean that it can send neither QoS frames properly nor
can actually communicate with an AP other than the one it is associated
to. The latter isn't much of a problem, but it seems that the driver
will fall over with QoS AP since it doesn't strip the QoS-data bit from
the frame control. Or does the hardware do that? In any case, mac80211
shouldn't be announcing QoS support for this driver, should it?

johannes

--=-7E3o9jDI+9QyWkeEASB8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+j2h6Vg1VMiehFYAQI8dg/8DfnETkrkx0Tp3jyv17CgHWuF/RHcC/Ml
CnxT7RmEF8Hfb26Ob2SgNflaoLA/qIwLu/RCJGq4mRg6gI/44dm8g+4GCCAvGmC6
Sw4A+Qk3fvdB81XFhggNCfj3RDWwAU/ofDy8mHJp6mOPgv3wdN9weY1cVHj2LWx5
3D0l+FnLLpT3aRlmhKscCh3vE7GPTdM18l+NYNJW0/tmD2UiouT7/MdjnfPcd5bp
wgCKLAJA4mnkwwR31XMd9TUDI3K+p1dCkKXowtpwINIImmIJDgjjhH8Botr5ulSe
EenYPsUkifJWzJ88JKvjK5RMZWDap+v3r7uYKjgK24e/f7LSwIjRtHSBJbIvCOqO
VSu7Aa/abiKgeiDQGS2FLexGa/BHmpGO96jJjA9MNSn/mwhPBpAcbKe4/cUMSrUY
7lPP2M5dePaL1glpR8HGJOUajyl+2I4yo0GA/vaL4kOwVFrk0V/8mVDpGxX3TqEK
tsBKVO++pChda6mr0UjsLDiPNpytK/lDcxbC8MF6bNSiU/vtuSOy6Prx/zDmRsHZ
yS/wvqJ6jxoJWQ7WEelsVbPOazSIPTm3SYgtJtMWyQIx+o0k3D9k74r78ZxKE3Hu
1fj7S7V/4R8Xts9I0tPvdEPiI3BG4CSluEqRXMfKvDHUvQi5GiWEpbn2TSdaTUfD
UQkFZw4soMU=
=V4c1
-----END PGP SIGNATURE-----

--=-7E3o9jDI+9QyWkeEASB8--

