Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbZGOQVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 12:21:08 -0400
Subject: Re: [PATCH 3/5] cfg80211: add WoW support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
In-Reply-To: <20090715161600.GF5682@mosca>
References: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
	 <1247617320-20163-4-git-send-email-lrodriguez@atheros.com>
	 <1247658322.2302.1.camel@johannes.local> <20090715151425.GC5682@mosca>
	 <1247673906.10754.14.camel@johannes.local>  <20090715161600.GF5682@mosca>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-C9WAm5g3Dlz2bk6SSvfx"
Date: Wed, 15 Jul 2009 18:20:29 +0200
Message-Id: <1247674829.10754.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C9WAm5g3Dlz2bk6SSvfx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-15 at 09:16 -0700, Luis R. Rodriguez wrote:
> On Wed, Jul 15, 2009 at 09:05:06AM -0700, Johannes Berg wrote:
> > On Wed, 2009-07-15 at 08:14 -0700, Luis R. Rodriguez wrote:
> > > > > +	if (!(wiphy->wow_triggers_supported & triggers_requested)) {
> > > > > +		err =3D -EOPNOTSUPP;
> > > > > +		goto out;
> > > >=20
> > > > This seems wrong, should be "requested & supported !=3D requested",=
 I
> > > > think.
> > >=20
> > > The above one won't return -EOPNOTSUPP when you add additional junk, =
you're
> > > right, better to just inform userspace of that.
> >=20
> > Your version also disallows turning off WoW again, afaict.
>=20
> That is something we do want, as otherwise we'll keep the device powered =
on.
> Will consider both.

Huh? There has to be a way to turn off wow again after you've actually
resumed for other reasons, or whatever.

johannes

--=-C9WAm5g3Dlz2bk6SSvfx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXgHJAAoJEODzc/N7+QmaiWQP/1bCjYwnfL5LgitBfM6uma0z
WxhmSOdDNrVY/T84Eb56O7/IxwlbgQWFw9kgk+4fMBI73tqEgdL48Jm2M0EXBT6/
uSyvBl3pmrvJUNcoITe2I70htTh0Giv/DKSzDTcXQYdkTajcEV/QheobxdMrX7Ej
dsaRyyFobsh0JdeEbNUfa8PTD7+ecPNPw/KKBu1m1eQHxY+oDS2d8CFHSOt13U6g
Se1X1oUIAXz/9CTqEFi9cOczq9sR4LTfJUutCnPrUdJ4bjY1yhvCLQxSWU1Xl4ZP
YOxugKn5C0Uc1pxprJbETPkkfXfg/+tkLKMDjyUPEM+wRI0i22jl0gY8gPOdk2X2
YqlWIJmi7yFRG8GWQju7PiT/VnuFFaZcJj5B0XG5rDYFYXJB4Ijmtb7VToac4pAa
C/pVmDfexCFs001B29v1ptsssat5k/GTYKqJe8FcpyHRT6jlXpp+ep9rsrvbJ2g8
5iVWeVXsWdUgz8k4Q8NKf3NHC8tI0wLwuv1T+D8lwF5gG7rErfzbukLetidyc8T2
52cVieIkL5oHAGbp3f4MG5XFqW8ULRV4xyWluBWxe9WlVNU6tF4bpljWTTP3JIla
TmeQhT5kqybjM5inndzuveNjIIMG7qgcsQzegQKciD38ZQaB5JtpYK0Jet9W/0fa
vLlop0uTOe5gukJI/ufv
=T4el
-----END PGP SIGNATURE-----

--=-C9WAm5g3Dlz2bk6SSvfx--

