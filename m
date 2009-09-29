Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55555 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZI2VDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 17:03:06 -0400
Subject: Re: [rfkill PATCH] default install to $(PREFIX)/sbin
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090929210001.GG2678@tuxdriver.com>
References: <1254246097-4490-1-git-send-email-linville@tuxdriver.com>
	 <1254256477.30589.1.camel@johannes.local>
	 <20090929210001.GG2678@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ujb7kRM532go/LU5T75k"
Date: Tue, 29 Sep 2009 23:02:40 +0200
Message-Id: <1254258160.30589.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ujb7kRM532go/LU5T75k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-29 at 17:00 -0400, John W. Linville wrote:
> On Tue, Sep 29, 2009 at 10:34:37PM +0200, Johannes Berg wrote:
> > On Tue, 2009-09-29 at 13:41 -0400, John W. Linville wrote:
> > > The rfkill utility isn't generally useful to normal users, so move it=
 to
> > > /sbin with other system management executables.
> >=20
> > Seems to me that it's kinda useful, it should be possible for most user=
s
> > to use the event and query interface if the /dev/rfkill permissions are
> > set up correctly.
>=20
> Sure, but (just like ip, ifconfig, or iwconfig) nothing stops people
> from using them in /sbin or /usr/sbin.  It is just a convention for
> tools that are more for system management than for day-to-day use.
>=20
> Hopefully most people will stick with NM or whatever and may stay
> completely unaware of the rfkill utility. :-)

So are you going to send an iw patch too? :-)

FWIW I like tools in bin/ since the default paths on most systems for
users don't include sbin/.

johannes

--=-ujb7kRM532go/LU5T75k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKwnXsAAoJEODzc/N7+QmaX1kQAJefHg/bbQSQiHKa+mRhgeW2
SupyPc/xCFg9y/qxrMR06tcbiBJCnQGUlNLgfcYBNcbkDs5W++v+t0rm7H9+olFH
rIeLDXS4SwlaAbNM8o9pVNfAnZ4lWDhGDP4YwJWZ6RrEkt4pnVeVKY7O+WpUOx0l
W8LS3uEdSgKnwXZ9UbzPdTiWe6gkzqp+R1+LQaJ/zGb01+nbgh7NFNqmqEMuQIzW
yzX2jSxXoQjiM7l2Fuj702r+DXdkqWi7SN8Bs2UndwDowo/p0sBnrltx4uvopXLN
Bb/6RwqBa0OFq3b39yA8W6uQUOWnJtPlkTC9sNGKHvIy0PxVr3zjOLJBzF/REqus
D2uyu9VUXojTVX7vcqq0oAWJa5/4PRZdDEP8s6LBLT8HL8aPQbWtZU0Qf1RcTyUD
9vXEie5v569MrmFaYeh/cbgkNd81/HLX9h3Xr4WtEv3ANNzVvq3KkchXL5W+4S1v
sp/mGHCJTLriFPdjeE6hfdaOwARccvEVKfw1lvZe6RTM4rqTEcuhnmoL4KC2orhh
lVId+94TVV05wQFqONCdDmllw/z1o8WQVQ4Y6rjrPK5SDEX+7wMdFkUHnGJq3D4o
Loj3f4qJlZVzEtmM7lDu1DzdjvGavXL9ycTtyKua7khM0h+zFKhV+OKxo7QX8+f+
vhoiW5ZeZyJ7GLK/YEov
=/uui
-----END PGP SIGNATURE-----

--=-ujb7kRM532go/LU5T75k--

