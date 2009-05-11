Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37050 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbZEKT1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 15:27:03 -0400
Subject: Re: [PATCH 0/4] nl80211/mac80211: Fix station mode key setup issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090511185754.653711567@atheros.com>
References: <20090511185754.653711567@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SdSTCkc+IXYUa5NowSN2"
Date: Mon, 11 May 2009 21:26:58 +0200
Message-Id: <1242070018.3873.47.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SdSTCkc+IXYUa5NowSN2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-11 at 21:57 +0300, Jouni Malinen wrote:
> When using nl80211, we cannot currently set drop_unencrypted flag that
> was used with WEXT to avoid need for IEEE 802.1X port control in station
> mode. Because of this, we cannot currently set the keys in a secure way.
> In addition, we do not support setting the expected RSC for keys either
> with WEXT or nl80211 which is needed to avoid leaving a window for
> replaying broadcast frames.
>=20
> This set of patches addresses these issues and allows nl80211 to
> securely set up keys in station mode. This is on top of the pending
> MFP patches, RX-drop-unencrypted-based-on-key-setup, and WEXT key
> handling to cfg80211 patches (from Johannes).

Looks good to me, thanks. One thing I'm not sure about though, is there
no need to push the RSC to hardware for some hw crypto designs? But even
if needed that can always be a separate patch.

johannes

--=-SdSTCkc+IXYUa5NowSN2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCHv8AAoJEODzc/N7+Qmas8AQANOg0TElIhj3eAHcvLq0hyIc
aIIO5oq4o8nMp26l/DXyGFspxiLhR9KhM5oaC6h6ebUEhl/AtSA+64Tz7CcVppLz
eeiDjHIawlNWNVImjyemcbmVuFlhXazdg/MP3yjuoloBV1RfRO2PUnYeCmo10OaN
f9GgA5cMODAMEc7EVTqgtK9SEH3PDh9xxCXttkF2YmuvQQFvfLjrqOYI4DX8QYjp
5xf3tsMqihLBtHflXlXVUU5pL+W6cHawSEzg8p3P8cRxl8cEDQmuuWaiysolejFI
IboFraW7Sk31BN1HTAzOjamVNP1g+LR4NuZcyRHNduNnTHAHSmP6yILGsQr5CCzN
s36Fk29CJ8bU2WBfTSk9SdtwBgw/il1R3cqirLEBD1RpRlgqziFJVJqC/PcJsqHA
e43IN2IEOXcAiL7q5VsDg8YtEze6TEg1Bu6ot9qIoq0h0yMFijrhTrux7wFUk9uQ
WjsEsAyLk071sB/IlefSy0I4NlXKHj8WqctqVfHnJZfL9cSYTXew8bcxvamuMXSa
w37zmeuhDV+2yUBNw6DOmndgxDR2wvywF6/16jpwMBwo/MKb4x8bypzMk9Kbx2TT
h17mqIvwL3Tbj+T5uexX9D9ioPtPZEZFqoyTkzOdepHYzkwpdpIYBq+DTWj499wp
0A814ZOxJGRqEWdWpOYn
=xb+t
-----END PGP SIGNATURE-----

--=-SdSTCkc+IXYUa5NowSN2--

