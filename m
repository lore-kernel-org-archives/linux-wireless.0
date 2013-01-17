Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:46650 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3AQNxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 08:53:22 -0500
Date: Thu, 17 Jan 2013 14:53:12 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv6 5/6] mac80211: check radar interaction with scan and
 roc
Message-ID: <20130117135312.GE19552@pandem0nium> (sfid-20130117_145332_500402_4226A3EB)
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1357650251-17425-6-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1358377227.15012.46.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7LkOrbQMr4cezO2T"
In-Reply-To: <1358377227.15012.46.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--7LkOrbQMr4cezO2T
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 12:00:27AM +0100, Johannes Berg wrote:
> On Tue, 2013-01-08 at 14:04 +0100, Simon Wunderlich wrote:
> > Scanning and remain on channel functionality must be disabled while
> > doing radar detection/scanning, and vice versa.
>=20
> This really belongs into the previous patch, I think?

OK, I can squash it.

Cheers,
	Simon

--7LkOrbQMr4cezO2T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlD4AkgACgkQrzg/fFk7axaiwQCgtUdx7FMzYNyBmTkIUoFxRpNR
5CwAoIjwQ9wVj+TbHYhotzHu8Y+LqQCo
=rqTR
-----END PGP SIGNATURE-----

--7LkOrbQMr4cezO2T--
