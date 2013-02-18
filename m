Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47617 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756630Ab3BRDQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2013 22:16:05 -0500
Message-ID: <1361157348.5374.538.camel@deadeye.wl.decadent.org.uk> (sfid-20130218_041610_595305_4B3DDF0C)
Subject: Re: [PATCH] linux-firmware: add carl9170 firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Dan =?ISO-8859-1?Q?Hor=E1k?= <dan@danny.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>
Date: Mon, 18 Feb 2013 03:15:48 +0000
In-Reply-To: <201301180052.07145.chunkeey@googlemail.com>
References: <1342353398-3147-1-git-send-email-xose.vazquez@gmail.com>
	 <50F5DD2F.2000907@gmail.com>
	 <1358458004.15692.147.camel@deadeye.wl.decadent.org.uk>
	 <201301180052.07145.chunkeey@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-uJYblT6t9dxwI+p3UkwF"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uJYblT6t9dxwI+p3UkwF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry for the delay in replying to this.

On Fri, 2013-01-18 at 00:52 +0100, Christian Lamparter wrote:
> On Thursday, January 17, 2013 10:26:44 PM Ben Hutchings wrote:
> > On Tue, 2013-01-15 at 23:50 +0100, Xose Vazquez Perez wrote:
> > > On 01/14/2013 12:27 PM, Ben Hutchings wrote:
> > >=20
> > > > OK, I've worked this out now: there are two post-processing steps
> > > > required, one of which is done by './autogen.sh install', and one o=
f
> > > > which (add a checksum) is not done at all.  I've added that step to=
 it
> > > > and can now rebuild a bit-identical image.
> > > >=20
> > > > So I've applied this, made a few fixes, and pushed.
> > >=20
> > > Sorry, I took half sabbatical. Now cleaning inbox.
> > >=20
> > > I believe Christian releases a new version(1.9.7) recently,
> > > and I did send 1.9.6 months ago. It should be updated.
>=20
> Depends. [This would be another question... what qualifies for
> a new push to linux-firmware? Should there be one for every=20
> series-of-related-patches? release e.g.: 1.9.7, 1.9.8? Or after
> the firmware passed the test of time?]

You should assume that updates to linux-firmware will quickly appear in
distribution packages.  So, only send versions that you think are ready
for everyone to use.

> Anyway, the biggest 'new thing' in 1.9.7 was getting "Link Time=20
> Optimization" ready [1].
> =20
> > I'm happy to take either a single patch for the new release or
> > one patch for each commit in your repository, whichever you prefer.
> Would it be possible to attach a carl9170fw-x.y.z-source.tar.xz/bz2/gz/zi=
p
> along the carl9170-1.fw binary instead of the source dump in carl9170fw/?

Perhaps, but what would be the benefit?

Ben.

> I've picked up all of Ben's carl9170fw patches and added them into=20
> carl9170fw-master. So in theory we are good to go.
>=20
> Regards
>=20
> Christian
>=20
> [1] <https://github.com/chunkeey/carl9170fw/commit/1a2fbaf4f621cbb37f3663=
7b1d4101f453474f7a>

--=20
Ben Hutchings
Sturgeon's Law: Ninety percent of everything is crap.

--=-uJYblT6t9dxwI+p3UkwF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUSGc5Oe/yOyVhhEJAQpFCg/+IqPOh1qtwHl02SEJsbUXJ4ueMoersfAJ
7jfJT8MFjIjMBI/S/UMQAyNpFuWRT/O6mA2ESdiUWHs4tsxDe8H+TqiAOH1w3Jh7
0NaOolB+PCkvNOHxm408hleExLZZOQeO+/tV7B1obKU8r9/it7PZKRlncppeB4KQ
1KtZkMN6/h2VgkiKCGBd/6ygDCzLQtdk14ee+ksX3Hh6MddyKFMOViElcStcd4Jn
V+c9BnQOPugTz2o8rH0iX+HCMTMPhaexv/mtSHFAQDVLwif+zrSZ2ElWhQ+bMQ/z
egqA6MHxhrDCd5rJ+EBLrFwnrURkb7ktcCe+7mmiEoBdI9yvjavbzYXYPhpEQDry
IvQpaeVjKbHBmY9UFStIeKc+66hbA1L+qumE61rLpmfANjk6bdLqBscqNY6zZn7B
CXFa9p3VCMdWeOTpWmsdOWVPhpBMwn5dLuDL/vnCc/LaCKAbDJ/iHwRcpC+/gpNs
K/SWP5mcifNv6kzaekB2ROULlY7JTscbEtRItYeC8BR9D8YYPa1GnQ6OzW2iW3Y4
FhUay+yPrkLBdqzCaT+iARQAgFWKDG8y/cOfTDtWtY2Ejn/MfpwsGHqffQGt0NwJ
jsWVeeqrEbzSK2wgOCYRXze07tlVhGAXcvQbOX8Fu1g58sXZHa7F1ZEcWYwgn+lp
FD4r1ncCohc=
=RMX1
-----END PGP SIGNATURE-----

--=-uJYblT6t9dxwI+p3UkwF--
