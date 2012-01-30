Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:37781 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2A3Jyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 04:54:38 -0500
Date: Mon, 30 Jan 2012 10:53:50 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw: add support for NL80211_CMD_SET_STATION event
Message-ID: <20120130095348.GC6744@ritirata.org> (sfid-20120130_105442_319249_8DEFBA64)
References: <1327848635-28174-1-git-send-email-ordex@autistici.org>
 <1327885442.4225.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
In-Reply-To: <1327885442.4225.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 29, 2012 at 05:04:02PM -0800, Johannes Berg wrote:
> On Sun, 2012-01-29 at 15:50 +0100, Antonio Quartulli wrote:
> > This patch makes iw print an appropriate message in case of
> > NL80211_CMD_SET_STATION event. Involved flag with their values are prin=
ted too.
>=20
> How can you even generate this message?

no way to generate such message. I thought that sending a SET_STATION from =
us to
ks would generate such event, but that's false. I realised it too late.



Please drop this patch.

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQEcBAEBAgAGBQJPJmisAAoJEFMQTLzJFOZFSK0IAIk2cBqbjRejnbjjZf81E+Ri
qbAhUTXDdm0xlWjL2iCqs2Lg6LwGbFbC4Qas0wxBV7/5DNInTZQDCjIvF5LxlAVI
MGT4nOoo4asGapfoCJOnn0//3fsV6xmbXNV8jMHw5ZjfosY76rQ5b+g5B7oDkzgT
afUSSvH0xQtIGxrSx5pX/v52nYdiEMSWQzTdiA5Fa9XsPhvSaIejbJXOyW7FSnGN
vAFkF/e2NNmWr30gt9UIOPYV3g3ip2jj/6SqM3sA3YOUtGy4NOL2Li5PwUHtGMkT
DjQ7Izn+XXtU8eImlm8FngKehnfFwpu0vOEL56Qyw7rnoCp/ESIpUYEnzx1hfxM=
=7W6S
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--
