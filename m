Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49436 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbXITQPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 12:15:18 -0400
Subject: Re: wext 64-bit: network manager and wpa_supplicant
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Jean Tourrilhes <jt@hpl.hp.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1190303433.2016.10.camel@xo-3E-67-34.localdomain>
References: <1190292526.18521.52.camel@johannes.berg>
	 <1190303433.2016.10.camel@xo-3E-67-34.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pqyzEdbafeVtverl67uT"
Date: Thu, 20 Sep 2007 18:16:26 +0200
Message-Id: <1190304986.18521.87.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pqyzEdbafeVtverl67uT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-20 at 11:50 -0400, Dan Williams wrote:

> You mean it doesn't work correctly when handling ioctls on 64-bit
> platforms?  Or is just plain broken in non-ioctl ways?

The former. It starts fine but sees no networks, I guess because the
networks come in a 64-bit format it doesn't interpret. I haven't really
dug into it.

johannes

--=-pqyzEdbafeVtverl67uT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8pza/ETPhpq3jKURArIgAJwPzXRkF7ESWjZvHlqyEBDLSKwM3wCfV1jl
5FABgbDu5fKYrZzppYD8PMY=
=/qaK
-----END PGP SIGNATURE-----

--=-pqyzEdbafeVtverl67uT--

