Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:40857 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbYHZTOZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 15:14:25 -0400
Date: Tue, 26 Aug 2008 15:16:54 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Are these Ralink chips supported?
Message-ID: <20080826191654.GB26037@storm.local.network> (sfid-20080826_211429_492411_30A7F8BA)
References: <20080805163234.GA22429@storm.local.network> <200808061014.10483.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
In-Reply-To: <200808061014.10483.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 06, 2008 at 10:14:10AM +0200, Ivo van Doorn wrote:
> On Tuesday 05 August 2008, Forest Bond wrote:
> > I'm having a hard time figuring out if the following wireless chips are
> > supported:
> >=20
> >  * RT2770 + RT2720
>=20
> I *think* this is the rt2870 driver. The in-kernel driver is under develo=
pment

Okay, the RT2870 driver from Ralink works with this device, but it seems to=
 be a
bit quirky:

 * The device has to be brought up and down a few times before NetworkManag=
er
   sees it.  I'm not sure what NetworkManager is cueing off of.

 * I was unable to get the thing to associate and come up using
   iwconfig/ifconfig.  Might have been my range on that AP, though, since I=
 was
   shooting for an unencrypted network that is a not the closest network in=
 my
   building.

 * Usual odd bits with vendor drivers like odd build system subtleties and
   seemingly unnecessary configuration files (does anyone really care to fi=
ddle
   with those, or doesn't everyone just want things to work with the standa=
rd
   configuration mechanisms like I do?).

Is there an effort to move this driver in-tree?  The license is GPL.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFItFamRO4fQQdv5AwRAoq0AKCqUhaNvqbB+AJji6GvJmuoexTpPgCeNozr
2i86HhfaPx9THu7WNE0h1lc=
=rgwq
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
