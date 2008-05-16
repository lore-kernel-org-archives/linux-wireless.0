Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbYEPUYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 16:24:47 -0400
Subject: Re: [ipw3945-devel] Monitor mode on boot
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Martin Dubuc <martind1111@gmail.com>,
	Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20080516172738.GB9880@tuxdriver.com> (sfid-20080516_195059_372322_570219A1)
References: <7a0107ba0805151404o778a09ddj522fffa3edbeec6@mail.gmail.com>
	 <69e28c910805160316q7c1b869an7fd554979ea260b8@mail.gmail.com>
	 <7a0107ba0805160627l55f53b04r69a32e1bba36ecb6@mail.gmail.com>
	 <69e28c910805160703j4fef73e8x2c357f91d4b43ea5@mail.gmail.com>
	 <20080516150824.GB6510@tuxdriver.com>
	 <7a0107ba0805160906r4bfcd09ch6e550b929e3bd21d@mail.gmail.com>
	 <69e28c910805160916o68ba2512k3aaab29d592c54ff@mail.gmail.com>
	 <7a0107ba0805160926ib7cc07er57c00054dec238e@mail.gmail.com>
	 <69e28c910805160940x3de182cdrb1d49588ccb392d2@mail.gmail.com>
	 <7a0107ba0805160948j3ca21a85v1b5fce8ddca23ac9@mail.gmail.com>
	 <20080516172738.GB9880@tuxdriver.com>
	 (sfid-20080516_195059_372322_570219A1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bX04kU6T8SO7mbcMx39c"
Date: Fri, 16 May 2008 22:24:31 +0200
Message-Id: <1210969471.6381.42.camel@johannes.berg> (sfid-20080516_222450_612056_BBDE126F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bX04kU6T8SO7mbcMx39c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-16 at 13:27 -0400, John W. Linville wrote:
> On Fri, May 16, 2008 at 12:48:26PM -0400, Martin Dubuc wrote:
> > This would solve the boot up issue, but probably not the case where
> > interfaces are added after the system is booted up (USB or PCI cards th=
at
> > can be hot plugged).
>=20
> udev?

Yeah, I was just about to suggest the same. Learn how to use userspace
tools, we're not going to do it in the kernel no matter how much you
cry :)

johannes

--=-bX04kU6T8SO7mbcMx39c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC3tfqVg1VMiehFYAQLJuA//YtKTBzrAe3PvIsaRwwsKu37MatXpOJHz
IzXtmfmkmpFGOKAoKmqwlAXWszj19YLxD+InypItTPsUqHqD9VrKoitmhimeu7RT
7whqUYq4CBxo+RshVLTa5GZEgtPpMnjvxzG92dDmZRxLQQSvfjy9zbuP5KCZZB7X
mzlVvp6+6R2Z3WA6hPxXoAy40MJL/+S88v3FJy2jK+n3bpmrYMew32ewjS6bqCzA
femzZ65p16VGugp6cbulqutKOngpJU+BoDquEZvBFrr3G6VRSO85cpFE4v0iW9Wp
2txNFY1q8Ql7O8BCaRwf2ET8BiQkCTNN5KxUWzgizg3Y9MHdmHrGn5sZLyerNeA9
3FU4DnK1kP70GzPe79LyOy7jydqzukdyLU2OSOxpMAF9n0rFObGYmmfmpNCQBEP5
JeQBIfNFf7HQYI6KVkYChjW+jEZDGrO0/WT+31IWRVEof0JPeLNfGQsM84YaFzAH
qXxIPy87zGr+jCsYNPfboJphe5q9hKA7FYIbi035zUDYfXkkLAH2sqFuc1GJqQNx
zFgLcOst5AhQqC9n4eVzEHBPUTYJkV+wirX4jXovQIFxQ7Cqo9ZlKqL6XRqsWOmz
VXy2+XSlqijKLkZJeCIlcbWFA4sNps72BO3u32SLwFd0iq5/zXFdVqD0q/dLwUCw
GF04tDOcXxc=
=/wJl
-----END PGP SIGNATURE-----

--=-bX04kU6T8SO7mbcMx39c--

