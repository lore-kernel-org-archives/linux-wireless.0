Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55427 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZBOQMf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 11:12:35 -0500
Subject: Re: [PATCH] nl80211: Optional IEs into scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240902150509i5df08adcg214901548d3cd538@mail.gmail.com> (sfid-20090215_140947_104879_EFB2F067)
References: <20090213105306.GA18754@jm.kir.nu>
	 <1234522804.4219.13.camel@johannes.local>
	 <20090213111523.GA22438@jm.kir.nu>
	 <1ba2fa240902150509i5df08adcg214901548d3cd538@mail.gmail.com>
	 (sfid-20090215_140947_104879_EFB2F067)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Brl1gT9KFD87DvlglJAg"
Date: Sun, 15 Feb 2009 17:12:27 +0100
Message-Id: <1234714347.4219.70.camel@johannes.local> (sfid-20090215_171239_141563_8F98A78D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Brl1gT9KFD87DvlglJAg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-02-15 at 15:09 +0200, Tomas Winkler wrote:

> Status questions
> What is the version of wpa_supplicant that supports WPS.  Is wext
> covered with IWEVGENIE?
> Is it currently working with mac80211 based drivers?

The WPS scanning might be an issue in iwlwifi because afaik the hw_scan
callback doesn't honour any of the ways to add IEs into probe requests?

johannes

--=-Brl1gT9KFD87DvlglJAg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmD7oAAoJEKVg1VMiehFYibQQAK5wYGXuiaXliaEvNHqLJfrk
+qDIcRZ/kMGYZnygK3Z4Xmmog4TN6sr696JjeETvAmawkGr1VTB2QsPc560V6Zo0
s6MzTrXiGrjh1RORrDT5OemRA9WE2w4qvLVkyP92OazC/63OZWYO1El4CEGcnB6F
nVmdpnOIQ9eB6sRSkurhbt4e0y/r4QDJaqTguHQc5kFEjKuNyodfOOTBhiLGl1HZ
JXCU8zoxt0XEzTr6vcjpex9ldOUWAV8F7Sos7RRwRVUbaS+S4MVmNSZNdBOLPB1Z
JXA/caLD0QI2QtGlfGK3avAA/UhWo1k4BpnwniuCzQc7IKY9hSiiRSdPm9OAFb7e
BbdrBMge+gA9V2ST4inxw+Ptqa2ZmfpfJIZcDNzwrMeIuzOF1HodBms07XCeSQvl
UYasNZgz8T3hOmWQxcEyMJ1p35BYb9YLxzGqEE0/7yLYjF/pGMn+IlkOb3oOXhyW
WEjFtc1pCRuDlC2TDcDMLbdpiD/1zPGMowQEU+8U3M2zYdyRPNWncdxSRouNi4uk
pliuGiwjrlehx0YKJGVgZCaH3rAszq0viZDgiZEQzb7L0U+FyoUzW8N0tMlqzTZd
FuKVG4UpN/WWA6PRNS55pY2C0jy1obAymEdhi7AwOWV6Ad2xnYQHSkPJsU1H4JHR
pgOpDSW+vXyYaiKrWZyo
=cDkv
-----END PGP SIGNATURE-----

--=-Brl1gT9KFD87DvlglJAg--

