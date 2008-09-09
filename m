Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39009 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbYIIPm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 11:42:29 -0400
Subject: Re: [PATCH] ath9k: Add RF kill support
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
In-Reply-To: <20080909153422.GA7651@vasanth-lnx.users.atheros.com> (sfid-20080909_173954_277503_9881BAF1)
References: <20080909153422.GA7651@vasanth-lnx.users.atheros.com>
	 (sfid-20080909_173954_277503_9881BAF1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-e8nxZvWPpPXDOm5G5eLN"
Date: Tue, 09 Sep 2008 17:42:22 +0200
Message-Id: <1220974942.31304.180.camel@johannes.berg> (sfid-20080909_174232_883125_7B9F9720)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-e8nxZvWPpPXDOm5G5eLN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-09 at 21:04 +0530, Vasanthakumar Thiagarajan wrote:
> This support is compiled in if CONFIG_RFKILL
> option is set.

> +++ b/drivers/net/wireless/ath9k/Kconfig
> @@ -4,6 +4,7 @@ config ATH9K
>  	select MAC80211_LEDS
>  	select LEDS_CLASS
>  	select NEW_LEDS
> +	select RFKILL

You really want to drop that then though.

johannes

--=-e8nxZvWPpPXDOm5G5eLN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxplaAAoJEKVg1VMiehFYmqcP/18tm9r8aNTmlJgXrNzO4yEo
inFl+YKv+CXWfUcST4HuVTvWIvSIHfQn7WQbQN0ECiNlYsyqh7MvUkn93/UkXeVc
kUcHYxFK2E6ReT3h/aXMs/uTz/AIRsZQ1csWHfLGITtpG7QaVKcGIp0rABmpZM0A
GVTNZAH2C2jRNqR6VEgMkwVYuR1r1VDLUz5HFwUsa/LsSEIim9sO7m8yQwSekScV
g4Grra4P2Ta5sPfuE9623GVSD9l2gJPbVDsBPmDjJCHG65yBqv5qeCmdfaYgDrVk
7WptH2ysF+xZsMIn/sYdo78VvKdp2UAq9pC77U3E5SFjq8885IO5A+QFKulyFzam
4tUAfujUGRrvfUGWmhrF87cJiw94De8EzofH9P9noSiAgSDDiTS7uXDlbfZrTcEU
teFHhayCzEyOSfGicQ1IAZrZuGfgfngjg7ueztOiIeBEMaehUQXTlNawitiKkXyu
QmtxLb+NXD91Cf/eaWLS/amGDQp51zHBwTfARmATk++gmY3sGYX61hIvavPYopx9
yBqcjD3ipLSMdNGhDirSBVPxPKOsRqBAkau4EB4kPxP1nSya8iSAG3gizPMXwycl
MRGBMaU7EcLZz7Ox4Wu37EGtzmsXPEwnDdxv8MyS2RecHkwWmBDWomvY5HKUfGAy
e8Zt6nub8M2qhDWghmyZ
=38dl
-----END PGP SIGNATURE-----

--=-e8nxZvWPpPXDOm5G5eLN--

