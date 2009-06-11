Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:39891 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZFKN6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 09:58:16 -0400
Date: Thu, 11 Jun 2009 09:50:42 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: VT6656 driver source now GPL
Message-ID: <20090611135041.GE26234@alittletooquiet.net>
References: <20090319164256.GA25237@storm.local.network> <43e72e890903190945m4d8920f5y69f5847b688b0aa1@mail.gmail.com> <20090320131014.GG25237@storm.local.network> <20090414000835.GA31504@storm.local.network> <20090611132954.GA20845@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tVmo9FyGdCe4F4YN"
In-Reply-To: <20090611132954.GA20845@prithivi.gnumonks.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--tVmo9FyGdCe4F4YN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Harald,

Glad to hear from you.  I was just about to contact you regarding these dev=
ices.

On Thu, Jun 11, 2009 at 09:29:54PM +0800, Harald Welte wrote:
> > I'm getting the sense that there is not a lot of developer interest in =
these
> > drivers. =20
>=20
> I am not surprised.  I personally have not yet seen any remotely popular
> product in the market that uses a VIA wifi chip.  However, this might cha=
nge
> significantly in Q3/Q4 this year.

I have heard from a few interested parties at this point.  Greg has been ve=
ry
helpful as well, although that doesn't seem to be related to his (lack of)
interest in these particular devices. ;)

> If anyone wants to work on a new driver for the vt6656: I am happy to hel=
p with
> interfacing VIA's R&D in case there are some specific questions.  I
> unfortunately cannot help with releasing documentation, as there is almos=
t zero
> documentation on that part. (not a big surprise, even Intel has no progra=
mming
> manuals for their wifi chips...)

I'm currently working to get the vendor drivers into staging.  vt6655 is
currently in linux-next, but there are some stability issues that may have =
been
introduced by some of my build fixes (or may have been present in the origi=
nal
driver).  I'm currently preparing patches to merge vt6656 into -next as wel=
l.

You mention the idea of working on a new driver.  Do you see any value in
merging the vendor drivers and cleaning up from there?

BTW, these drivers could certainly use more expert attention than what I can
offer.  I'd be interested in working with you to get the vendor drivers in
shape, if you think it is worthwhile.  I take it no one at VIA is able to l=
ook
at the staging drivers in -next?

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--tVmo9FyGdCe4F4YN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKMQuxRO4fQQdv5AwRAulYAJ98zaONeS0CR67graTGuNXvcF/2QwCgtdeB
gx4aSapWpmJQugbxFP4g23s=
=fU1g
-----END PGP SIGNATURE-----

--tVmo9FyGdCe4F4YN--
