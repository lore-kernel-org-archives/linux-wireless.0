Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42105 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbZIUHPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 03:15:37 -0400
Subject: Re: [RFC] nl80211: introduce NL80211_ATTR_SCAN_EXPIRE
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <200909210842.59852.hs4233@mail.mn-solutions.de>
References: <200909181849.22302.hs4233@mail.mn-solutions.de>
	 <1253293842.4787.1.camel@johannes.local>
	 <200909210842.59852.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mzPDqYgvbMFskAeBoJqy"
Date: Mon, 21 Sep 2009 00:15:33 -0700
Message-Id: <1253517333.4458.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mzPDqYgvbMFskAeBoJqy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-09-21 at 08:42 +0200, Holger Schurig wrote:
> > > It also allows to set an expiration for
> > > NL80211_CMD_TRIGGER_SCAN. Setting the expiration to 0 will
> > > clean the whole BSS list.
> >
> > tbh, I don't really understand the need for it. changing your
> > AP settings doesn't seem like a use case anyone would really
> > care about that much.
>=20
> Turning of an AP is one way making the AP vanish.
>=20
> Sitting into a fork-lift and driving throught a ware-house hall=20
> is another way to accomplish the same.

It's not actually the same, and you didn't explain that well. You care
about the disappear case, but you made it sound like you cared about the
_reappear_ case.

However, I still don't believe that you need to change anything in the
kernel, just get wpa_supplicant to handle it properly.

johannes


--=-mzPDqYgvbMFskAeBoJqy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKtygQAAoJEODzc/N7+QmaOucQAIh5imM1/t5O8kxeU02bg9Br
s4rIQbzflP9w708vH1okjGZ4GWCoP/Ud7TQbsbzMUJUjMO1JUVD43gVp2X7Fcgbq
zgAYZQJtwRVlGG3MtRRC1QvVN9qW19Yb5vQfnrA5j1+T4kExKvwfPFTFjrtZ0j3O
6b3BVd/di1bomgteK/1526j28b/DEpmqcgwXmkstWkhRlk666j6DVuHXTNr2w1+T
o7WPhVh0VUWzZUpLaXady1nK24wSKzS1fiajxa4oUwdWv1HlLDoGZMxhjwzHTDjk
ZrSdB8yn/9MOjBYqoFUjy5JeLquoOND2jouuwdoJHhPYzYh0dMs007Vfsnod8wOT
8j1+y7KzFV+JyzC9gA0k4fEhwk07Vc1dLx+dH6GVsstBlw0M1qUmLyxyIIxslxLG
hZfexQEk133K1mljQBHOmszcLPTxX16dVyPpLg/cqItOiYXimDmjUbI9JjLzv6tP
4Bs+Uc2c9nvPet1moEvJ7GFpeWHbLgJzlMiAOvt1e4YeQddZ4BXKI7zorx4yDVgr
xo+ugjT/697wmGQFrgBR/jpbXXMAisUow85/dtU4XbMHY1pUMT9x/RKrss5Q6X/F
cY1mqU46enEn9OxSpI/2Vs7B162JmqccNJwONWohxS9ospK0bhybWc+HTBiYN1dM
bxLgbELLI58RCz8UYr8J
=SF1Z
-----END PGP SIGNATURE-----

--=-mzPDqYgvbMFskAeBoJqy--

