Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:43152 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202AbYHZTZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 15:25:04 -0400
Date: Tue, 26 Aug 2008 15:27:31 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: drago01 <drago01@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Are these Ralink chips supported?
Message-ID: <20080826192731.GC26037@storm.local.network> (sfid-20080826_212508_844290_9BEF3D31)
References: <20080805163234.GA22429@storm.local.network> <200808061014.10483.IvDoorn@gmail.com> <20080826191654.GB26037@storm.local.network> <f6ca9fed0808261218w20334033h7eef71dba8400ac8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
In-Reply-To: <f6ca9fed0808261218w20334033h7eef71dba8400ac8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 26, 2008 at 09:18:59PM +0200, drago01 wrote:
> On Tue, Aug 26, 2008 at 9:16 PM, Forest Bond <forest@alittletooquiet.net>=
 wrote:
> > On Wed, Aug 06, 2008 at 10:14:10AM +0200, Ivo van Doorn wrote:
> >> On Tuesday 05 August 2008, Forest Bond wrote:
> >> > I'm having a hard time figuring out if the following wireless chips =
are
> >> > supported:
> >> >
> >> >  * RT2770 + RT2720
> >>
> >> I *think* this is the rt2870 driver. The in-kernel driver is under dev=
elopment
> >
> > Okay, the RT2870 driver from Ralink works with this device, but it seem=
s to be a
> > bit quirky:
> >
> >  * The device has to be brought up and down a few times before NetworkM=
anager
> >   sees it.  I'm not sure what NetworkManager is cueing off of.
> >
> >  * I was unable to get the thing to associate and come up using
> >   iwconfig/ifconfig.  Might have been my range on that AP, though, sinc=
e I was
> >   shooting for an unencrypted network that is a not the closest network=
 in my
> >   building.
> >
> >  * Usual odd bits with vendor drivers like odd build system subtleties =
and
> >   seemingly unnecessary configuration files (does anyone really care to=
 fiddle
> >   with those, or doesn't everyone just want things to work with the sta=
ndard
> >   configuration mechanisms like I do?).
> >
> > Is there an effort to move this driver in-tree?  The license is GPL.
>=20
> Thats what Ivo is doing, port the driver to rt2x00 to make it
> acceptable for merging.

Okay, sorry if I misunderstood.  Is this driver usable and, if so, where ca=
n the
code be found?

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFItFkjRO4fQQdv5AwRAkMZAJ9YsWP8O/NqjvyjazcbJ5lKB/IBBgCeOL1Y
Ei54iG1Nie+mrOWNPpchV/w=
=Jxca
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
