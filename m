Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:36446 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbYAGUcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2008 15:32:07 -0500
Date: Mon, 7 Jan 2008 15:31:01 -0500
From: Forest Bond <forest@alittletooquiet.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: VT6656 driver source available from VIA
Message-ID: <20080107203101.GA4599@storm.local.network> (sfid-20080107_203211_108871_803B1EDD)
References: <20070919193743.GA14127@storm.local.network> <20071101185900.GD14943@tuxdriver.com> <20071101190711.GB17825@storm.local.network> <20071101191250.GE14943@tuxdriver.com> <20071105020730.GA4414@storm.local.network> <20071114170051.GD23778@storm.local.network> <20071114170634.GC6226@tuxdriver.com> <20080107184949.GI18550@storm.local.network> <43e72e890801071220r33401a6cg30a0bf4fc391b452@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
In-Reply-To: <43e72e890801071220r33401a6cg30a0bf4fc391b452@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 07, 2008 at 03:20:02PM -0500, Luis R. Rodriguez wrote:
> On Jan 7, 2008 1:49 PM, Forest Bond <forest@alittletooquiet.net> wrote:
> > Hi,
> >
> > On Wed, Nov 14, 2007 at 12:06:34PM -0500, John W. Linville wrote:
> > > On Wed, Nov 14, 2007 at 12:00:51PM -0500, Forest Bond wrote:
> > >> On Sun, Nov 04, 2007 at 09:07:31PM -0500, Forest Bond wrote:
> > >>> The post is here:
> > >>>
> > >>> http://forums.viaarena.com/messageview.aspx?catid=3D28&threadid=3D7=
8745
> > >>>
> > >>> Any noise that can be contributed is welcome and appreciated.  You'=
ll need
> > >>> to create an account to post, though.
> > >
> > >> I also added these.  Perhaps having plenty of content/links regardin=
g this
> > >> issue will help to increase visibility:
> > >>
> > >> http://www.alittletooquiet.net/text/a-license-for-the-via-vt6656-lin=
ux-driver/
> > >> https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/1=
62671
> > >
> > > Excellent...I appreciate your efforts as an agitator! :-)
> >
> > At this point I am not anticipating positive results WRT this endeavor,=
 and am
> > unable to pursue further assistance from VIA.  Further, I've seen that =
the
> > driver in question likely exhibits some interesting quirks that makes it
> > difficult to use.  It is also bit-rotting out of relevance.
>=20
> This is unfortunate to hear...
>=20
> > Can the driver be used as a reference for a fresh implementation?  I've=
 not
> > written a driver before, but would be open to the possibility.
>=20
> IANAL but I believe It basically depends on the license the vendor
> issued the driver under and its sources under. If no license was used
> then I believe the standard copyright license terms should be assumed.
> What license was used throughout the driver files?
>=20
> > What are the legal ramifications of a driver author having access to
> > proprietary source code?
>=20
> Again, I believe it depends on the license/NDA/terms under which the
> driver author obtained access to such proprietary source code. The
> more details you provide the better.

The license was omitted.  This was presumably an oversight, but intentions =
are
always hard to know when the other party isn't saying anything :)

There's little doubt in my mind that we get nothing more than fair use out =
of
this package, though.  The question is "is that enough?".  Code copying is
obviously not allowed, but is a new (and sufficiently different) implementa=
tion
allowed?

-Forest
--=20
Forest Bond
http://www.alittletooquiet.net

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHgowFRO4fQQdv5AwRAjRHAJ9hreuHeRAFXLBbmW5n0DITdJ7XiwCgqcDC
GyCmICF8c1betjppbqgEAEU=
=K51i
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
