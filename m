Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:42543 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab1KPM35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 07:29:57 -0500
Date: Wed, 16 Nov 2011 13:29:54 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCH] mac80211: Add NoAck per WMM Queue Support
Message-ID: <20111116122954.GA8106@pandem0nium> (sfid-20111116_133001_583857_AEDC5035)
References: <1321399276-3585-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1321429935.4773.10.camel@jlt3.sipsolutions.net>
 <20111116105120.GA6139@pandem0nium>
 <1321441067.4773.26.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
In-Reply-To: <1321441067.4773.26.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

On Wed, Nov 16, 2011 at 11:57:47AM +0100, Johannes Berg wrote:
> >=20
> > I'm not sure what you mean by "per connection" - do you mean per AP/Sta
> > connection? We need definitely need it per queue as explained above.
>=20
> No, I mean ... it could be a parameter to connect() or associate(),
> which would get a bitmap of ACs to use no-ack policy for, instead of an
> explicit new configuration.
>=20

One requirement we had was to change this feature at runtime with iw - this
would be difficult to do when we put it as parameter into connect() or
associate() ...

I'll resend v2 in a few minutes.

best regards,
	Simon

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7DrMIACgkQrzg/fFk7axa4xwCfWuKpN6SpY7K23Z/KXKvlEIbM
DqMAoIaLibD23vV7ULSE4W3laO5mip0u
=EvSV
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
