Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47488 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293Ab3AQV1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 16:27:06 -0500
Message-ID: <1358458004.15692.147.camel@deadeye.wl.decadent.org.uk> (sfid-20130117_222710_749568_08025F02)
Subject: Re: [PATCH] linux-firmware: add carl9170 firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Dan =?ISO-8859-1?Q?Hor=E1k?= <dan@danny.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>
Date: Thu, 17 Jan 2013 21:26:44 +0000
In-Reply-To: <50F5DD2F.2000907@gmail.com>
References: <1342353398-3147-1-git-send-email-xose.vazquez@gmail.com>
	  <1342666598.11373.97.camel@deadeye.wl.decadent.org.uk>
	 <1358162875.15692.14.camel@deadeye.wl.decadent.org.uk>
	 <50F5DD2F.2000907@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-DNb8daDx8TpALPXDg4tA"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DNb8daDx8TpALPXDg4tA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-01-15 at 23:50 +0100, Xose Vazquez Perez wrote:
> On 01/14/2013 12:27 PM, Ben Hutchings wrote:
>=20
> > OK, I've worked this out now: there are two post-processing steps
> > required, one of which is done by './autogen.sh install', and one of
> > which (add a checksum) is not done at all.  I've added that step to it
> > and can now rebuild a bit-identical image.
> >=20
> > So I've applied this, made a few fixes, and pushed.
>=20
> Sorry, I took half sabbatical. Now cleaning inbox.
>=20
> I believe Christian releases a new version(1.9.7) recently,
> and I did send 1.9.6 months ago. It should be updated.

I'm happy to take either a single patch for the new release or one patch
for each commit in your repository, whichever you prefer.

> Also, Fedora people are working on building the firmware
> with native distribution tools, see: http://bugzilla.redhat.com/866051
> (Cc: Dan Hor=C3=A1k  <dan@danny.cz>)
> direct link to the patch: http://bugzilla.redhat.com/attachment.cgi?id=3D=
652642

Stefan Lippers-Hollmann <s.L-H@gmx.de> has been working on this in
Debian.  For the mean time I've added source and binaries to Debian's
firmware-free source package, which doesn't automatically rebuild
anything.

Ben.

> added cc: linux-wireless@vger.kernel.org
>=20

--=20
Ben Hutchings
I'm not a reverse psychological virus.  Please don't copy me into your sig.

--=-DNb8daDx8TpALPXDg4tA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIUAwUAUPhslOe/yOyVhhEJAQrOqA/3UdR+5yjDHKOBFfKICZVWwo7iF2CjagH6
CbJkeeXyn5ft0t9nPbBvKTH70HetgozC+HbO+k8qWqYgeoRx1rHoTh49QuBIBtlN
jR9jbNnHXZXcAFP0pzpobuFlRVS9b9o6kfbl/OpiGqZEyBoo38hwm4ZEmvriFRVA
suvHy0el1k3Xou3NrE3FbPoFsBgUW2XbzuDaQ8aOuirf7vQTn7WDl8cDjs5kP5JW
sKWt6IqvQFMMtTeixaJ+T2EUONEPIwfRTlTyWmGG9EhFjvtjkqsD/egpM+UdBenN
XZYFpBGOXBU4y7z/fc/W5xCnprgkY8dz7KFB9FF7AvEazMIszu8EfU5kLZlD5CIZ
dBTVIzYDYNcSs91Fbw6ohihDtASlYxfdrpqUI4Ahuog7YqqYUxcduIYn19jBMhjr
gJHUPwwWhxEU8OFdYmAnevTNnC8T/m+DY39MrRPSs7QWZFS1GBAMNyIlSO4Ul/5O
Pj96yh0k1Ttn9ExRydTP7f+mfUSwkImS3h5RxGnMN4hCXjHUJI1sV6yv7u3XeiNo
EngdTNPUmU5cVS/r1Xbsbw4+IOS89Gu/WVxlPDJT6Ef+bkCqKuJ/sCuBVAuDsKQ2
JO2aGN60MvLWutONKT7E0yamxklhm3b/scyB6bJNdEKg4M6t94D8HHjj3hV/bBWP
jEPy3tCk3A==
=QbSu
-----END PGP SIGNATURE-----

--=-DNb8daDx8TpALPXDg4tA--
