Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:41087 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbZDNAzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 20:55:54 -0400
Date: Mon, 13 Apr 2009 20:55:23 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	Greg KH <greg@kroah.com>
Subject: Re: VT6656 driver source now GPL
Message-ID: <20090414005523.GC31504@storm.local.network> (sfid-20090414_025601_012369_DB783152)
References: <20090319164256.GA25237@storm.local.network> <43e72e890903190945m4d8920f5y69f5847b688b0aa1@mail.gmail.com> <20090320131014.GG25237@storm.local.network> <20090414000835.GA31504@storm.local.network> <49E3D7AA.1050207@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8X7/QrJGcKSMr1RN"
In-Reply-To: <49E3D7AA.1050207@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--8X7/QrJGcKSMr1RN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

[Re-added Cc's, hope you hadn't dropped them on purpose.  Sorry for spammin=
g if
they were trimmed deliberately.]

On Mon, Apr 13, 2009 at 07:24:10PM -0500, Larry Finger wrote:
> Forest Bond wrote:
>=20
> > I'm getting the sense that there is not a lot of developer interest in =
these
> > drivers.  Is there anything I can do to aid in getting these drivers in=
to the
> > kernel?
> >=20
> > I would be willing to send patches, however, my experience with kernel =
hacking
> > is limited and I don't have a lot of time available to contribute.  Wit=
h a
> > little direction, though, I might be able to get somewhere.
> >=20
> > Any input would be appreciated.
>=20
> You might be able to get it added to the drivers/staging directory - that=
 is
> where the c r a p drivers that have no chance of making it to mainline ar=
e put.
>=20
> To see what is wrong with that driver, compare its coding style to that o=
f any
> driver in the drivers/net/wireless directory tree.
>=20
> A second problem is that no new drivers that implement a software-based M=
AC
> layer are likely to be accepted - this driver would have to be modified t=
o use
> mac80211.

Great, this is enough to get started, at least.  I assume that the quality =
bar
is low for code in drivers/staging.  Low quality work is a trademark of min=
e, so
I should be able to tackle this. ;)

Is there any reason I ought to think that it would be easier to get this
accepted in linux-staging than drivers/staging?  I'll admit that I feel bet=
ter
about the layout of drivers/staging than I do about the quilt stuff in
linux-staging.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--8X7/QrJGcKSMr1RN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ4977RO4fQQdv5AwRAnVaAJ9r5YBC9ioNzNvyIx3tXTBUBd3OHQCgyvsV
FfEK6H4iqT2Pml4FiMP/auQ=
=0qMg
-----END PGP SIGNATURE-----

--8X7/QrJGcKSMr1RN--
