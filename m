Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41549 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbYLKI11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 03:27:27 -0500
Subject: Re: [PATCH] rtl8187: Fix for change in STA handling in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <49407404.WzMzB28hDBCaCLlQ%Larry.Finger@lwfinger.net>
References: <49407404.WzMzB28hDBCaCLlQ%Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IpelmwyS4DVlZg8E7+zf"
Date: Thu, 11 Dec 2008 09:26:44 +0100
Message-Id: <1228984004.15837.77.camel@johannes.berg> (sfid-20081211_092735_526252_F3189DA4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IpelmwyS4DVlZg8E7+zf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 19:59 -0600, Larry Finger wrote:
> After commit ca247d5f50acd4fc6fdc1dec770e726b0d7eda60 "mac80211: only cre=
ate
> default STA interface if supported", rtl8187 stopped working because the
> add_interface callback was not called. For reasons that I do not understa=
nd,
> the IFTYPE_ADHOC bit, as well as the IFTYPE_STATION bit, must be set in t=
he
> interface_modes variable.

Because I'm stupid. Don't apply this patch.

johannes

--=-IpelmwyS4DVlZg8E7+zf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQM7BAAoJEKVg1VMiehFYMXgP/2tvxaWiS62inrRh4J6a6zB7
LSOGuwc6grn0lhTPNUA2bAUgF0SV4O2y14dudij5rKx+ZMg4nAqAZF3BCI4vxfAI
szusvgAEvMXwBH351Y/agTcc4ukmbLdsCyekbfRPu/mUegAF0klbr5ksSxvpt3DH
rBuziw0xYllBRRL5f4BhWweE/nNd2Fl6g3cThaG+g7mgciDppkznx/TQ7yaBgb8o
9W+CpsXSXtLyKuubX9ylMvT0V+xqTEMIACHt2TnOGbQ+MjNHW/x90QRGMJPZ1Dkw
uvOVF9xW/caU+lSRDw8iHkp2ljTu6GydZfsTVOOH+u8l0pk4VH6p+k5aBZKltPdM
YW1PNnqt2jr29x1dvJoflZC5tbUS4Cox1InA2J+xeZsOwKAtBekcDZ3KKEcOVwuA
YKTRo+3tLHfNGJV4Jel0U7fE2z4hnKETrA2Gci5fPwY2S7itfD1Y5NsfVa+vRUFl
UTpa3CvkyeOT5oh1SGGye2MINXpRoUS2mhWBOex7gk1y2FZiTWG0QcxRzHooEFwt
u8pnpd70D6JIFAawFDN/fQc9dW7PNDQL7ysdkL2fyaNRQbcDKK9k6/XrUIuSmXwt
oGkJaxiqLrlW9LnF6NXi9x863i7NJEcue7bGRTTmDkDIDRDdePMw9+/999MGgcAT
VIji7Cg1y5GvlY1CXlai
=vxx7
-----END PGP SIGNATURE-----

--=-IpelmwyS4DVlZg8E7+zf--

