Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:46953 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbZFAQwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 12:52:43 -0400
Date: Mon, 1 Jun 2009 12:52:07 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Greg KH <greg@kroah.com>, Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090601165207.GA12481@alittletooquiet.net>
References: <20090414105200.GE25746@storm.local.network> <69e28c910906010935n28f69921xd589a945e982ca1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
In-Reply-To: <69e28c910906010935n28f69921xd589a945e982ca1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 01, 2009 at 06:35:35PM +0200, G=E1bor Stefanik wrote:
> On Tue, Apr 14, 2009 at 12:52 PM, Forest Bond
> <forest@alittletooquiet.net> wrote:
> > This patch adds the vt6656 driver to drivers/staging. =A0This code was =
literally
> > copied from the upstream source archive, available here:
> >
> > =A0http://www.viaarena.com/Driver/VT6656_Linux_src_v1.19_12_x86.zip
> >
> > Copyright: VIA Networking Technologies, Inc.
> > License: GPL
> > Authors: Jerry Chen, Kyle Hsu, Lucas Lin, Lyndon Chen, Tevin Chen, Warr=
en Hsu,
> > =A0 =A0 =A0 =A0 Yiching Chen
> > Signed-off-by: Forest Bond <forest@alittletooquiet.net>
> >
> > Patch: http://www.alittletooquiet.net/media/code/0002-Add-vt6656-driver=
-to-drivers-staging.patch.gz
> > Signature: http://www.alittletooquiet.net/media/code/0002-Add-vt6656-dr=
iver-to-drivers-staging.patch.gz.sig
>=20
> Did this patch (along with the vt6655 one) somehow get lost? I can't
> see it in drivers/staging.

vt6655 is in drivers/staging on linux-next, although I have three more patc=
hes
that I'll be sending to Greg sometime tonight.  He has been applying them f=
or
me.

vt6656 is currently delayed a bit.  I may be able to get a start on that
tonight, as well, but there is likelihood of further delay.

Hope this is helpful.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKJAc3RO4fQQdv5AwRAhgOAKCTjzOQYuTaAK4ALhht0sMx21C9OgCgvwLe
qHO82H6Vyir/vY7MIyJDy9A=
=Cs9N
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
