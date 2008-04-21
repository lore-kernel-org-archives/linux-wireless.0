Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbYDUJOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 05:14:49 -0400
Subject: Re: [2.6 patch] make sta_rx_agg_session_timer_expired() static
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20080421084751.GI26897@cs181133002.pp.htv.fi> (sfid-20080421_094826_042377_F92BCDE4)
References: <20080421084751.GI26897@cs181133002.pp.htv.fi>
	 (sfid-20080421_094826_042377_F92BCDE4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JnziNcEOnDCqZ1Wdo2UF"
Date: Mon, 21 Apr 2008 11:13:48 +0200
Message-Id: <1208769228.26186.58.camel@johannes.berg> (sfid-20080421_101531_193916_0394E116)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JnziNcEOnDCqZ1Wdo2UF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-04-21 at 11:47 +0300, Adrian Bunk wrote:
> sta_rx_agg_session_timer_expired() can now become static.
>=20
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Good plan, thanks.

johannes

--=-JnziNcEOnDCqZ1Wdo2UF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAxay6Vg1VMiehFYAQIRng//YI2newZI/2KVaSA9T7MepevSleFr0mKk
6RRN8M5PO1CmMVbShy1UMRP0QBjQxu5YmMqCUHb36fcI0WzzI6f4kSxthPQ2JeFo
rKTElV1dj7lasq9UwC3ElOqIFNvweDM7F2UnHp02glYgDgCXw3bkCEMToFVBwQDU
on2ePmXGFwF90pof+CeLsDWClS8k2p177O+LfKYduCkVy5IhXIBGH74OeeKdvyH1
AwoXYMKLk9n3wepzQcU/H6fAZbx90J21a/G0X6sSTxfSHNxqaU4DuDhBcPmlzQOh
yc/thcKfv7zBJSOpp9jUyQwhR00vGHUKj33fQmooQ+ilqujzxQBKN7RPkOIo+h/v
SJnYuGOY34rPDhjZZPxNtiOsdLZPloHVqwGRxH2DLtogcWugsOnPO0vwJc55Rco7
vHO9GaWCooStEta3Ix4Zc+9rEnOtfe58+yzP39oYoqLE2lwT/OYg1kLs4tTryiVF
D26ukDrYqa4OtGpxoHH8yYhTI54dd8dO/1UZ+PRsjIXVyCFmqRRNm78c7jamnFzb
xd9DDAKaUiEfrZnssDblt99OZAJrSl8iroVSehUCZq/OscxrkCLcOHvFwVEv4SmV
WTbT32AcBQ2PRoqzwc3Gy9SOS+I+LrQnG+cs4prUXBzNl5mkAAyMSI3XySNw5Sjv
emkJUVRfbWQ=
=aUgR
-----END PGP SIGNATURE-----

--=-JnziNcEOnDCqZ1Wdo2UF--

