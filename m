Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYFXKqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 06:46:36 -0400
Subject: Re: [PATCH 4/4] mac80211: add phy information to giwname
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <200806241242.11727.mb@bu3sch.de>
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-4-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-5-git-send-email-tomas.winkler@intel.com>
	 <200806241242.11727.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z2UAlWzizK6Ec8wvxLGc"
Date: Tue, 24 Jun 2008 12:45:53 +0200
Message-Id: <1214304353.8967.275.camel@johannes.berg> (sfid-20080624_124638_953039_A2DEC1FA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z2UAlWzizK6Ec8wvxLGc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-24 at 12:42 +0200, Michael Buesch wrote:
> On Tuesday 24 June 2008 12:38:01 Tomas Winkler wrote:
> > This patch add phy information to giwname. Currently
> > 802.11b is not treated.
> >=20
> > Quoting:
> > It's not useless, it's supposed to tell you about the protocol
> > capability of the device, like "IEEE 802.11b" or "IEEE 802.11abg"
>=20
> Well, I think it _is_ pretty useless.

I agree. Nobody uses this information.

johannes

--=-z2UAlWzizK6Ec8wvxLGc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYNBeAAoJEKVg1VMiehFYc1kP/32eKp0j4APSZqevtUgzdoqD
Y4ESJBBTL0JBOyxgeBxhFUrf16ShsyMOlujUTK9Ku9DmT6dBkpQe+n66CtsURHs2
aERyL2w03NhJQIlh33qRnQJ2hMXKlWGxJt1Qh8RR1wbqLMECBUP9obIVpdPS9JSj
EIyGQH7BnDN6RcTcyQhebYHQ1qecWRvnq01tRJsbOURNUWuhq4E0B3r1Ava9niVM
rwQvS6DLILrJxv3dIjoHz9wO5Q4DlBphp++gtvxOvaJu7Owsqryv+buTY9/rGEdM
QnZHjoT1F1SzFZQkpLlK2xq+LJjCxcqH+TzBpCXhz79NNgSPD7sc9IwHeoq8fiwO
t9Uqikq578xLfFxHPIoczViFIUkqOnJal1rqjMG4GWg2eWfGNBGnrlGQ0X/d0dG/
2q2sbv0hV5awyARfLv4l2bb+Qo9aVbSbmogBVMmzjE9ZZvx9g3RRMHJKw2joC5cv
XDLMHzJLDtV32lLX1t+3rBTK/JuE2FZPlBtYyOWg78CxLAhrmswb1cg573/Vndkc
PSwePZ0+tXCjntiwYJOBqmXgpT2Rtg/Nq7R7CURAVm+uiaPm/u5qKE59p20pMctQ
usqGYeEK02K618ikSywZHrX1bQPgUngrj0eChKhTByJqmR2KnO/zmfS6Hx/Xcmos
uyCoyzrt40YQArmIyCpd
=gGLy
-----END PGP SIGNATURE-----

--=-z2UAlWzizK6Ec8wvxLGc--

