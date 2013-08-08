Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:27953 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966687Ab3HHXXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 19:23:18 -0400
Date: Fri, 9 Aug 2013 01:23:08 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [PATCH] cfg/nl80211: send CMD_INTERFACE event on
 NETDEV_UNREGISTER
Message-ID: <20130808232308.GQ2943@ritirata.org> (sfid-20130809_012325_488839_CB524AF5)
References: <1376003573-1243-1-git-send-email-ordex@autistici.org>
 <CAGRGNgV0n-nE9UFUiNyYqvgKNzrOE9zMuiRwxJvE5PZ1f6-EFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="EdRE1UL8d3mMOE6m"
In-Reply-To: <CAGRGNgV0n-nE9UFUiNyYqvgKNzrOE9zMuiRwxJvE5PZ1f6-EFA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--EdRE1UL8d3mMOE6m
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Julian,

On Fri, Aug 09, 2013 at 09:18:07AM +1000, Julian Calaby wrote:
> Hi Antonio,
>=20
> On Fri, Aug 9, 2013 at 9:12 AM, Antonio Quartulli <ordex@autistici.org> w=
rote:
> > From: Antonio Quartulli <antonio@open-mesh.com>
> >
> > Userspace applications may be listening for events (e.g.
> > matching mgmt frame) on a given interface. If such interface
> > is deleted they would keep hanging because no event will be
> > delivered anymore.
> >
> > Send a CMD_INTERFACE event on NETDEV_UNREGISTER to notify
> > userspace that the interface does not exist anymore.
> >
> > Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> > ---
> >  net/wireless/Module.symvers | 118 ++++++++++++++++++++++++++++++++++++=
++++++++
>=20
> I'm pretty sure you didn't mean to include this file =3D)

I think you are right :-)

I'll send v2.
Thanks,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--EdRE1UL8d3mMOE6m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSBChcAAoJEADl0hg6qKeO7SYP/Al5SYhiJoNu80XcgcYgAXpC
/lzEuYO97ki5z8J7Z2WssYZx9dPl4kLMgJIsSU53OUtRgbhqbZrtYX3Y5wiAswz5
2vIAiDffIsv5smdPIc8XWuxUkJ9kFEjUKfOgKjtWZeKZ4m/3L1+cvWOKt84JnVyS
e7Bz2Ie36D32fMaDDlkPt17N58NFtFisAsS554SstM7nzYaWh+ry/0PMtuBAh1in
5o3p/maVyKuhzP0+ho9fk4P1ZTrJGMBvWqflgC+Q9UgY/WS5u82w9Y7t7ekVT8uf
ykwEjlYzDhHFcL9214iQrwCmUDw07PgEacfY53z1NP9BfLhIeQ6XKnCxCp83PQCb
6X2JeAA9ZyM462MxAzIkkNu9ZbTzUR1JRpaPf/+PilYVh1CD8TZYGdqMm6zi0kPS
OgVq0r701dvl2TV0P5/TsDaezkVfu3I/++2LE+bW/yjsmv6eUgmGNgUjC9CexOQF
B401WPKQFtkB5Zd4kAvXvJAJoDiQPtIklC7e43WdKVcXKiDpoSfGMWWad1B8WRZU
oohxnJIcv97N0DnDKFERz1ZnbafZvcdWE4o5msGgNKMYasRpNtF3iXZFh+WelXAM
EhC7OPoDlCbG50xEsNKxXtBvl91PlzF76J0sr+LMKoS7SY3SkoEQhLD1mJmH3hbw
wKcyL/QxU5gKTGCcieyP
=Jcum
-----END PGP SIGNATURE-----

--EdRE1UL8d3mMOE6m--
