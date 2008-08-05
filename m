Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32943 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574AbYHEUNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 16:13:38 -0400
Subject: Re: kernel panic on p54pci insertion on mipsel
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-wireless@vger.kernel.org,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>
In-Reply-To: <4898B018.5050202@wpkg.org> (sfid-20080805_220519_408842_EB7A6EEA)
References: <4898B018.5050202@wpkg.org>
	 (sfid-20080805_220519_408842_EB7A6EEA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aOJDhMcInV+5JeN1D/eD"
Date: Tue, 05 Aug 2008 22:12:57 +0200
Message-Id: <1217967177.3603.60.camel@johannes.berg> (sfid-20080805_221341_426495_3FD57473)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aOJDhMcInV+5JeN1D/eD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Call Trace:[<c0060000>][<c0057150>]

My magic crystal ball says that this is not inside p54 at all, and
indeed a problem in your kernel patches. :P

johannes

--=-aOJDhMcInV+5JeN1D/eD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImLRGAAoJEKVg1VMiehFYH+0P/0MR58pRyCIYvWnx0ymr95YE
l8u2ia4QnOzpPTDoM8/57HCDKRyDSr1ILJPfuCCMu7hatv91sONxOmJMdRwHvhhl
5EfiCvDF+ppLH6ILF/PC3Qu60b94M9//SsXmmyBc1ajxwqbJwww2rSLLmFYShiJe
5ghATSq7/frmiZDej1hFwy+pHTle7tcTTCo3Nb6ohvWaVWVC+ZgJNN2ISQrXmKBc
J+SXYBmAWIHHSiCZ1Ydmfb2rVtmz8SBYSB6aat1s4emXwCWXtAl24ioh3bNg4rIx
bL7FFTyEMZXmaUQklnxjwQ/2GYecL6sJ2Lz3qEqLAMuG9TKVBD67m9nKedJfhSLV
50kHmfiloq4yxcw7i0iVRIrwLd6b2ic7ey1usnC2KI681ft0NCvD9PjgNfwu/+49
2joSLvgrEG1B6YqYh5gms+l+PTcSu/nAaTgBAo+MUXU1L87b1u6chtTJCGRtNg6A
avxd81hhQvb0J+e2NgMT8iwSP/uILd5Cp9syTbUYCVHZ1Ey9M3ajIQhBZvGbSQdr
Rb+0TdCEjrwrDccS6EAoeMV+y+8aJY9rQkEfSO3p5eUDhbZ2Eq2q2KSM80yCvv7T
Yk4oRh6Twq4OtTjT4V39nFaE2def6k06xlxFYjIQhbrkQWU85IJPUsctuWFPBZAm
BG9+skb1Kdv6drfy1VnL
=DVdx
-----END PGP SIGNATURE-----

--=-aOJDhMcInV+5JeN1D/eD--

