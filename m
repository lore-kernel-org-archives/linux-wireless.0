Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:41724 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab3GEI7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 04:59:34 -0400
Date: Fri, 5 Jul 2013 10:59:28 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH 2/2] mac80211: enable HT overrides for ibss
Message-ID: <20130705085928.GA13122@pandem0nium> (sfid-20130705_105937_406858_F97A3611)
References: <1372408799-25651-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1372408799-25651-2-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1373010572.8548.2.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
In-Reply-To: <1373010572.8548.2.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 05, 2013 at 09:49:32AM +0200, Johannes Berg wrote:
>=20
> > +	/* on the next assoc, re-program HT parameters */
>=20
> assoc??

What is wrong with that? Should I write "join" instead? This was merely
copied from mac80211/mlme.c :)

Cheers,
	Simon

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHWivAACgkQrzg/fFk7axaOLACfQn9CgigbdI1TheWkCh5qMLID
J1YAoObCyDHFeZm8TcZe7io79Mbd5QJj
=P4rw
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
