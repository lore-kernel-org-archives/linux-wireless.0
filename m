Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60596 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbXHOKxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:53:31 -0400
Subject: Re: [PATCH 4/4] hostapd: remove PRISM2_PARAM_NEXT_MODE
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240708150029n7ae1223ax87a287b80e967543@mail.gmail.com>
References: <20070814093254.021041000@sipsolutions.net>
	 <20070814093410.322846000@sipsolutions.net>
	 <20070815024135.GF1415@jm.kir.nu>
	 <1ba2fa240708150029n7ae1223ax87a287b80e967543@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nOVyXueHx2a1KxPEZ83l"
Date: Wed, 15 Aug 2007 12:56:02 +0200
Message-Id: <1187175362.3998.17.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nOVyXueHx2a1KxPEZ83l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 10:29 +0300, Tomas Winkler wrote:

> Just a small example as everybody knows the major distinction is in
> modulation schema i.e. CCK vs. OFDM. 11b only devices are deaf to OFDM
> traffic so we use CTS/RTS to overcome it which in turn slows the
> traffic. Sometime B-only or even G-only (no CCK rates) environments
> are required. I've used to have laptops with 11b only cards so I've
> configured the AP to B only not slowing even more the traffic.

That's more a matter of only announcing B channels though, not a reason
for telling the hardware that a B channel was selected.

Of course, it is not inconceivable that hardware may support turning off
OFDM completely, I just haven't seen any yet :)

johannes

--=-nOVyXueHx2a1KxPEZ83l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwtvC/ETPhpq3jKURAqy7AJ9MsoafihlGawfEmDCxLiCw9kOl0QCfcRTK
kGGI3h0+S3F7N/cnp3dm294=
=P6pe
-----END PGP SIGNATURE-----

--=-nOVyXueHx2a1KxPEZ83l--

