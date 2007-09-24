Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41500 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758857AbXIXRSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 13:18:49 -0400
Subject: Re: zd1211 config operation problem
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200709241841.50232.mb@bu3sch.de>
References: <200709231648.17107.mb@bu3sch.de>
	 <200709231348.30055.flamingice@sourmilk.net>
	 <200709241841.50232.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZxMXNpAQc0SRLu6c111z"
Date: Mon, 24 Sep 2007 19:20:00 +0200
Message-Id: <1190654401.18521.272.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZxMXNpAQc0SRLu6c111z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-24 at 18:41 +0200, Michael Buesch wrote:

> -	if (local->ops->config)
> +	if (local->open_count)
>  		ret =3D local->ops->config(local_to_hw(local), &local->hw.conf);

Isn't this racy?

johannes

--=-ZxMXNpAQc0SRLu6c111z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG9/HA/ETPhpq3jKURAhwKAKCPm672VPHzXMcagis7a63LwEuC4wCeM1v2
hAaODHAX634qAfNHLwGxZEE=
=FotC
-----END PGP SIGNATURE-----

--=-ZxMXNpAQc0SRLu6c111z--

