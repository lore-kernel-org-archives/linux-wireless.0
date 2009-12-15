Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57982 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761089AbZLOVZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 16:25:42 -0500
Subject: Re: [ath5k-devel] [PATCH 2/5] mac80211: Add new callback
 set_coverage_class
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: =?UTF-8?Q?Luk=C3=A1=C5=A1?= Turek <8an@praha12.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20091215181149.GA2123@tux>
References: <1260899813-17585-1-git-send-email-8an@praha12.net>
	 <1260899813-17585-3-git-send-email-8an@praha12.net>
	 <20091215181149.GA2123@tux>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2n62eK+2+HxQIfDQfU34"
Date: Tue, 15 Dec 2009 22:25:30 +0100
Message-ID: <1260912330.10356.57.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2n62eK+2+HxQIfDQfU34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-15 at 10:11 -0800, Luis R. Rodriguez wrote:

> > +       if (changed & WIPHY_PARAM_COVERAGE_CLASS) {
> > +               if (!local->ops->set_coverage_class)
> > +                       return -EOPNOTSUPP;
>=20
> Hm, it seems best to just add the capability bit that way userspace
> can stuff what it wishes and the kernel will only set what is supported.
> As is now this would lead to -EOPNOTSUPP but we'd have no way of knowing
> from userspace what failed.

I think if it cares, userspace should just be careful to only change one
thing at a time.

johannes

--=-2n62eK+2+HxQIfDQfU34
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLJ/7GAAoJEODzc/N7+QmakiwQAMMnyacnpvGN+OafwOWOr7Dr
vXTgs3OEW5S0HyNImuS72rgP6RJCLo3QM5lPYFbPJ4Bto5/Pm81e3nWVW9YkMl0/
zwUDGCfCHekdrC9GGWPTT6YTPajNZMe7l/FlbX5TCLkaGMiWzOkimcGnNJHx2PlJ
AvfE+mUK8snCOFJF0N/tf9EoSW4UwGZOtm/u7CVygQ9/PJ2L3zQxMbGxBZgXxw1V
JBkJXbaNRM1oB1+3nFIgtsiFj6WRS3ckiqR9epRLSI7l8H9GSa1wt5gmDU4vNRiA
0NOTxAHqoSl+aLmMl3Eqb1dV6x90sELSe/btt35RN7lNSGkSgGrPdpc2UCAaMWcx
oQ0cxx0NlyfSsjGkqPdahW1N+3MITFreYDgDrAPZoMiTmTUqoWMViqyWeMdmfqdQ
FLxk4+BlJp47FReoAj+iIpxPpNv70qxS+kMmojZCTuJMyLoqSp/0Hke1RRG0/+E5
HbMbt28CC3r13VOWBw3oV478TINycLNzc4eBscjhpJGW2oaFw52LccA/0ywK3Z9S
wa3ikve1cA8T6jcSEiu1Z8/6OOMYGAH8L43KFFEn5V1ouOhXwHe+mlFC/fyJ/NY8
wHnPfzEL7cb9USKhkQs4JFlXOhm+Lotu2MyeDDtVYIIHLf1fJVPchxqGDpnoI18c
JAziX5eQuzKwogi954IG
=iZZd
-----END PGP SIGNATURE-----

--=-2n62eK+2+HxQIfDQfU34--

