Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49923 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbZGPQoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 12:44:06 -0400
Subject: Re: [RFC/RFT 4/5] mac80211: Replace {sw,hw}_scanning variables
 with a  bitfield
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890907160930ra5111e1qac13701aed15974e@mail.gmail.com>
References: <200907161104.41975.helmut.schaa@gmail.com>
	 <200907161108.57436.helmut.schaa@gmail.com>
	 <43e72e890907160930ra5111e1qac13701aed15974e@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FZKXsMaNAV5My/Wt90j9"
Date: Thu, 16 Jul 2009 18:43:33 +0200
Message-Id: <1247762613.30529.33.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FZKXsMaNAV5My/Wt90j9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 09:30 -0700, Luis R. Rodriguez wrote:
> On Thu, Jul 16, 2009 at 2:08 AM, Helmut
> Schaa<helmut.schaa@googlemail.com> wrote:
> > Use a bitfield to store the current scan mode instead of two boolean
> > variables {sw,hw}_scanning. This patch does not introduce functional
> > changes.
> >
>=20
> > +enum mac80211_scan_flag {
> > +       SCAN_SW_SCANNING =3D 1,
> > +       SCAN_HW_SCANNING =3D 2,
> > +};
> > +
>=20
> But why is that needed? The commit log doesn't state that. We won't
> use both at the same time.

You're nitpicking ;)
We currently have two variables, and this just changes them into two
bits instead, so he can extend the sw-scanning case with another bit :)

johannes

--=-FZKXsMaNAV5My/Wt90j9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKX1iyAAoJEODzc/N7+QmaAnsP/0VaDF+KM48naX4BTpzTnpfY
F56Egy+y82kdHOBM6OgQyk2RicUqnE4MgZDfCOk3VsVVboICXfNlsOhZvsZu5c+w
X0yfDe/lc8MpSZnbRz0d95qSUplDs4yOUAAoAZAxFRPZZNs2HaFvysLHyc24tqmT
zXFZV7cmYilB3j+LW7aIN2duQpNpmDPeOiZ8jqIU5LYuj4Telf+IAUpADonQ0Dni
7fCcFI0+NUPsufv0AKllabWmnNCTdQlzhDZa4H3j2yHT1+cnTEKjTe3A1ZZlUFM2
giiddQHQhrAI3BM+2OlXxkA21HpigPa5YZUZu6IvHAWC1uifji+tSBzUiDYa2NFF
NOCIX4Y3tvG2d5VcfFTl0Zu4kxl9Li0m1SbsvWUPZJK6QWIZJyuUxZuCBbfAt0sI
Kmt+okX9NLxSxV1EoNHOT3cgcxaWrQTLl6f0ThbOmwJ1aDiC83kskplMO7fcaGRE
uxKzwleeB9BRNHacKQz5mmbG50Zv5LG8O9FPBhhUvDuKaKUQHJyK/BNE31Uu5xsd
84o+feHy34Nd/KDOCCZZiCml59BhsjWtgi4p5QR3uaIbVgGaAz4YoUeZibCTADd0
jT7/NL5gzdRNpHF6xYE094RNy/6J4bOVYAd8dOR+fbJNVnSdNzTRqzHyR17PMSDU
A7HwHUnwmDUE2Q++G/za
=s+IT
-----END PGP SIGNATURE-----

--=-FZKXsMaNAV5My/Wt90j9--

