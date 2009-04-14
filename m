Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:60828 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbZDNLpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 07:45:22 -0400
Date: Tue, 14 Apr 2009 07:39:28 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg KH <greg@kroah.com>, Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090414113928.GA20470@storm.local.network> (sfid-20090414_134527_843729_3D8CFF17)
References: <20090414105200.GE25746@storm.local.network> <1239707258.4778.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
In-Reply-To: <1239707258.4778.3.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 14, 2009 at 01:07:38PM +0200, Johannes Berg wrote:
> On Tue, 2009-04-14 at 06:52 -0400, Forest Bond wrote:
> > This patch adds the vt6656 driver to drivers/staging.  This code was li=
terally
> > copied from the upstream source archive, available here:
> >=20
> >   http://www.viaarena.com/Driver/VT6656_Linux_src_v1.19_12_x86.zip
> >=20
> > Copyright: VIA Networking Technologies, Inc.
> > License: GPL
> > Authors: Jerry Chen, Kyle Hsu, Lucas Lin, Lyndon Chen, Tevin Chen, Warr=
en Hsu,
> >          Yiching Chen
> > Signed-off-by: Forest Bond <forest@alittletooquiet.net>
> >=20
> > Patch: http://www.alittletooquiet.net/media/code/0002-Add-vt6656-driver=
-to-drivers-staging.patch.gz
> > Signature: http://www.alittletooquiet.net/media/code/0002-Add-vt6656-dr=
iver-to-drivers-staging.patch.gz.sig
>=20
> Can we also please add files here saying to not bother the
> linux-wireless list about this crap?

I would assume this is somewhat implied for any code in drivers/staging.  Is
that not the case?

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ5HXwRO4fQQdv5AwRAvnjAKC3aE06AH0gt1/z/jFH1pFAEp7b2wCePoUb
AwWxjl7mEXcmVImzJCfukuY=
=X6k8
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
