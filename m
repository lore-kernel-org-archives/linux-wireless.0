Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:44118 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab2K3XzI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 18:55:08 -0500
Date: Sat, 1 Dec 2012 00:55:02 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] mac80211: fix redundant if in transmit path
Message-ID: <20121130235502.GA24041@pandem0nium> (sfid-20121201_005512_265647_65902C94)
References: <1354303514-20255-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1354309913.24302.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
In-Reply-To: <1354309913.24302.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 30, 2012 at 10:11:53PM +0100, Johannes Berg wrote:
> On Fri, 2012-11-30 at 20:25 +0100, Simon Wunderlich wrote:
> > This is already in the right switch branch, no need to check again and
> > provoke a compiler warning about chanctx_conf might be used
> > uninitialized.
>=20
> Nope, look again.

Whoops, you've got me, sorry about that. (still, this compiler warning is a=
nnoying)

Cheers,
	Simon


--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlC5R1YACgkQrzg/fFk7axZ38QCgvytRTU0liqcPce6fOTX/IYG4
I+UAn0fViLoO1QWY9SOJVgfridg0DoSz
=ZMzl
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
