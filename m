Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34158 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbZHZWNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 18:13:18 -0400
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: htl10@users.sourceforge.net,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890908261506h6b9ec4efq2d190388663d4671@mail.gmail.com>
References: <850984.89698.qm@web23108.mail.ird.yahoo.com>
	 <1251297273.15619.11.camel@johannes.local>
	 <43e72e890908261333m1d576fdhaa16088affec5426@mail.gmail.com>
	 <43e72e890908261506h6b9ec4efq2d190388663d4671@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4x0bZxX7ii1yUzATsjBj"
Date: Thu, 27 Aug 2009 00:12:35 +0200
Message-Id: <1251324755.20531.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4x0bZxX7ii1yUzATsjBj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-26 at 15:06 -0700, Luis R. Rodriguez wrote:

> > Neat, thanks. Not sure if I'll get to this this anytime soon, but if
> > someone is interested in it please give it a shot and send a patch.
> > That would be nice.
>=20
> What if we *also* just do that from mac80211 as well upstream?

Why? It's fine as it is, and we don't want to clutter all cfg80211
drivers with it.

johannes

--=-4x0bZxX7ii1yUzATsjBj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKlbNPAAoJEODzc/N7+QmaJiwQAJd6C9ax0LOVqwagaALCGFui
/6YW3sw/0RX6NzAEzJ6PNW9F0l7kpviVglIJKQHflbxTODaknypnBZ8DSitBXKsG
mTxXL0Naa7ZVn8b13n0hz8+xeCYPpGCTgsG6fsjQTaVm/qe43/C043wvVsGTBLzQ
7Aiv+qJVLi5Aw9Ex5hciHOo4/odVpg64Y3C1cR0GKOT7i7T+Jt2mv6Iz6ss0XAHs
8fBJpL421pTw9Om57p+z5r0yncoxES7iptGJwu/Qe3cCK5Fll6ph4NlphTv9fMJE
zqvTE/nbRVGZkqDgyy2Hi16B4sYR0+yYFnvx8iju9NqThtFhzUj9jv366HsOWuNQ
pJabWE4m+TW3N3J0+4WjQvTfP4QgUREvv5kcNJJI/oktFLKm8SsD/lBZeTls6XdL
4a9HvuDCZZVIAsTb8T3j53C4VJMFJ4q0oHezZOYsJk0rS5CvanOU/GuyTC2uUsqp
cJjWTxZ07A4zI4OPvQsCkGFnPIPA2EBAMzMYtIbD04zw52/MwgQdaLhpBCQM6uhr
KPypPRGl74l+/qomNuXaQQNCopgcYjFLGikjGtMo/R8B1KoJQIjHa6bdljSTtK96
7f0srKJPtr9rS7pNWa1jI0O+y9AwACA2w0lWFF2uImR+IvOA9rD9GIoL3EYWTadc
Wjj0R4ajfRA5PE8qUV9C
=v0iZ
-----END PGP SIGNATURE-----

--=-4x0bZxX7ii1yUzATsjBj--

