Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55229 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbYKFMQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 07:16:16 -0500
Subject: Re: b43: Everybody with PHY TX error, please try
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200810242032.04295.mb@bu3sch.de> (sfid-20081024_203730_616101_C9986446)
References: <200810242032.04295.mb@bu3sch.de>
	 (sfid-20081024_203730_616101_C9986446)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Bxj2+QVPvznYfAZPtpA/"
Date: Thu, 06 Nov 2008 13:16:13 +0100
Message-Id: <1225973773.3619.216.camel@johannes.berg> (sfid-20081106_131619_854118_54B9C005)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Bxj2+QVPvznYfAZPtpA/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-24 at 20:32 +0200, Michael Buesch wrote:

> Try to reproduce the PHY TX error with the new firmware.

This helped neither with the PHY TX errors nor with the RX errors where
I'm getting invalid frames passed up from the firmware and run into a
WARN_ON:

drivers/net/wireless/b43/xmit.c:49
(b43_plcp_get_bitrate_idx_cck)

johannes

--=-Bxj2+QVPvznYfAZPtpA/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEuAIAAoJEKVg1VMiehFYdncP/jGsI68fnbuiCugarlTW0xiu
7olSeaOoIY/RRlUBzrKksG41zSszvJAOAajBKnLGJV8bGzSafAEBI95eGVJj3Onz
fohOgA/HdsNR8Av0jw8yqNtrZUG3VF06u7VTFg2NUd43UCZwLiMuctyUOeO+5U3d
wQ7ug/dbhqHwRZm0HN9MgRHKuVrg1iSXySNGDJOaPL7iWgKvAe3MZyZTfmbLp/7t
Y89x11mEvUKF5I0NKtXIFGhQ9qs9xIQWd3QlQTxEo9MEO6Tfort6N0XsKY5IyEDI
wGbwPPlhSyDFaAUUht1BOiRk/wKRZWeONV/XDdmOcemmSc6frfzj9x8aoyuyuCyz
FJ9qPU1szxGhTRw+noPpaQCwI5gA/OtA2dK/iEDQ65EqQQxbiVEoShvvWKzuDsp9
22SsVOzV0uYqyp6Im2woCNVktdmM4meulA1BAWGvKwQHTRSkWuTN26yg+UZjo1pt
u7HpvmRKaELePAdS9+6nP81r/Q4cxuBDgwFWZSIndvA5zOyqPvaSj2wLHr0Qm/JZ
/7BakCTF59hUkHEETRHcWlkDsPrfgY7KIwRJZvRiaNXAOCkGlxJk4Z1Vat6le1qg
n5oi9LLYjK44reoFJIQFAN1Lr1KFqlTU/KcAy0flKo73s2vPtmhU5UjZoz42UZdG
z++zgAZoLZ9pH/V6yhbN
=5RFk
-----END PGP SIGNATURE-----

--=-Bxj2+QVPvznYfAZPtpA/--

