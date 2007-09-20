Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51827 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbXITODF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 10:03:05 -0400
Subject: Re: VT6656 driver source available from VIA
From: Johannes Berg <johannes@sipsolutions.net>
To: Forest Bond <forest@alittletooquiet.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070919193743.GA14127@storm.local.network>
References: <20070919193743.GA14127@storm.local.network>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ugojDYHwHrai8OcjtxqG"
Date: Thu, 20 Sep 2007 16:04:25 +0200
Message-Id: <1190297065.18521.61.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ugojDYHwHrai8OcjtxqG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-19 at 15:37 -0400, Forest Bond wrote:

> This doesn't sound very GPL to me, however, the twist is in main_usb.c:

Not really.

> MODULE_LICENSE("GPL");

> What do you think?

That declaring MODULE_LICENSE in a file that isn't licensed under GPL is
a violation of the kernel license.

johannes

--=-ugojDYHwHrai8OcjtxqG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8n3p/ETPhpq3jKURArDZAJ4lqFaeZqI+OP2L8VJNy7Nqw4qyzgCgsPba
C18qeTioxHUzWtdxdLikLes=
=/REc
-----END PGP SIGNATURE-----

--=-ugojDYHwHrai8OcjtxqG--

