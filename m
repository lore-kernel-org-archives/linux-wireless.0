Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54331 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbYLIVNT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 16:13:19 -0500
Subject: Re: [RFC] mac80211: Disable requests for new scans in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <1228853236.18616.1.camel@localhost.localdomain> (sfid-20081209_210814_025117_B90F808F)
References: <20081209145722.GA2285@jm.kir.nu>
	 <1228844410.17539.1.camel@localhost.localdomain>
	 <20081209193351.GB16905@jm.kir.nu>
	 <1228853236.18616.1.camel@localhost.localdomain>
	 (sfid-20081209_210814_025117_B90F808F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JO0YXzqiEo7bqgnhTAhw"
Date: Tue, 09 Dec 2008 22:12:44 +0100
Message-Id: <1228857164.1029.22.camel@johannes.berg> (sfid-20081209_221323_296821_F8A555DC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JO0YXzqiEo7bqgnhTAhw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 15:07 -0500, Dan Williams wrote:

> NM only knows about devices that NM controls, thus we can't have NM set
> up the device and then subsequently ignore it...  However, at some point
> in the near future, if we can get reliable information as to whether the
> driver *does* in fact support AP mode, we can make NM drive the
> interface in AP mode instead of IBSS.  The only reason it's using IBSS
> right now is that the driver support for AP mode was so inconsistent and
> buggy.

Somebody (Intel, I think? Or MS?) has also been showing off
functionality like STA + IBSS (or AP) on one hardware. We totally should
beat them to the market with that :) Needs driver work, though.

johannes

--=-JO0YXzqiEo7bqgnhTAhw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPt9JAAoJEKVg1VMiehFY3hwP/jCRA7jTB0H8QSkK0XTOm4KX
1FfG8F59d9tj623ttXke9a5jOhYKfvE0gqH9G/iwu/9+HcVrYzmC3cnsaddC1tY8
2+Obxmq5kpHrA193VEimE8IMIxWrTeToyQF6esGTLf/zsgi2TJ82kQf+UlaQYrQC
utK8nzM7J0j0M4vNTejEWeQmkcBudtczBDiSdk/i5O5MDC5QMg2voegETYhsAcP6
FUtOTZz3WGhFBJQ6wmZkKIMsu6jfTkA1Yotflsn6347XhY0dQud66IaD50FnMmRU
MPUkgB0+v1v34x4rmtd7YPyhHVjHXmD6evkUmNnrnsyHGqqOnUt/oWJb1EaN+Qou
ObwMJw+MoQGlEsg/ouj8PnmSEVVfCeZkGN7ySaUQYqAUhX8Ua3517WgZyZXH3y6v
wYvhu8WANsuXZ+QrqpIFLbYvlSlhNrwMBLOC4IPP4OgoPpkpbUlvQqze213YVeHS
GLgv+ZZ8rypjby2N81o3YBVDyt/k3Y1UACjcFyoOWI9o5BgPFUe2DIR7Vxrhk0OP
+8OTVrjqYO0g7x33ja7hrC6RvjjR51FqKFnHxO0NetwVvoygW0yn+KZz1XXNG8zM
hlkvWqIzLiwk29QVrZWKnTzpgboJCaE/NSmxymsvP8+ysEOXCsSPdUsW9/IgUEhD
VmmHkO9M4DZirp0o/B2/
=aNd9
-----END PGP SIGNATURE-----

--=-JO0YXzqiEo7bqgnhTAhw--

