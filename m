Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59938 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZDNWiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 18:38:21 -0400
Subject: Re: [PATCH RFC] mac80211: don't ask drivers to retry transmitting
 NO_ACK  frames
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <hintak.leung@gmail.com>
In-Reply-To: <69e28c910904141534w7ed9b36w817f1862ff015286@mail.gmail.com> (sfid-20090415_003523_455143_EF283A5E)
References: <69e28c910904141534w7ed9b36w817f1862ff015286@mail.gmail.com>
	 (sfid-20090415_003523_455143_EF283A5E)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Q5nieVYf8Dx9yKwEDuyH"
Date: Wed, 15 Apr 2009 00:37:32 +0200
Message-Id: <1239748653.4205.27.camel@johannes.local> (sfid-20090415_003824_462956_01239611)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Q5nieVYf8Dx9yKwEDuyH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-15 at 00:34 +0200, G=C3=A1bor Stefanik wrote:
> Set the total count of TX tries to 1 if IEEE80211_TX_CTL_NO_ACK is
> set. This fixes a bug where mac80211 allowed the RC algo to request
> drivers to forcibly retransmit NO_ACK (e.g. multicast) frames until
> the excessive-retries limit is reached.

Why not fix the rate control algorithms to use the no-ack flag instead
of is_multicast?

> Signed-off-by: G=C3=A1bor Stefanik <netrolller.3d@gmail.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
>=20
> ---
> Patch also available as attachment in case Gmail linewraps it.

You need to get a proper MUA.

johannes

--=-Q5nieVYf8Dx9yKwEDuyH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5RAqAAoJEKVg1VMiehFYrswQAII/1u/eDeyI1t3VeyyZIbqM
Zgqw6wxjHe3ZvXTFhIcq17e17gqzTEUf3DiS4Qt7vPZahSOx9VCEY+iaBNxtEs+y
Yjzcr9igx8pa5jB8ovQuMaz1rBy5UHl0YixH5nA7qpKBdcvaQXoyt1C5yFlO/SHW
R1MyLZqSOL48xYFfxh1ZCEI06BeScT00FyiGfA4X8LLfB6sh2EODsFRH22QV1gS3
fHbLbKEZDDENgY6dCOpvw7k89LO0ASssUwRIyak96OSyH0Z4TVbu5c7hxH2ITmNP
+8T0YaEtkmX9SK4rnmZVpcvTDesQ+EzrFIe/uFABuNW9EuwhwBIy5FOrEEuHXH1u
yHehu50XUDiMD7r97ObIxgUnFyZMOJs3cKzuPj6m9hYwn7/hECb+qHZln45mxlfD
L4AJI1s/WpeSSlxf6dUEwHcGbqlanJSCCZXoxqePSpZC9D/E0diXpP9NogUgRfqc
y2j5qsGOHcO2lUTlnNRhBaTefIfPyxSLkusq+HAZIiP2CYhoNOBTpUOJVzJ7pQve
1itrRFaib8ifRBDK9QE7t/cYyPYGhnzwRzTz+2E7B40XXsnITZxK3+QgNUD+qOXa
eZbFCflkgmBBSpfKzvLQ/zXO9y+qZBpN+aNORZbRXuNW13fxy62oD667WfViArcL
B74mLQ8kD8oqGtzzn3rh
=PRCV
-----END PGP SIGNATURE-----

--=-Q5nieVYf8Dx9yKwEDuyH--

