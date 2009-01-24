Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52187 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbZAXO1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 09:27:14 -0500
Subject: Re: [PATCH] mac80211: Generic TSF debugging
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1232806359.4036.3.camel@johannes.local> (sfid-20090124_151246_101797_74F9E228)
References: <20090124060959.50440@gmx.net>
	 (sfid-20090124_071031_925716_84EFAC47)  <1232806359.4036.3.camel@johannes.local>
	 (sfid-20090124_151246_101797_74F9E228)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6uxwanyr9Nf2QXtjuSY2"
Date: Sat, 24 Jan 2009 15:27:08 +0100
Message-Id: <1232807228.4036.12.camel@johannes.local> (sfid-20090124_152718_174310_172E2F7D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6uxwanyr9Nf2QXtjuSY2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-24 at 15:12 +0100, Johannes Berg wrote:
> On Sat, 2009-01-24 at 07:09 +0100, Alina Friedrichsen wrote:
> > This patch enables low-level driver independent debugging of the TSF
> > and remove the driver specific things of ath5k and ath9k from the
> > debugfs.
>=20
> NACK.
>=20
> You still haven't explained why you need set_tsf support and why it
> should be a generic mac80211 functionality.

Ok, I guess you have, I'm still not sure it's the best approach.

Other opinions?

johannes

--=-6uxwanyr9Nf2QXtjuSY2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJeyU5AAoJEKVg1VMiehFYVDUP/j5wncVmp4H6UHRjvMRgg3Nt
+1xuwrEdVQkEgJfa+RH1cW2jwMitM3f3IM4L+egGJfcNxN7UlDR8FoU3rDu8ta97
K0aPUjky7kUhD+0V6rJ9gxou6+IZQQC0Hpa857MCTJVEKGIf/pKOBSoOHtEHg8Gb
Twa/7VO7jw1YBf68lIMkiy38uj32BjwgyYo3xUGZGSMNM9s1+h+yPhh2X4+0p2Od
V0uruZcM1nscckr/j8jnCRW1l93gjGkGVM9MBPJrFGtBLrQX5U8MKsPq9fpDJ/ln
G768NCUDXmTK681vUw4WMRfrc1ACr60h09B2PpKL1Vd2FIKQjFkpPmkgWM4sFhht
m4Tt4snLmP/h2Wdel/bXEAusydTQP1B8qzRhzLX0Pecd9bb5demfZhDMfIiBp6hO
0seogZ6+3ZUAnEyLkQlQsHidWHDTfShCGkHylE5i6gzr4L7wWj/XXY9Td87BcVpd
Iumrp0rbX7r/mE3ln714k6HusqYbNh1hT43wbI+NHV20A5hzgjib6KlrOntM3LwB
hqWOorGV22Iqux0sXAJz47LyI5xtdajmE7GJ7hp4J2YoVLpZu9tG+nU1kIgMRcTa
lSnTa9Bfd/a/aC0OK9aCBlet70FKsGDc+ggUc/rU4/ebe1w6KBtS2hsTRrU/I8uE
kbb3mUqQca7o9iqT+4l+
=SsGe
-----END PGP SIGNATURE-----

--=-6uxwanyr9Nf2QXtjuSY2--

