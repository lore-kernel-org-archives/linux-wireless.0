Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:53095 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbZCSQsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 12:48:36 -0400
Date: Thu, 19 Mar 2009 12:48:02 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: VT6656 driver source now GPL
Message-ID: <20090319164802.GC25237@storm.local.network> (sfid-20090319_174839_276800_CF0F4D58)
References: <20090319164256.GA25237@storm.local.network> <43e72e890903190945m4d8920f5y69f5847b688b0aa1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="raC6veAxrt5nqIoY"
In-Reply-To: <43e72e890903190945m4d8920f5y69f5847b688b0aa1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--raC6veAxrt5nqIoY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2009 at 09:45:19AM -0700, Luis R. Rodriguez wrote:
> On Thu, Mar 19, 2009 at 9:42 AM, Forest Bond <forest@alittletooquiet.net>=
 wrote:
> > Hi,
> >
> > VIA has released a new version of the VT6656 driver source, and it now =
has a
> > proper license!
> >
> > =A0http://www.viaarena.com/Driver/VT6656_Linux_src_v1.19_12_x86.zip
> >
> > As you may recall, the previous version lacked a license altogether, ma=
king it
> > unfit for distribution.
> >
> > I'd really like to see this driver integrated into the kernel. =A0Does =
anyone care
> > to comment regarding feasibility?
>=20
> Indeed good news, what is the latest kernel it compiles for? If it
> compiles on Linus' tree it can be stashed into staging while it gets
> properly ported.

I've not compiled it myself, yet.

However, according to a report here, it compiles with Ubuntu 9.04 (2.6.28.1=
1):

  https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/162671

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--raC6veAxrt5nqIoY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJwndCRO4fQQdv5AwRArbcAJ0UIlChBV+jPKuvNIEDou7ecfjgqwCg0+/r
ToUhT+VxpVxlEnLP2l5j7jY=
=vK6A
-----END PGP SIGNATURE-----

--raC6veAxrt5nqIoY--
