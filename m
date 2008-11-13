Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49082 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbYKMUIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 15:08:40 -0500
Subject: Re: [FYI] ar9170 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: "otus-devel@lists.madwifi-project.org"
	<otus-devel@lists.madwifi-project.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1226606262.5839.37.camel@johannes.berg> (sfid-20081113_205838_337869_BDE81783)
References: <1226531034.14186.39.camel@johannes.berg>
	 (sfid-20081113_000444_962024_07ACD3CC)  <1226606262.5839.37.camel@johannes.berg>
	 (sfid-20081113_205838_337869_BDE81783)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tI92in7vdPNDq7Gb9f9O"
Date: Thu, 13 Nov 2008 21:08:00 +0100
Message-Id: <1226606881.4159.0.camel@johannes.berg> (sfid-20081113_210844_453646_6DF646F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tI92in7vdPNDq7Gb9f9O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-13 at 20:57 +0100, Johannes Berg wrote:
> On Thu, 2008-11-13 at 00:03 +0100, Johannes Berg wrote:
> > This patch adds the ar9170 driver for Atheros 802.11n
> > USB hardware ("otus").

And the required firmware has made it to the firmware tree:

http://git.kernel.org/?p=3Dlinux/kernel/git/dwmw2/linux-firmware.git;a=3Dco=
mmit;h=3Db66ece11531cc7043bd25dd963c8a58d8d5da2f5

just put it in /lib/firmware/

johannes

--=-tI92in7vdPNDq7Gb9f9O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJHIkeAAoJEKVg1VMiehFYOVEP/28ywiUVg6TAIOE4HO+y9bLp
iVKBXFr35kR9SYLuR8iKs6g7kESrD1FK6g+md+K+/lL7F49+R0c8eGzuCPVeEJTR
cbFxP+44nrjO3WZ0ILKQ0bBKPJyeAGqxcjAKAkmri3SbJS9TlOuy5CO9qUco0YDr
5HrQGD+3gpk/1KlBc9sr95OVGXkTeJlr/fyUAc7bC1dL8NS6GFLHpebEiE/p5ls8
HybFOGBlY9aqRfnZhXi7EWeOxHdk58lDQDX18O2QkmbUVaKm0bleVRhVpjhZ0aTa
1Lko8LCdU8zR1Ilyz63S17UOvYQHyxLAQINV5XkwVCCv7K08KpggEem0l8k+dsa9
1A00sN+caSf4ZyzCocguYM1r1xaJ6CGQE6dRPDpf8wIAkl1vUQ39RrsF2lPVHAyY
mBx1FaNfRnmzr/op/+I61gG9x2IEeVWx9RAOK2sJNsC1Jdbepk7qltyhUvts6WMf
F+Fqxz/Ur4Zxcs1cy01HppxAjih73Gd+cyH43hIP75K3DE3lAHPN1pvgcXzu/BtE
0QMtVuIv810HKlRHR2u5B662WY4k2slaLKVp3FtkKqXLCP13FP8KcQPMUW4ZKvOl
VTVmz87zogrfuismgnCTITzyPihydmgO9fpzmuY9MMQEJ6eVud/e4yt/A3eHiVOB
Yk4jJo7H+QkWgKqj6hSg
=NRCB
-----END PGP SIGNATURE-----

--=-tI92in7vdPNDq7Gb9f9O--

