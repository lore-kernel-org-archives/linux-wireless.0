Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:43322 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3BGLKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 06:10:17 -0500
Date: Thu, 7 Feb 2013 12:10:09 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv8 2/3] mac80211: add radar detection command/event
Message-ID: <20130207111009.GC26957@pandem0nium> (sfid-20130207_121022_117134_FA33380C)
References: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359982200-2321-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1360172173.7910.54.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8NvZYKFJsRX2Djef"
In-Reply-To: <1360172173.7910.54.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--8NvZYKFJsRX2Djef
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 06, 2013 at 06:36:13PM +0100, Johannes Berg wrote:
> On Mon, 2013-02-04 at 13:49 +0100, Simon Wunderlich wrote:
>=20
> > +++ b/net/mac80211/cfg.c
>=20
> > @@ -1796,6 +1797,7 @@ static int ieee80211_join_mesh(struct wiphy *wiph=
y, struct net_device *dev,
> >  	/* can mesh use other SMPS modes? */
> >  	sdata->smps_mode =3D IEEE80211_SMPS_OFF;
> >  	sdata->needed_rx_chains =3D sdata->local->rx_chains;
> > +	sdata->radar_required =3D true;
>=20
> err?

Oops ... will remove that. Sorry!
	Simon

--8NvZYKFJsRX2Djef
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlETi5EACgkQrzg/fFk7axZwJQCeIdaJDBkQ0FtHtPoofqjrXl/j
QzkAoIhjEpyIDQl0dHoDN1dxJW+2MzHG
=CApJ
-----END PGP SIGNATURE-----

--8NvZYKFJsRX2Djef--
