Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:51706 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab3AQN2y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 08:28:54 -0500
Date: Thu, 17 Jan 2013 14:28:43 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv6 2/6] cfg80211: check radar interface combinations
Message-ID: <20130117132843.GB19552@pandem0nium> (sfid-20130117_142903_019265_3B2FC637)
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1357650251-17425-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1358376177.15012.31.camel@jlt4.sipsolutions.net>
 <1358376287.15012.32.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
In-Reply-To: <1358376287.15012.32.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 16, 2013 at 11:44:47PM +0100, Johannes Berg wrote:
> On Wed, 2013-01-16 at 23:42 +0100, Johannes Berg wrote:
> > On Tue, 2013-01-08 at 14:04 +0100, Simon Wunderlich wrote:
> > > To ease further DFS development regarding interface combinations, use
> > > the interface combinations structure to test for radar capabilities.
> > > Drivers can specify which channel widths they support, and in which
> > > modes. Drivers should first allow AP mode only, but can later allow
> > > MultiSSID APs, AP+Ad-Hoc, etc.
> >=20
> > Applied.
>=20
> Btw, an iw patch would be nice.

OK, will put that on my TODO.

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlD3/IsACgkQrzg/fFk7axZvpwCg47gaDz7U6mOMdUZSTXxE5yQO
q/oAoLLac5uqSQv3ar/DPd/3xYW4AJgv
=/coX
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
