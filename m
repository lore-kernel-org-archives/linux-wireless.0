Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYLKUYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 15:24:10 -0500
Subject: Re: [Patch] nl80211: Add signal strength and bandwith to
	nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812112112.30509.hrogge@googlemail.com> (sfid-20081211_211613_833666_16F1FA2E)
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812111922.49439.hrogge@googlemail.com>
	 <1229020101.8081.55.camel@johannes.berg>
	 <200812112112.30509.hrogge@googlemail.com>
	 (sfid-20081211_211613_833666_16F1FA2E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-N3xLF+ZL4tGOr26omM/X"
Date: Thu, 11 Dec 2008 21:23:31 +0100
Message-Id: <1229027011.8081.70.camel@johannes.berg> (sfid-20081211_212415_792809_CF021DD1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-N3xLF+ZL4tGOr26omM/X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-11 at 21:12 +0100, Henning Rogge wrote:
> This patch adds signal strength and transmission bitrate
> to the station_info of nl80211.
>=20
> Signed-off-by: Henning Rogge <rogge@fgan.de>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

You should probably send this with just [PATCH v14] (no Re:), CC John
and not attach the file but make sure the inline version is ok (if
possible)

johannes

--=-N3xLF+ZL4tGOr26omM/X
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQXa/AAoJEKVg1VMiehFYJIkP/3DwVBKo6fGPR99UQ3jiZQcI
Cw9OciJo2pxsQH7MeQXLDgdXAsWqUp6nbc9qNmtAZf4zjURNs3jwAW+UlS9sMIT1
CUlfe44JiC5V9JQStBrbmLzlyvutMNDOWXbL4mxYLS99ne9827Ya5xDEgWNL4KOm
Hxk66dLDhxDMO+pFScFwhddd2IGlCGfbWGSsjTx742x1ivA+rBuT49mNjrIKL4Y6
WGpujys1OGCjwE+vnFDwZqBBw4E2Ny3bKahJjHhxhyej3vJryUc+Zf5RpLxmwGiI
5tfhLqCFl86sy6bS/xTq53VpmWuwoRLoB1v0NuiQQW9fp/fj0nz9VI24l3+pMyPz
GJ+epxo3FdVtigTxzteje+qqj3C/AFieRgwxha0DxGRwYByhrjbIDuhBViSq2aWs
D847pV8bw9G74tu17fSU0+T9Hi48yavT5WGrc8VYqBYD40nqFlPT7NtFXywpK22Z
ERvcefm9tQ3w6Y2WVPvbxNg42/n5pvRKj3lsbh0su1fZZHudWKWely9Pp7ilXwEG
/rXo/eAQbTIHmV+cDR0/E93LP3stu5SjltxMcPxqn4SRkQPKczBbz3tdX0XZMVsG
uSLkYKFDa/P/L/i3VfJRmmoqF+pWRU47asMW2mmOkSW1B8/Z9lJ8dI4Pk43eX2G3
kBlOor6RCyrJaJcDnlwQ
=e/v6
-----END PGP SIGNATURE-----

--=-N3xLF+ZL4tGOr26omM/X--

