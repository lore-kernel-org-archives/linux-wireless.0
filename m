Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35120 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbXLLRmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 12:42:14 -0500
Subject: Re: [PATCH v2] introduce WEXT scan capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jean Tourrilhes <jt@hpl.hp.com>,
	linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>
In-Reply-To: <1197473107.12484.3.camel@localhost.localdomain> (sfid-20071212_153046_541924_F187547A)
References: <1197473107.12484.3.camel@localhost.localdomain>
	 (sfid-20071212_153046_541924_F187547A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ITzcMptDrxVfVPpullS7"
Date: Wed, 12 Dec 2007 18:41:05 +0100
Message-Id: <1197481265.6558.134.camel@johannes.berg> (sfid-20071212_174220_012367_8C56402B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ITzcMptDrxVfVPpullS7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2007-12-12 at 10:25 -0500, Dan Williams wrote:
> Introduce scan capabilities to WEXT so that userspace can do intelligent
> things with scan behavior such as handling hidden SSIDs more gracefully.
> If the driver reports a specific scan capability, the driver must
> respect the options specified in the iw_scan_req structure when handling
> the SIOCSIWSCAN call, unless it's mode or state does not allow it to do
> so, in which case it must return an error.
>=20
> This version switches to Dave Kilroy's suggestion of claiming unused
> padding space for the scan_capa field.
>=20
> Signed-off-by: Dan Williams <dcbw@redhat.com>

Looks ok to me.

johannes

--=-ITzcMptDrxVfVPpullS7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2AdMKVg1VMiehFYAQIoDQ//e9/1zLPBenYJen2hGlyEkRUD/+LkSyV9
SJfgHaHaHUFxdpvmcbjn19/fHCFZ8j+GZNiloLcU26AufztYYK0+rvQdRpbCO+Tg
mn+DjC5LhraL1u9fFhuHySSTO07vhLdyx6LqQXSM03fT5vCwrWiSndj9SsXUYkxO
Tn9BaCdC6mit4yVe6ApsOMs5Kqa8Bkuo0maa/UpWY57wVa9NgTVDB5Y8chzfPklN
Nvzq42mM0ltxj/7QqhbWt7FbHDmHA92hRwd0/DSNPoU/yAzTkilyYvTDtMwU9Hlu
4mdBNSna71sUYSjIqS3KgFK2WzReoIrDTs4+2aCrDEn5somUd034C4zf/WAUSrH2
j8sA5flJ0WsxVNiwg5GHYkz17oS6wVxoPDiupZQVpM1S2o531IRJNqWh9Q5V+mlv
Eq1chFgXYqfQfxzEsoZY1RApF+kG8IwPHRRphY/q9I0YNBrocqfAYhwWkiaElCtk
eDKTTiGosPXQwTz8v42MnmToN0loM9KGyDTTD3T6dga415SDvuUMcEdPXCqMK3r7
JDoKLde8t9jFRWvQSFwPsOTj1u1bs1uXEo562ckes7EY/V94jXNHFGRXS/epYgT0
zOkTRsV0JNy+M9LojkogMxR0qjgLTfarEKb7MbH/m2X7PVV5rFzZ78iTYjsHs4Vj
ENBaBKtIg+0=
=8QpK
-----END PGP SIGNATURE-----

--=-ITzcMptDrxVfVPpullS7--

