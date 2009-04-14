Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:34787 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZDNAXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 20:23:18 -0400
Date: Mon, 13 Apr 2009 20:22:46 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	Greg KH <greg@kroah.com>
Subject: Re: VT6656 driver source now GPL
Message-ID: <20090414002246.GB31504@storm.local.network> (sfid-20090414_022321_931768_1F7BEED9)
References: <20090319164256.GA25237@storm.local.network> <43e72e890903190945m4d8920f5y69f5847b688b0aa1@mail.gmail.com> <20090320131014.GG25237@storm.local.network> <20090414000835.GA31504@storm.local.network> <43e72e890904131712y55ba7f16sa8cb568128afeaeb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
In-Reply-To: <43e72e890904131712y55ba7f16sa8cb568128afeaeb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 13, 2009 at 05:12:02PM -0700, Luis R. Rodriguez wrote:
> On Mon, Apr 13, 2009 at 5:08 PM, Forest Bond <forest@alittletooquiet.net>=
 wrote:
> > Hi,
> >
> > On Fri, Mar 20, 2009 at 09:10:15AM -0400, Forest Bond wrote:
> >> On Thu, Mar 19, 2009 at 09:45:19AM -0700, Luis R. Rodriguez wrote:
> >> > On Thu, Mar 19, 2009 at 9:42 AM, Forest Bond <forest@alittletooquiet=
=2Enet> wrote:
> >> > > Hi,
> >> > >
> >> > > VIA has released a new version of the VT6656 driver source, and it=
 now has a
> >> > > proper license!
> >> > >
> >> > > =A0http://www.viaarena.com/Driver/VT6656_Linux_src_v1.19_12_x86.zip
> >> > >
> >> > > As you may recall, the previous version lacked a license altogethe=
r, making it
> >> > > unfit for distribution.
> >> > >
> >> > > I'd really like to see this driver integrated into the kernel. =A0=
Does anyone care
> >> > > to comment regarding feasibility?
> >> >
> >> > Indeed good news, what is the latest kernel it compiles for? If it
> >> > compiles on Linus' tree it can be stashed into staging while it gets
> >> > properly ported.
> >>
> >> Just so I know who to pester*, will you be driving this? =A0Do you hav=
e interest
> >> in also pulling in the VT6655 driver?
> >>
> >> * I won't pester that much. ;)
> >
> > I'm getting the sense that there is not a lot of developer interest in =
these
> > drivers. =A0Is there anything I can do to aid in getting these drivers =
into the
> > kernel?
> >
> > I would be willing to send patches, however, my experience with kernel =
hacking
> > is limited and I don't have a lot of time available to contribute. =A0W=
ith a
> > little direction, though, I might be able to get somewhere.
> >
> > Any input would be appreciated.
> >
>=20
> Best thing is to stash them into staging and hope someone will be
> interested in porting it.

Would it be helpful if I sent patches that do nothing more than add the sou=
rce
files as they exist currently to staging, or is there more that needs to ha=
ppen
for the source files to be appropriate for inclusion there?

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ49dWRO4fQQdv5AwRAjgAAJ9VwXRSd5OMi62K9rXhREz5bARE0wCcCFhc
4MtQPX6BHfbB3e2lLD1FVVA=
=Kx5u
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
