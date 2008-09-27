Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48967 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYI0IiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2008 04:38:21 -0400
Subject: Re: wireless-testing modpost failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, YanBo <dreamfly281@gmail.com>
In-Reply-To: <2da21fe50809261325o62dea98dyf40b06e373f29f53@mail.gmail.com> (sfid-20080926_222513_164399_16E42BBE)
References: <2da21fe50809261104m3b7d99e3g8b56416b8182ca45@mail.gmail.com>
	 <20080926190007.GD3483@tuxdriver.com>
	 <1222457416.3798.25.camel@johannes.berg>
	 <2da21fe50809261325o62dea98dyf40b06e373f29f53@mail.gmail.com>
	 (sfid-20080926_222513_164399_16E42BBE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CVim7+vuXa+6q3JwhWYo"
Date: Sat, 27 Sep 2008 10:38:15 +0200
Message-Id: <1222504695.3798.38.camel@johannes.berg> (sfid-20080927_103825_094353_5CEDFB62)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CVim7+vuXa+6q3JwhWYo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-26 at 22:25 +0200, Davide Pesavento wrote:
> 2008/9/26 Johannes Berg <johannes@sipsolutions.net>:
> > On Fri, 2008-09-26 at 15:00 -0400, John W. Linville wrote:
> >
> >> >   Building modules, stage 2.
> >> >   MODPOST 216 modules
> >> > ERROR: "mpp_path_lookup" [net/mac80211/mac80211.ko] undefined!
> >> > ERROR: "mpp_path_add" [net/mac80211/mac80211.ko] undefined!
> >
> > Davide, can you tell me what file/line it fails in?
> >
>=20
> How can I tell you that?

Good question. I was thinking the linker would complain at some earlier
point too, but I'll just try to reproduce it myself.

johannes

--=-CVim7+vuXa+6q3JwhWYo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3fDzAAoJEKVg1VMiehFYW0UP/1bGzJSiRCguxykhwo9EpuAg
XAX1q4/+w34IS8yh9FKpkWKrXEREPHtuoEbQx2Q7FCBpopvQLB5b0YCJsh1mRYYz
VXXuIphV9hda1TkN4gfrb1Zd8NYQERqqZi2PoIN5SEHEDW2ky+6b4kWk8tvdokI8
HtPe5oO/LZU9T8bMXOz1MHwVQw3tf7kWAD85EHTeQIWw6IHWkKvGelCv6iOhloFT
JQvwIx6/2hEkgjk6SAkazkyb4Roq05hXrFrb8C4XynbXQKMDYgCPAnCZtfRNcObg
55Xs0IQ2RyImFTk1fdh66MMRcos4/TrMi5gEFXs0GMaIeBdSwpJzqRfg+zvgq91J
KMFLCG+AMbZj2JJ/P7xkGGCREEj5GdbUiU208wwmEkigi+25OV1yAfzDcuWesKRY
rJzgthyz2dxjboyj3oUgkj2HyFdKA3/WhaUySI62QSJhfFABqDkwIjMhtUSkbO5z
L4u0N6ms9YWMZks2F5fLUPBuOy2wQctm7kAA4vPbAk1GMM+Qek43wrCyZDs501V+
v16q11ZFgvAvIpMY+KZlAEyU+Y9cRPm5VU6TNkTwt+8fY4gEQsvdgfsjXwHhAiQb
hSPcavr2Gmop5NZ6O+uxjwMyWdJkdoAzA9ZnSN8NtbEMj4jekZlnehMCNpZB61r3
/rhSbN0JjVn2/M3IO1bi
=RJlH
-----END PGP SIGNATURE-----

--=-CVim7+vuXa+6q3JwhWYo--

