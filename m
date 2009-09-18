Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60979 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbZIRAOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 20:14:23 -0400
Subject: Re: regression?  No connection with master-2009-09-16 was fine
 until master-2009-09-14
From: Johannes Berg <johannes@sipsolutions.net>
To: ASIC Felix <ic.felix@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1253232542.23567.3.camel@johannes.local>
References: <1253208348.6601.17.camel@darkslate>
	 <1253230530.23567.1.camel@johannes.local>
	 <1253232319.6914.15.camel@darkslate>
	 <1253232542.23567.3.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iDOeHmEVBm/d6h4Uj1Or"
Date: Thu, 17 Sep 2009 17:13:56 -0700
Message-Id: <1253232836.23567.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iDOeHmEVBm/d6h4Uj1Or
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-17 at 17:09 -0700, Johannes Berg wrote:
> On Thu, 2009-09-17 at 17:05 -0700, ASIC Felix wrote:
>=20
> > > and then describe your setup ... the patch works fine here and Holger
> > > said it fixed his problem. hidden ssid by any chance?
> >=20
> > Office network, can see about 50 APs, more 2G than 5G.
> >=20
> > Main office ssid is available on most 2G channels 11g (no 11n), also on
> > several 5G channels 11a (no 11n). Lots of other ssids are visible.
> > WPA2/PSK.
>=20
> I think wpa is the problem, seeing something like that here too, very
> odd that it could connect otherwise tho.

yeah I've got it.

johannes

--=-iDOeHmEVBm/d6h4Uj1Or
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKstDAAAoJEODzc/N7+QmazIMQAJlqVUKG4GUfK4z/evzGZFA9
XYfcGNkb86pq3y7mQ/c24wZ5/fa/SQnQvFtFdzqZq3ZaHS2/5Zd198s6gC874WQK
yG+MMceTt8bzYm2ZGbcGHVBjoFsGq/tnwyKs2USE3+FRf1w2cNGRKRCHjYRb64IA
5+BMzqH/JXJD6pBEYmiDpdpAK/W22Yqee21dm1RMHR4V647XQNIuBNoh0KCD/6TM
NZb9/Ja2wDTcclL9Z88/E3mbmI/REPZ2Xo3SpxYRAvyDsm7sN6wAhU/DAowD7xLB
/w4GA+O09heWosDYWaxOh4WmegLeMYJCRLC1Z1vuuYjcDm+f677bd4SPgggzHGw+
gJQYwG1Hrrs2lxWc14VwoBko3/W69O2c2n1wQayLbUg0v3fkWR6+yJVMMat5uF56
ParxEl+T/6BU4wv6v6pWzP6Z+atDS7mN5e/3xuvgpHEgN4uok67C0S8Rriux3rba
aUQRahTkwPPjsaMT8ueT30Xs34K08KY1/gFYtBEWtzF70XNUrrZtacUwqL+jXmGd
M33jQFiQ3eKsu0pC0BLYfX2YDO2ER6Gga0x95cEsdCX4Vg2J4Bjc8Qlx6YnXgVCO
PuOOy8CoWCDQP4YWvBM/fzvJX0HkXPI058bnimkp72IJh8cctYE+DsB2vnuBWRUb
4rUXVmRg4/2W+ivs12mM
=V5W5
-----END PGP SIGNATURE-----

--=-iDOeHmEVBm/d6h4Uj1Or--

