Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:43163 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZDOBwD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 21:52:03 -0400
Date: Tue, 14 Apr 2009 21:51:16 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Greg KH <greg@kroah.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090415015116.GJ20470@storm.local.network> (sfid-20090415_035209_295453_65F7243E)
References: <20090414105200.GE25746@storm.local.network> <1239707258.4778.3.camel@johannes.local> <20090414113928.GA20470@storm.local.network> <1239709727.4778.6.camel@johannes.local> <1239712106.11795.21.camel@violet> <1239713034.17109.10.camel@johannes.local> <20090414130248.GA3291@tuxdriver.com> <20090414141852.GB20470@storm.local.network> <20090415011020.GC10045@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WWBpDPuG52WufD7Q"
In-Reply-To: <20090415011020.GC10045@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--WWBpDPuG52WufD7Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 14, 2009 at 06:10:20PM -0700, Greg KH wrote:
> On Tue, Apr 14, 2009 at 10:19:06AM -0400, Forest Bond wrote:
> > Hi,
> >=20
> > On Tue, Apr 14, 2009 at 09:02:48AM -0400, John W. Linville wrote:
> > > On Tue, Apr 14, 2009 at 02:43:54PM +0200, Johannes Berg wrote:
> > > > Hi Marcel,
> > > >=20
> > > > > just to document the irony here. Two or three years ago at OLS, K=
yle and
> > > > > Greg were making fun of Ubuntu merging its 5th wireless stack int=
o their
> > > > > kernel. Now the staging crap is doing exactly the same.
>=20
> Yes we are.  But we are doing it correctly :)
>=20
> Turns out that people actually want to use their hardware, and no one
> else was working on merging these drivers, so that is what staging is
> for.
>=20
> > Well, gosh, I understand the criticism here and if I were a kernel deve=
loper I
> > imagine my perspective would be much the same.  But I can't help but fe=
el that
> > there's some amount of hypocrisy when we hammer on a manufacturer to pr=
operly
> > license their driver and then let it drop dead when they do.
>=20
> I agree.
>=20
> > I understand that the problem would be solved if they manufacturers wou=
ld
> > suddenly "get it," but the scale of social problem preventing that is l=
ikely too
> > large to change anytime soon.
>=20
> Agreed.
>=20
> > If kernel developers are too busy to support the hardware, why do the
> > manufacturers take so much criticism for releasing binary-only drivers =
or badly
> > licensed drivers, or for neglecting to release technical specifications=
?  If
> > what I'm sensing is correct and there's no practical likelihood of thes=
e devices
> > getting in-kernel support even with those issues resolved, the criticis=
m almost
> > seems unjustified.
> >=20
> > I appreciate what the kernel developers do, of course, and my intention=
 is not
> > to ruffle feathers.  But when a manufacturer that has taken a lot of cr=
iticism
> > for its approach to the Linux community shows some good will, it seems =
like we
> > ought to be able to turn that into something productive.  If we can't, =
what have
> > we been complaining about?
> >=20
> > My apologies if I'm way off on this.  I haven't been around all that lo=
ng so it
> > is certainly possible.
>=20
> You aren't way off at all.
>=20
> Thanks for the patches, I'll get to them in a few days when my "real
> job" calms down a bit.  They're now in my queue, and will not get lost.

Thanks, Greg.  Your reputation is well-deserved, to say the least.

I need to get you some new patches, anyway, as the upstream sources depend =
on
header files that I failed to provide as they sit in a separate includes
directory.  I'll get this sent as soon as time permits (probably today or
tomorrow).

-Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--WWBpDPuG52WufD7Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ5T2URO4fQQdv5AwRAnmCAKCDLBSahsKETPAweDgrxEkZqb8ucACgr+k0
iEeGK0smZOKWGO4pWjOwvnc=
=NkaE
-----END PGP SIGNATURE-----

--WWBpDPuG52WufD7Q--
