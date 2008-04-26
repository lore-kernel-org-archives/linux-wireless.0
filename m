Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56105 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbYDZQQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 12:16:17 -0400
Subject: Re: [PATCH] iwlwifi: Select also LEDS_TRIGGERS.
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Priit Laes <plaes@plaes.org>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com,
	reinette.chatre@intel.com
In-Reply-To: <1ba2fa240804240424r29f4c83boa40f8172f65fd024@mail.gmail.com> (sfid-20080424_132527_332991_4EBA2A2B)
References: <1209033767.1368.3.camel@localhost>
	 <1ba2fa240804240424r29f4c83boa40f8172f65fd024@mail.gmail.com>
	 (sfid-20080424_132527_332991_4EBA2A2B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cQBCXSDxkjXPuH0zSwB5"
Date: Sat, 26 Apr 2008 18:16:09 +0200
Message-Id: <1209226569.10943.49.camel@johannes.berg> (sfid-20080426_181635_227194_DC114C1D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cQBCXSDxkjXPuH0zSwB5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-04-24 at 14:24 +0300, Tomas Winkler wrote:
> Shouldn't be this already covered by MAC80211_LEDS

No, select isn't transitive.

johannes

--=-cQBCXSDxkjXPuH0zSwB5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBNVSKVg1VMiehFYAQKXzg//UkjVk35zgqqa4oSDHZAV0O3unmCkwboM
7UT31huZhnNMSfrrM9FNR+1gCGZT+WpeYYaAxRrwjy0NQnbCG4YLhiHz+oT9as9Z
UZxTRC5X9iWEWXDRuntMMgpXhbcHbts+dQiHAgbVKyElrD3v9nkSWqbCbvytsm7Z
au9gEDuH9XFLObRoDM5Bii2lS9ijhB4rP445jv2qgA7f4QDzzFJ80uD2GFQgGn7x
eSuEmjOHFC4SpKj//hA8L550ZgcK10odaqNWdIjPSLngIAj0WHUN5hR4vmnMRum1
Uhzna0FjgZ9W2fg5IbDM9y4ViQ5EMSDTMVRQkHBEkH4Y5ChsNDrKAOO2POHgORh/
6OBVjfO0rE/oQMgkfQlOugypJSF/jBiGlevcyC7J5el+G3VLVkniA4fsq7xE3pHk
8Dl+96NanX3nC38DSi3F7r9W7tbZLoHP1qHrTKaJbBMxzvLRlUe3E2ZyZajSgRzz
btbu/BZxHid0WFZUY1WPuBmwShKONO7FYMq5dty/SM51ueTaMuf4damWTr8I+z24
mLt1Z6EKyLaQE4co5IQ9TiDnPOfRL/KOVv0wdqNKtFZMrRw3JBzam6UL9EnLMc/e
o9VoeJdqNSeaFtcCulk3DLWTnTC5MiSYGMu+EMZ+ZH6jSxUgz43JMQlIDSBVBJT3
gq5wUNJmeHU=
=INAX
-----END PGP SIGNATURE-----

--=-cQBCXSDxkjXPuH0zSwB5--

