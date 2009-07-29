Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbZG2Q0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 12:26:08 -0400
Subject: Re: WARNING: at net/mac80211/agg-tx.c:145
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Backlund <tmb@mandriva.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A707463.1000508@mandriva.org>
References: <4A6F264E.70501@mandriva.org>
	 <1248798501.13742.1.camel@johannes.local>  <4A707463.1000508@mandriva.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-61bcZHakQvgPOUA2yRnz"
Date: Wed, 29 Jul 2009 18:25:34 +0200
Message-Id: <1248884734.25614.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-61bcZHakQvgPOUA2yRnz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-29 at 19:10 +0300, Thomas Backlund wrote:
> Johannes Berg skrev:
> > On Tue, 2009-07-28 at 19:24 +0300, Thomas Backlund wrote:
> >> Hi,
> >>
> >> Is this known?
> >=20
> > I think so. The problem is that on a hw restart the driver clears
> > aggregation but mac80211 thinks the session is still up, I think.
> >=20
>=20
>=20
> ok, so is there any fixes to test...

No. Just ignore the warning. It's mostly harmless.

johannes

--=-61bcZHakQvgPOUA2yRnz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcHf6AAoJEODzc/N7+QmagssQALZmqxRx0DfBqBPL8+wIbOTp
Y0F2h6jC8ZvWr3EcWMehSsN+pWj3J1Ty8ac5WnelQ5Jy40z94vk+/rliLwl5eJVW
BZ1mRatXNySMZaRdF9q0gbl97O8t9bHmueH28PKjzszLbTCZiVuW05MhT/o/G6hO
ssZ6D2zowaTp9Av4RGzNounHqnUTRrFhSSmW/lxEqQmhh/aQiqCbQIXY661rqCfi
MOMG/lNw/hO3wcMTH9GstpXx6auzFHQP7CMy3+scByuozq7+7ae7kCtzIbiAs5BY
gHnxAhuEirtMjSaxfPn0L1bsu4+Wyn3+YMTwyzWW3tFWkNkem0AHZcGimk7mAcr/
JXZaMz8sCrwOijCtJmj8GWvlkvFpumxRsR+fILONHZE+4NFq4oTEQfEHMcpyNxIG
2E8UsLTzMDbqrg6C+TCLJYytP3dltJeiQqUgwbBtU03eJbyyOdxR+eoLTsTSlqb1
g4xKJL4LGk/Dl7iQ/Z5oP4ROWMX2kjNwpaEKr3Ma7LpPtpgtviP5o4YGRdERoiuf
FtMZdG9Is+o8FMm610iuYgj59HPQd97J/E/eFe541ZMkf0FeaYPSa8pH6RD33pEw
1XOfwFeJgdBpwgdR4L+MjaPVMu/auuOwBjo+Gm6RGIheRrwzoYgy7O2pdUXR+qAl
HHL1glGvyfh5W7Wpoq1q
=ozOB
-----END PGP SIGNATURE-----

--=-61bcZHakQvgPOUA2yRnz--

