Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42600 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbYEMI7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 04:59:42 -0400
Subject: Re: BUG: scheduling while atomic: rt73usb
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian =?ISO-8859-1?Q?Sch=E4fer?= <schaefer@in.tum.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <482952C3.9020209@in.tum.de> (sfid-20080513_103525_899450_BDE1A917)
References: <482952C3.9020209@in.tum.de>
	 (sfid-20080513_103525_899450_BDE1A917)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Z3lNhl2v1dIOZQ6WkBea"
Date: Tue, 13 May 2008 10:59:31 +0200
Message-Id: <1210669171.3646.49.camel@johannes.berg> (sfid-20080513_105945_523741_DD26F6F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Z3lNhl2v1dIOZQ6WkBea
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>   [<f929715a>] rt2x00lib_config_erp+0x7a/0xb0 [rt2x00lib]
>   [<f929623c>] rt2x00lib_intf_scheduled_iter+0x9c/0xf0 [rt2x00lib]
>   [<f9309841>] ieee80211_iterate_active_interfaces+0x71/0xa0 [mac80211]

If I read this correctly, it was recently fixed (but not committed yet
afaict)

johannes

--=-Z3lNhl2v1dIOZQ6WkBea
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASClYcqVg1VMiehFYAQK/5A//TXpIIHD+8d9DGM5DnXgHHxxlkEo8ieV5
QbSpRmimO8VgrxPn2TmqD67hpj52Le09JG1AeUPWSnBIQDvXDsBBEGD2R3Reex5G
ZRW7WmhCbGRYPMElLoj7MftP5Vov/VEKvTc21yawCau1fDYvKII0JnfjAbxmlmuh
CMK2cnJC0IZoWZ5cAbyY08JH62qhVNPAlBBdqQj4E/kFuriJrbaGnWZbvWY0vI3l
mhn9MYwSIQCi/RnlsyF4cMFDFV1ftrLZA2vpcs/DFbCXiBezEg/yhsKmPlX+srz+
MxEqF7Sa7LL+Uk+tFDT1Eb0hrUf5ouziGot522hhDzOL4iKXFVsw5pEKXemF260Y
WdMHEq95cK1U+gr1mKwNqYRlmUh9FMWmpXDoeBaR5eHtmN+x0ZQZutkgsNCq0hNx
R4rFH1Fx4XEZqaUWvBjt5k5g4/arBal55FCWWuf6rolYc76lh7SJQXMVcbToR/gl
4ZBWTUGVgyOr7BqW+4XDyNmQe29/C4qO2G3W1d/pgvBOYWa9zgh7ye7z8mBg03T3
n8qM/dHizkxFAEGKmSIYR0gjIYNaS6VZLvJ/mo5gx7rHlT/7yUXyMOjidoIvEW6p
kvqa3rU97qaJrRhwFL3OZNtEpWYOqElQ9TVzkSEnXpNUMTAB4iQAv51Ap/d1cFux
YBaLf3QkBcM=
=XsxQ
-----END PGP SIGNATURE-----

--=-Z3lNhl2v1dIOZQ6WkBea--

