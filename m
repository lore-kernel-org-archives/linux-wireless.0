Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:52261 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3HLJMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 05:12:05 -0400
Date: Mon, 12 Aug 2013 11:11:58 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: "Volker von Hoesslin @ SKBX Systems" <hoesslin.v@skbx.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 80211s with DFS
Message-ID: <20130812091158.GA17024@pandem0nium> (sfid-20130812_111209_553595_87689FFE)
References: <5207FC2A.4040207@skbx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
In-Reply-To: <5207FC2A.4040207@skbx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 11, 2013 at 11:03:38PM +0200, Volker von Hoesslin @ SKBX System=
s wrote:
> i think this error is from the "netlink lib(libnl genl)"...
>=20
> if i use a channel without DFS, it works fine (in germany channel
> like 36-48)... so how it is possible to use mesh (80211s) with DFS ?

mac80211 does not support DFS in mesh mode so far, the only DFS
support implemented is AP mode (and only with ath9k compatible chips).
I'm currently working on IBSS, I don't if/who will work on
802.11s DFS ...

Cheers,
	Simon

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlIIpt4ACgkQrzg/fFk7axZVawCgtlqwNb2yexFkBAYz1V3bGOvX
v1IAoKF0LUJQMVlpTIaM97KzJA5XkmmH
=hSqx
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
