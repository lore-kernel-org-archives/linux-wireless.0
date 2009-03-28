Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59423 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbZC1R3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 13:29:41 -0400
Subject: Re: [PATCH 6/8] mac80211: add skb length sanity checking
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890903272000p2c00f80au92441f8df31bcb24@mail.gmail.com> (sfid-20090328_040036_592794_382DBCE3)
References: <20090323162834.154525349@sipsolutions.net>
	 <20090323163053.073748867@sipsolutions.net>
	 <20090328024023.GE5543@bombadil.infradead.org>
	 <43e72e890903272000p2c00f80au92441f8df31bcb24@mail.gmail.com>
	 (sfid-20090328_040036_592794_382DBCE3)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-z3iMSLyzXdATmpqz8tiG"
Date: Sat, 28 Mar 2009 18:29:34 +0100
Message-Id: <1238261374.4217.1.camel@johannes.local> (sfid-20090328_182944_601383_3930ECC1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z3iMSLyzXdATmpqz8tiG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-27 at 20:00 -0700, Luis R. Rodriguez wrote:

> >> This patch adds a sanity check to mac80211 to catch
> >> such driver mistakes; in this case we warn and drop
> >> the skb.
> >>
> >> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> >
> > Heh well this is obviously even a stable candidate and it got
> > merged already :D.
>=20
> Nevermind, I was looking at .30, heh. So if zd1211rw also manged the
> skb len in older kernels it seems this is stable candidate. Too lazy
> to check right now though.

The fixes should go to stable, but this won't apply without serious
backporting.

johannes

--=-z3iMSLyzXdATmpqz8tiG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzl57AAoJEKVg1VMiehFY3dcP/0tupqDCzua6J6rltH8rKmrt
AoWbKMx52D85tUQ0zYyAHBFl4M7UYQVM0WZCRyfKtVpmhXCrXGu6DVXJAA0RojgW
G64yMwJaPixC/Hm6ZKSwnp6bMmvfNA3HDUH1qrntR+hg3KLrwHsYILS/AT6jet/S
tgMNc/dFvKfVblMspUttQink9v0wkj1cvS3RcOJaPRa07ilVmW1UMUBrpK4mR3NA
LiUNbXuTQ+StdSeVEnrg5UfCtJqlIoULJQUQvIJFcrEN5ABd2E3YkdFX1vLz2m+J
m3bsSgTwJo0mws++xEQjO/nIJ9O87sZQR4GYd0hJYIq8OoS7CC8SFQsz76P5JjVq
+U4FZ1vPZLP+bdg7ZdR9my1molTwnoJGcU5iyRl8YaN36jWIR5PoJzd+M0sDNpz0
Qj2BWe06w4na+fZ4MwmgoGt3pPBW9Hdi46vyTQ4Yr1inIA+rQ4gGZr5HnMYiMBEe
B4AO+oKehOCSoC/OmlAgAxS9144doDMd9E8oInpccP3HcGg3ixfR4/zSVmjpS0o1
ML7l9mLeq2qpLaNY2rjvZfsI6GL7qb3caCYmXFURhGuVpXL0rdBnttZSTfaqms2A
6tw1IhYXCbGglWZB7j4laBdZXooyWitaw+QLM4xu4AtBbdCzdBwPvtZae4xSM56g
A1XW70x0Wxe2nDalDPSH
=QtKC
-----END PGP SIGNATURE-----

--=-z3iMSLyzXdATmpqz8tiG--

