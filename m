Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276AbYG3JxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 05:53:03 -0400
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
	rtl8187
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <87fxprvjjm.fsf@nokia.com>
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <200807290021.45400.herton@mandriva.com.br> <87d4kwl7hh.fsf@nokia.com>
	 <200807300037.50088.herton@mandriva.com.br>  <87fxprvjjm.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vfM4g2o1t0fla1B8hQFx"
Date: Wed, 30 Jul 2008 11:52:36 +0200
Message-Id: <1217411556.10489.100.camel@johannes.berg> (sfid-20080730_115307_328901_C7B3338C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vfM4g2o1t0fla1B8hQFx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-30 at 11:54 +0300, Kalle Valo wrote:

> To tell you the truth, I don't know if ops->config() calls should be
> serialized or not, but I have always used locking on the driver as a
> precaution.
>=20
> Johannes, can you comment on this, please?

TBH, I couldn't care less. Most drivers need serialisation anyway to
guard against others accessing their registers, so I never saw this as a
big problem.

johannes

--=-vfM4g2o1t0fla1B8hQFx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIkDngAAoJEKVg1VMiehFYtlsP/3PSH8v8k7NDxMT1DSAKp4M9
aXz0ao1qlHIoGLrP01iMAj5eVdpGDqh+zl+5QaOFd4DJREhnqz+ZpDeHZF/sBKBu
mEX8ShKX06aF9eLJLAOx6pOoy0s+d3SFN2mwUahtF1qG7noqtDGJsDPm6oXr8xeB
Ri8CAdTDK6VslAqB18x8ziRyN2wOhwAI5bJY+R4XOna5OlfhP3WhInJYSb67J8I5
/Wr2NEog6lIF5Kt2PgHfw5pDxUzGgBpMI0T6LFTdESrMd6uO80EdQmmnAMlGTe9b
KTRKG1bbfR/Uw4YplC4vLjHRyLG6ocWR4veNkk2BO4HsQcu+TO70M3jbW5HyHaKp
6VrKPCXVflesU2jCF7+jn6F07f7VL1BOvAwCIMMh4ZaiOw8AATwQYVVLY4F86biU
BO0qyGPAKks+NSr/fg48eXqouroiN3NEsRN+5umSJXTlLuTlvPb0oze1dRmhg17W
PkUdHNtGJMHjwBl79w1tcyUcIaUrwu/zp+NBijDKwqMuvM5EN31bz6ubwhsyaMcF
wqrENT+LS75Ufy/yqhCb6QuthaeahbVVK5fq++OmGSU2CGx/4N8yyn90cAyfDPrR
0KuZidJC0htcd6/bFFcq2zZ3EJuO4GB1HvLuxPvo2YNGbmy8S+8pvN7SmidLdGpz
uiNTJpAunjtCwIKFw+9b
=GLmt
-----END PGP SIGNATURE-----

--=-vfM4g2o1t0fla1B8hQFx--

