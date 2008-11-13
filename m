Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38409 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYKMBnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 20:43:10 -0500
Subject: Re: [FYI] ar9170 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: "otus-devel@lists.madwifi-project.org"
	<otus-devel@lists.madwifi-project.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1226537117.14186.44.camel@johannes.berg> (sfid-20081113_014611_302976_93001DBF)
References: <1226531034.14186.39.camel@johannes.berg>
	 (sfid-20081113_000444_962024_07ACD3CC)  <1226531788.14186.41.camel@johannes.berg>
	 (sfid-20081113_001659_069366_BA2AA5E2)  <1226537117.14186.44.camel@johannes.berg>
	 (sfid-20081113_014611_302976_93001DBF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0o45f9KtGzeXFqzSSKiU"
Date: Thu, 13 Nov 2008 02:42:39 +0100
Message-Id: <1226540559.14186.56.camel@johannes.berg> (sfid-20081113_024315_327480_4AB1362F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0o45f9KtGzeXFqzSSKiU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-13 at 01:45 +0100, Johannes Berg wrote:

> Better URL is
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-ar9170.pat=
ch

In addition to that, you will want to apply this patch
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-mac80211-fix=
-tasklet.patch
too because otherwise sometimes mac80211 will schedule a disabled
tasklet with the expected dead loop consequence, and then later will
even wait for it to finish... I'll submit this proper once I've figured
out why it's happening.

johannes

--=-0o45f9KtGzeXFqzSSKiU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJG4YKAAoJEKVg1VMiehFYfloQAIVoO3GAsbySm0RjATfltXzt
s1qEHUz2ksOM3KFkfiTmgeWtWFwFPRaMiDIYhV2UZbB1Pn1E1C1dj6H2XwkLOWdM
EUvebFaqhowc1zgDmTMPJy/O7Hu8df/Mmx2Es/ieVrFXwRAM4jgBYTx3v4Ay7wX2
TIiM8F+Dsg3IU6BeB9FSDZ+aMmTCq6nLNOsXUxQhGAa4nEJPzfOL03pEz9ZSbJDA
uVgXCkyhB/I1QWMo5yKe1m2jEj1iNvgxolXLl1JZVMKGQvhtsATlKMkVY4pxLSZd
2/56nIPUc5N81mbYS49Zqk1GDMivjcgF61swlc0se0VjJg918B1WOkoMAZPAFANQ
8ZVG9fSv/Lw1rGQBIxC/I8lk6Ec8aNcGzFPG6987cLtQDQ+JwXtaD97OhFxWOwSC
AUhWaB3Hj9ODHp8JtJ8iSO8LkSXAL/zRQceAOJOl/ZeJZTbUfAU5fHR6HF86O7j9
GSmelL9Qbp7biUcnMSNcXB7SxDwuor+HID504+u3YxIbnrGpkKIcEg4ASYDWWZ54
NYNgGfO1y6MWPeJO8OQrMGaKrmQPsho1L1pJ3Fh2dK1454r1SZWORxpem+bsbJGK
edku55IjBV32oV/EJxVVRKI7mBSCudqVhcND1yRgEN4fnNr8AOeL50OaCbfwfHFk
cpyV65ZL7wKNakr4ouBe
=54p4
-----END PGP SIGNATURE-----

--=-0o45f9KtGzeXFqzSSKiU--

