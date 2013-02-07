Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:43512 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3BGLLU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 06:11:20 -0500
Date: Thu, 7 Feb 2013 12:11:11 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv8 3/3] nl80211: allow DFS in start_ap
Message-ID: <20130207111111.GD26957@pandem0nium> (sfid-20130207_121123_844402_F0E79CA5)
References: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359982200-2321-4-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1360172180.7910.55.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cQXOx3fnlpmgJsTP"
In-Reply-To: <1360172180.7910.55.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--cQXOx3fnlpmgJsTP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 06, 2013 at 06:36:20PM +0100, Johannes Berg wrote:
> On Mon, 2013-02-04 at 13:49 +0100, Simon Wunderlich wrote:
>=20
> > +	err =3D cfg80211_chandef_dfs_required(wdev->wiphy, &params.chandef);
> > +	if (err < 0)
> > +		return -EINVAL;
>=20
> return err; ?
>=20
OK
> > +	if (err) {
> > +		radar_detect_width =3D BIT(params.chandef.width);
> > +		params.radar_required =3D true;
>=20
> It seems you should probably just squash this into patch 1 since you
> already use it in mac80211 in patch 2 but only patch 3 makes it valid?
> seems a bit odd

Yeah, patch 1 was becoming bigger and patch 3 smaller ... will just
squash it.

Thanks,
	Simon


--cQXOx3fnlpmgJsTP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlETi88ACgkQrzg/fFk7axYhYACaArwJu42eK/khrp9wX9arwPE0
MW8AnjFg0lb1vJrO3nTgCNq4bGJ/37wr
=3YpS
-----END PGP SIGNATURE-----

--cQXOx3fnlpmgJsTP--
