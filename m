Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56955 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbZDSTlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 15:41:14 -0400
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1240169475.11795.79.camel@violet> (sfid-20090419_213129_385614_54F04B3D)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240097845.25826.1.camel@johannes.local>
	 <20090419125212.158800@gmx.net>
	 (sfid-20090419_145246_566920_BF082D12) <1240147050.25826.5.camel@johannes.local>
	 <20090419133544.158820@gmx.net>
	 (sfid-20090419_153615_967882_D1A9F951) <1240148519.898.3.camel@johannes.local>
	 <20090419140523.158830@gmx.net>
	 (sfid-20090419_160555_446977_A429511B) <1240150277.898.7.camel@johannes.local>
	 <20090419151629.158790@gmx.net>
	 (sfid-20090419_171702_263242_9A8C16F9) <1240154704.898.18.camel@johannes.local>
	 <20090419155319.158810@gmx.net>
	 (sfid-20090419_175352_161479_A88396A3) <1240156631.917.1.camel@johannes.local>
	 <20090419161316.158790@gmx.net>
	 (sfid-20090419_181324_681308_BAEAE072) <1240158381.917.21.camel@johannes.local>
	 <20090419165443.158820@gmx.net>
	 (sfid-20090419_185516_519795_36D34B9B) <1240160241.28138.4.camel@johannes.local>
	 <20090419173354.158790@gmx.net> <1240163391.11795.59.camel@violet>
	 <20090419180314.23710@gmx.net> <1240164895.11795.70.camel@violet>
	 <20090419184320.158810@gmx.net>  <1240169475.11795.79.camel@violet>
	 (sfid-20090419_213129_385614_54F04B3D)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-j0+FGcF5k0C8+CrSQhWc"
Date: Sun, 19 Apr 2009 21:40:53 +0200
Message-Id: <1240170053.28138.20.camel@johannes.local> (sfid-20090419_214128_459245_FF8B9664)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j0+FGcF5k0C8+CrSQhWc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 21:31 +0200, Marcel Holtmann wrote:
> Hi Alina,
>=20
> let me repeat what Johannes mentioned earlier, please don't send emails
> twice. Just use a proper working MUA and do Reply-All.
>=20
> > > and that is just plain wrong to begin with. If you want a one command=
 do
> > > everything, then do that in userspace and not inside a kernel API.
> >=20
> > Then why not implement deferent syscalls for floppy disks, hard disk
> drives, solid state disks and normal files? If you want one generic
> API than write an users-space library.
> >=20
> > Thought-out APIs sucks, MS-DOS rules!
>=20
> you are seriously comparing block devices to network device now? They
> are different, go figure. You better bring technical arguments that
> matter and not something far fetched from a total different technology.

Well you could make that comparison, if you do it correctly... I guess
the proposed mashed-up calls would be very much like configuring a
remote raid storage by writing to the block device it exports. Needless
(hopefully!!) to say, that is not a good idea.

johannes

--=-j0+FGcF5k0C8+CrSQhWc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ635CAAoJEKVg1VMiehFYhZUP/1cQBatjBW+1IArLQTkKn6Vo
CugaONXXapBPcV3eoxLT0mdFhZp0zkr7sbEEkWXxcwlHk8taND3iu3tJGsrs2QeM
7WkbaZ7mcogtGd8KX/CGwlZMIkuVi4kMGsnvXS2Db7iwKxmw/YntAuN75DEeTDiJ
QFi1aebony/AdDS3ac3q8WAEfVvPpHTjf7zZa62dwK4QbIwLcIJzkY94Yu54Z8Kn
G4+7htA0fIXF6NcYI3+TUbk1gMxhnpk+p3AA2ANWDMZkE/51W0sl0tzxVfLnq9tr
ffddZvBurY4RDVACLxrU6XG4o1V/z2tT435e70zrQBSDMzqnZ7Md/dotuRSCwE2b
rzorlCvJAd93vVFkBS1dGfzxlmJ0OTfpooxR4+GtvjibJOR0NXd8cAPo9Qdyd5aa
DLw0s3c5Dg8e0D/KOyMueGg0f8MNKxrEH1RIAKewzJWSwGccnBcpOw66zPAIPk2B
BhH7Sp+lVZqdjFaaTRD/U+2gfqhH2rAXkvtw+gNwND0qTqFH9OCWIpaGXMCo/vhq
XdkCfuiXF97ofOI8P1NOtlX3CGEUj5BSWEP2j2Mr8e3aE04jSUInHPI5Ej8M33nd
i4MC1awrzKqYbuRATaQbxzc6zKQfLcix8cm9m/oVQP4CFUkwj2MzC5/k77YzbfUi
WEeRF7SGJIHbdsB238Iw
=fnYB
-----END PGP SIGNATURE-----

--=-j0+FGcF5k0C8+CrSQhWc--

