Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762104AbXGKJk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 05:40:57 -0400
Subject: Re: Errors when firmware is missing
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@gentoo.org>
Cc: Jon Smirl <jonsmirl@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <468FCC4A.2010102@gentoo.org>
References: <9e4733910707070927l37bdf79cpd1fc672909fb0bb3@mail.gmail.com>
	 <1183826476.3779.42.camel@johannes.berg>  <468FCC4A.2010102@gentoo.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cydmixhUSWopAHz2I2Gz"
Date: Wed, 11 Jul 2007 00:58:12 +0200
Message-Id: <1184108292.3738.28.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cydmixhUSWopAHz2I2Gz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-07-07 at 13:24 -0400, Daniel Drake wrote:

> It implies that you have a way of reading the MAC address before=20
> uploading firmware. I only figured this out for zd1211 by reverse=20
> engineering the boot code to an extent.

Hm. Good point. I sure hope no such devices ever show up ;) Or you just
create a device with a fixed (but random locally assigned) MAC address.
Or even better we globally define a locally assigned address for "no
idea yet" :)

johannes

--=-cydmixhUSWopAHz2I2Gz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGlA8E/ETPhpq3jKURAmWKAKCA3N99A8kBzGgfVApDjJr1A/jxDACeKC8L
gk62JP1AdMSzwBrZnfLc7ho=
=qCde
-----END PGP SIGNATURE-----

--=-cydmixhUSWopAHz2I2Gz--

