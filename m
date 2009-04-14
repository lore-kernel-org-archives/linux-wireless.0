Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:60294 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZDNAJb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 20:09:31 -0400
Date: Mon, 13 Apr 2009 20:08:35 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: VT6656 driver source now GPL
Message-ID: <20090414000835.GA31504@storm.local.network> (sfid-20090414_020934_042738_3843CC4F)
References: <20090319164256.GA25237@storm.local.network> <43e72e890903190945m4d8920f5y69f5847b688b0aa1@mail.gmail.com> <20090320131014.GG25237@storm.local.network>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
In-Reply-To: <20090320131014.GG25237@storm.local.network>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 20, 2009 at 09:10:15AM -0400, Forest Bond wrote:
> On Thu, Mar 19, 2009 at 09:45:19AM -0700, Luis R. Rodriguez wrote:
> > On Thu, Mar 19, 2009 at 9:42 AM, Forest Bond <forest@alittletooquiet.ne=
t> wrote:
> > > Hi,
> > >
> > > VIA has released a new version of the VT6656 driver source, and it no=
w has a
> > > proper license!
> > >
> > > =A0http://www.viaarena.com/Driver/VT6656_Linux_src_v1.19_12_x86.zip
> > >
> > > As you may recall, the previous version lacked a license altogether, =
making it
> > > unfit for distribution.
> > >
> > > I'd really like to see this driver integrated into the kernel. =A0Doe=
s anyone care
> > > to comment regarding feasibility?
> >=20
> > Indeed good news, what is the latest kernel it compiles for? If it
> > compiles on Linus' tree it can be stashed into staging while it gets
> > properly ported.
>=20
> Just so I know who to pester*, will you be driving this?  Do you have int=
erest
> in also pulling in the VT6655 driver?
>=20
> * I won't pester that much. ;)

I'm getting the sense that there is not a lot of developer interest in these
drivers.  Is there anything I can do to aid in getting these drivers into t=
he
kernel?

I would be willing to send patches, however, my experience with kernel hack=
ing
is limited and I don't have a lot of time available to contribute.  With a
little direction, though, I might be able to get somewhere.

Any input would be appreciated.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ49QDRO4fQQdv5AwRAuAyAKCpmupc7LhrdQRwvvj014x0gpod0gCeOrsQ
bGUsNrBqIsdaq+nPwLaBl40=
=CewC
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
