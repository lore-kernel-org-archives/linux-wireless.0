Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbXKZPtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 10:49:24 -0500
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: drago01 <drago01@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1196090387.4202.12.camel@localhost.localdomain>
References: <47494851.4070504@gmail.com>
	 (sfid-20071125_100303_057404_A213DFC8) <1195987773.4149.214.camel@johannes.berg>
	 <474955E1.30603@gmail.com> <1196090387.4202.12.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Dy0nT0PTHvQuXlJ/WSHG"
Date: Mon, 26 Nov 2007 16:47:31 +0100
Message-Id: <1196092051.4149.272.camel@johannes.berg> (sfid-20071126_154930_175579_5B0634EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Dy0nT0PTHvQuXlJ/WSHG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Let me rant that ap_scan is the single thing that has given me the most
> headaches with NetworkManager.  It's simply impossible use correctly on
> Linux.  There's _got_ to be a better way to deal with hidden SSIDs.

What I'd expect you to do is do a directed scan like "iwlist wlan0 scan
essid XYZ" (and be sure that nl80211 will name that "ssid" rather than
the Jean-thought-it-was-better "essid") and then interpret the scan
results.

johannes

--=-Dy0nT0PTHvQuXlJ/WSHG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0rqkqVg1VMiehFYAQJXYxAAvZUJBb31hRCV77Ws5rYBaZgOFF+Gv7TQ
stu6DnAcpiw4SUAI9UBmrgf2YcFN0A1ygf4jM0ECn84FQsRH4seo1GAe5WdtQ0bj
SOs4AYJS+zqlHe831y0wZfgu7BzfcBYG6NfQD0odwFqWYbdMrcOuDi5K23n8sa4O
1wKNNLI10e50uvXDBXzDH5Qn4mXOZ5cxCU6VVQWCkqpRPQ6FGiwWGIHWuFzCdOek
E7/3quD6x+/oeNnOFxp+KmtI9GW5NoY7jr4imVtuZmbs5z95jLVh/VTDGRudb6X3
60+27sBYFBk+HhqBNaUhlcfyfenPuhBPCMIr2wBPEzjL/kqwcttZsm5hnfJLYkb+
enf79xMzYjKBllG4vOhqS2cAa7YFm1Y/Y0vXSRtgFRa4fyduohzOaQVtC3o+HXTu
SBFZjx5KeqWz4/p8s8qsHxlqohBhG0zo/HEeEuObcjp9TCBGqvZysAm6U1ImkZRl
+MJ9hdpua3uxbD12D2O2xDRLL9PirejwSoiPixL0qRCcFtJiH0GWoAV4ZP3YfZhZ
bkWJyK/N7eX1820q2zIZzvA00YW0agncZR6r8FX1JmgqN81so0IoLyv4kn1BhFeU
Na1c2J9Ws0QEp96WvOqnj37Doba5aM6SzRLSsq6Acani2fXjeeYpzVpb6eGKKJQy
70Z350+43NU=
=ySeJ
-----END PGP SIGNATURE-----

--=-Dy0nT0PTHvQuXlJ/WSHG--

