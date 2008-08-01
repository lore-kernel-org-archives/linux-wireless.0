Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37564 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbYHAJnm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 05:43:42 -0400
Subject: Re: 2.6.27-rc1-next-20080731 assoc problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Jasper Bryant-Greene <jasper@amiton.co.nz>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1217558895.3103.10.camel@luna.unix.geek.nz> (sfid-20080801_045427_652694_B19B078D)
References: <1217558895.3103.10.camel@luna.unix.geek.nz>
	 (sfid-20080801_045427_652694_B19B078D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/1UaOK9YOAel7lA2KUeh"
Date: Fri, 01 Aug 2008 11:43:31 +0200
Message-Id: <1217583811.8621.0.camel@johannes.berg> (sfid-20080801_114346_689518_342C9D16)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/1UaOK9YOAel7lA2KUeh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-08-01 at 14:48 +1200, Jasper Bryant-Greene wrote:
> iwl4965, Netgear WNR854T 802.11n AP
>=20
> I seem to be getting these problems from time to time since moving from
> 2.6.26 to 2.6.27-rc1-next-20080731:

> [  457.511978] wlan0: AP denied association (code=3D1)

> Is it really my AP, as the messages suggest?

Yes, and it doesn't even tell you why, 1 is WLAN_REASON_UNSPECIFIED

johannes

--=-/1UaOK9YOAel7lA2KUeh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIktq/AAoJEKVg1VMiehFYfC0QAJl6YuOD7w/MXrO6QSdBXUT/
pOH73TVQB0/mgqMXBplDEeKFziCCDwUuDuUGiMQnswsGVd2pTwbCPPW+XjU1zRRY
znfhahBCno7BXf5gGYnjcUxb7fkORhwkJYDa75MwRX2hm1bMh5oiqxvFpEPvED8s
UBlIQbdo0v1P2xnMTEl5DX4efkHSM75Um8JNpm26cbOKDmBJXknl9N6v6/9mK+oM
Xj1ToUJw0q249oPsFjEyDV+VEVTSdPmpIrevMnsZvvDu+waI/OeXWUuwWjl4IpLn
RpqVwOa1YqJ4btufEfcYIJ7saIImRbQT6vg7xlN8uW51d/b5hbx7QFTGH51H84wP
qNp79FNCrLTTxu7Hbb96hbVZCFtF11KAylGhuJwe2AkTeffK6tmvVNrpzZkZ/6OB
5Yx9mQdfTPX/1tPkrWqQsHdjBLgG35zlQRNp1BzsqfJDz2wEJ2jG5OIWl9BxxUvO
/1eYB27iH3+ELrxv7zBfk6GSbMO7ry/paGA5dM9VOigzAifb02TvqotloRvAvoM/
3a9dGW4HD1ZKy7FwUyhUC6j7hnN8feMW3sdTDKavnJ8NM3y65jWKKjT6v0qFoHU/
TtbexHvdJtj4GtOrqiq/xRZvN24ow7WD6bGNVjwnSUiSr3mezNNW1pxYWRFKSN+x
/70hdpQ2os9lL1NTLvK5
=zpG0
-----END PGP SIGNATURE-----

--=-/1UaOK9YOAel7lA2KUeh--

