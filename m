Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57409 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbXJJJZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 05:25:31 -0400
Subject: Re: rt2500pci 2.0.9 not working
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcus Better <marcus@better.se>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <fei4sd$mm0$1@sea.gmane.org> (sfid-20071010_100953_396055_10BC12ED)
References: <fdqhn4$qab$1@sea.gmane.org>   <fei4sd$mm0$1@sea.gmane.org>
	 (sfid-20071010_100953_396055_10BC12ED)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QQTn8/VDdJjYZIOGtoZ8"
Date: Wed, 10 Oct 2007 11:26:24 +0200
Message-Id: <1192008384.12541.8.camel@johannes.berg> (sfid-20071010_102544_673574_BE8F5F7C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QQTn8/VDdJjYZIOGtoZ8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-10 at 11:06 +0200, Marcus Better wrote:

> Neither does 2.0.10 from the current wireless-2.6 "everything" branch.
> I see scan results now but cannot associate with the access point
> using WEP.

Can you try that patch from Matthias Nissler ("[PATCH] mac80211: Defer
setting of RX_FLAG_DECRYPTED.")?

johannes

--=-QQTn8/VDdJjYZIOGtoZ8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwyav6Vg1VMiehFYAQK4oA//VwfuhKqzryv6/JUoCGSb14Vp2sHv5gbe
TIUAxHkTcM2+CDm/F5BM8+RGbaAHp/g1FnrnKocZiVcQj0ZlFTLHL/ivfKC/MBJP
NPQn+AeI6ufehr4xRH6cFFpH+IVwN1DZ6k11Eeu2ymjWOAy1PnfzQFnIg9V6wsx8
2Wtbr/ztQy7hzouCAplyfuLCDtNtouUh+igilHzMfIoqxEEBxbf5PiyjNH5U5uUX
OokMaiKyV1jRqrIRyLFXBtIypNa0uulFT6rouFq0iHpXc6eqfbfDrdY4fwpl5Zoc
dovOEZaaRXIlv2c8Q2h9ViUyEcqWT9hDj3MPhpmFIWLAyW3vm/uUDRg0E5Cbis0W
TnqoCDCXn/LKTNgPsnkJg/GS+e57+HxjRT57oLC/L6FnKQ9RAwcg49HgTvky9F5W
CuzDvto8EMo/8CFjS2LlBt3iIm/gEztpZy+jBY44tt+EbkHquvLSNUwVOG/RoSaM
eGB/BOq7QCNAWq3f//lVlcamsoAYiWEAz5g47Fgq1HUmwVkY4nWQd99VlANM1xHz
HpZd+uCEb0tTYlJUHzxWgL2xyZuw3hoGaEfbUi9eq8ed3pLNNe88J8seHlxcXZfZ
8mK75sDbRriew2Xughr8knE9Q7U+dKIfrprAh2ix3eWBP7C5BBULuO0xi9kGY0Cf
To4OG9GjR+I=
=b6XS
-----END PGP SIGNATURE-----

--=-QQTn8/VDdJjYZIOGtoZ8--

