Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34655 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbYKMTMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 14:12:22 -0500
Subject: Re: [FYI] ar9170 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: "otus-devel@lists.madwifi-project.org"
	<otus-devel@lists.madwifi-project.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1226537117.14186.44.camel@johannes.berg> (sfid-20081113_014611_302976_93001DBF)
References: <1226531034.14186.39.camel@johannes.berg>
	 (sfid-20081113_000444_962024_07ACD3CC)  <1226531788.14186.41.camel@johannes.berg>
	 (sfid-20081113_001659_069366_BA2AA5E2)  <1226537117.14186.44.camel@johannes.berg>
	 (sfid-20081113_014611_302976_93001DBF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RPp3mSyiCdYEKrcsaIRH"
Date: Thu, 13 Nov 2008 20:11:47 +0100
Message-Id: <1226603507.5839.15.camel@johannes.berg> (sfid-20081113_201226_314672_22FD0641)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RPp3mSyiCdYEKrcsaIRH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-13 at 01:45 +0100, Johannes Berg wrote:
> On Thu, 2008-11-13 at 00:16 +0100, Johannes Berg wrote:
> > On Thu, 2008-11-13 at 00:03 +0100, Johannes Berg wrote:
> >=20
> > >  * use rate hw_value instead of huge switch statement
> >=20
> > done,
> > http://johannes.sipsolutions.net/patches/kernel/all/LATEST/
> > (look for *-ar9170.patch)
>=20
> Better URL is
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-ar9170.pat=
ch
> because it automatically gives you the number.

Ok, I'm happy to say that thanks to Stephen and Yuan-Gu who helped me
get the Atheros driver working on big-endian and usbmon, the driver now
seems to be stable, I've sent this email with it over a wpa link.

johannes

--=-RPp3mSyiCdYEKrcsaIRH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJHHvvAAoJEKVg1VMiehFYqwsQAJe3LImYEqL/FdbowveN5W6L
y5GIt7BAyyP0LPI+bNaBJuA1KQvpIoDSZEeIVYD6+1vzukftwH9EghQ3xEGYWmY2
EL7OOSId+esexHOrpzrBPc5v0LskenpGvky1/WM2QOX3ntY5cP+VPiodLKjZ8AHW
xkNNAxEsXy+wzSCR++F+B/BnCBw74ISj7UWVC6stTZsVRmYv7o5rwxSWApazZc27
1mJF+0GgKPVhgTgDuEM+koagWZ8+vtT5wD/H7lezTMGfOVeAvZQEatQCBv9xtl8p
dhpOfcjIt5IA4Cm5VA0+wS3bmKbcul1k9FwK9/2ond7RfM5SBKTwwddy4ZZL3G9t
R+2unr1iNxsAISGYwEUC3kAXe+34RMg+8lZ2yaZBh3oyJ4tzzRuu9dMefL0GoTNt
6XTOsC4fbWA+Vs+0pammV5AtJFVh6eeGm96c3trvzjX4rIFSAHTlfS8TiB2ceyEp
0bRYOnfz5+yowcxNEXQ927vYW8lNzkUrzzdwyFsk3WWRPH6Ua66wErJPZ7zdpWM0
6pWIuxXjJDBAex/hDoIvVhUke7BqVk3XV+J6SXxvduqSEXgUEMw8UahQfadQhjoi
utZj/C300O97VXqzs8Cd6vSDedpSylR2ogGjNxoCjoVyxxhFEq8T2IF89dS3VAUk
mK4Rz2E0Yzw3iVN1pf27
=HSo2
-----END PGP SIGNATURE-----

--=-RPp3mSyiCdYEKrcsaIRH--

