Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbZIZMHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 08:07:15 -0400
Subject: Re: [PATCH 2/2] at76c50x-usb: set firmware and hardware version in
  wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, Felix Bitterli <ic.felix@gmail.com>
In-Reply-To: <da94abde0909251211x347bbd30xdfe2bd05bc1e07e5@mail.gmail.com>
References: <20090924180048.14503.9579.stgit@tikku>
	 <20090924180251.14503.64152.stgit@tikku>
	 <43e72e890909241135j21f687a7oc4f929d2134b6310@mail.gmail.com>
	 <da94abde0909241210m69bd619sce62645c3aca9aae@mail.gmail.com>
	 <43e72e890909241311j552ee33ata80ba24c386a316b@mail.gmail.com>
	 <da94abde0909251211x347bbd30xdfe2bd05bc1e07e5@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-K1Fl/KByigClFT6N5hyi"
Date: Sat, 26 Sep 2009 14:07:15 +0200
Message-Id: <1253966835.5122.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K1Fl/KByigClFT6N5hyi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-09-25 at 12:11 -0700, Kalle Valo wrote:

> I agree. I'm not going to work on adding the driver name right now,
> but maybe in the future.

$ readlink /sys/class/net/wlan0/phy80211/device/driver/module

johannes

--=-K1Fl/KByigClFT6N5hyi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKvgPwAAoJEODzc/N7+QmajM0P/RNWPnkIQFYvwyoMaUGZvDKk
6jEq+PsoacXnx/8AdmHBudb3xUjC2ZfuSgZId5ERbSDQ29gAGRdn7CplOFnE29u3
l2THFGoLz4ptw7ukoPa2IgUCK0tNPwBWn1sFHM7qzKzkEfsyKobVtzvn3ILEL/YE
BUg4waPLAnHZsEeRsLzD4VmlYCtZcCu4p1mZB6ZEzxg9UVCpP226ZKeMAlnprm5Z
K7x5BIkY2m5FSWRRok9hQ7uXMdCiMHTJWDVuQqJYKndDoowVlda+q2F5lBI5VQ2R
+JI4zwSufXjwWi0IUJMyfztXipqKaTgl4ESlg1D0q4nTfVFUVajr6K7LvR4xu5bb
aVwtXCMoegbM6RzEAjZ9SrZu4P9k9/IpBufua5dGqPApC92v/2V/CKfSyu7imPxS
MTjtRa6d5rpN8/ejgQwpS3F+4PLZ1dnNTKJpVDXnG4GUnYxL98fu+SXRQrhaXt9y
T/s31qkLNcmpOEI3btkEG4odZKPpAKGsgcfEHvwVpAr0pwGrGj8wGmQl/D8r7xJk
u81H4jGDLA2zU6h9mpixUcuenp+VM57sUuIcFSiX37CkpSu1F51Ha7VPIrDtP7ku
VE6vtVfz2qnbOxqQYfTjBehkNea/rLSr3qAPwd1r8Lz+A9uONWuB6wYMqrhW9PZq
r31GfTl9wnppKiAPYZy7
=wFxO
-----END PGP SIGNATURE-----

--=-K1Fl/KByigClFT6N5hyi--

