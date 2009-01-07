Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54005 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZAGMIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 07:08:18 -0500
Subject: Re: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for
	management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
In-Reply-To: <20090107112707.370907962@atheros.com>
References: <20090107112346.369581673@atheros.com>
	 <20090107112707.370907962@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DbShglKId3afEG2MjG6F"
Date: Wed, 07 Jan 2009 13:08:38 +0100
Message-Id: <1231330118.3545.28.camel@johannes> (sfid-20090107_130822_073463_355288CD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DbShglKId3afEG2MjG6F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 13:23 +0200, Jouni Malinen wrote:
> plain text document attachment (ieee80211w-sw-mgmt-ccmp.patch)
> If driver/firmware/hardware does not support CCMP for management
> frames, it can now request mac80211 to take care of encryption and
> decryption of management frames (when MFP is enabled) in software. The
> driver will need to add this new IEEE80211_KEY_FLAG_SW_MGMT flag when a
> CCMP key is being configured for TX side and return the encrypted frames
> on RX side without RX_FLAG_DECRYPTED flag to use software CCMP for
> management frames (but hardware for data frames).

Wouldn't it be better to invert the meaning of the flag so we don't have
to update all drivers now? It's likely that people won't test CCMP hw
encryption and also that it won't work, I'd think, no?

johannes

--=-DbShglKId3afEG2MjG6F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZJtDAAoJEKVg1VMiehFYhQUP/3AZCgMaO8faJmbiGX+sSn7J
nlatj6NNh2+F3KaWLBu/68shxWO51D4c2ZGK+OknT9WWVrLvE+EUKZWXuHwbalnb
KS9PgyFxYjS+loK3P/AW39aAP+Wvg2QlGygmo8T3QjoOTZMp3UEveYtlMHXhzRop
oQj2qOR0U5aoGkTJEMWE3VFUBfWW97O8foW/45yP5d+o1tjGcAOHGkOEZMqFu16E
0BT7EWxD4iB4t9TfrQaE4pK1gcgwe1UfVrlVXiG3Sma5r54BQ/tuP1kMWC9a89KN
4v+EfHgBnkUc2uzqu0VEZM9Gfrd3MLbLnuKq0Vm5zV58t7AnwUtVDbHzKQTdIMri
Ys5UEzN6pwHGZKZcuRgzMJyG9eqgYosz5tXl4lz475tMisNWY/vAWFTizGZ+LIeR
+fPiVqNOYW5xPHbYcpqJDAFo1Zl/xqDc/UtBI1QDMNLG0/xjDQ9VdE/jIqQ387uc
A+59sT+FRoQue1AtKCsvA3m2B4L9Qi7ErLRspyH5twapRT2rHz1SEkscACmRvkVk
t6i/CVppvco6wDiUvPaiP7GDYGto44utlEtuMTn929byOgBXgukUPRuWyc5+CMlP
9Nr6wKAPqemMjKuSK/Rbr4XPUF3OnspeWVIiFtrTtdWvXMO2JQgy3o+OlSN6OWsx
Dwj/zTPQ+E2VxmTx4eVG
=lhDz
-----END PGP SIGNATURE-----

--=-DbShglKId3afEG2MjG6F--

