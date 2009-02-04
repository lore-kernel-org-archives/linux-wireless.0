Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54745 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZBDKxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 05:53:11 -0500
Subject: Re: [PATCH 2/2] Document CONFIG_DRIVER_NL80211 in
	wpa_supplicant/defconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <20090204062037.12891.4454.stgit@ct.roinet.com> (sfid-20090204_072101_015392_5CF80812)
References: <20090204062021.12891.96607.stgit@ct.roinet.com>
	 <20090204062037.12891.4454.stgit@ct.roinet.com>
	 (sfid-20090204_072101_015392_5CF80812)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j+LvombhFSVWo3XDKtPS"
Date: Wed, 04 Feb 2009 11:52:35 +0100
Message-Id: <1233744755.3992.2.camel@johannes.local> (sfid-20090204_115315_068387_4981665B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j+LvombhFSVWo3XDKtPS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-04 at 01:20 -0500, Pavel Roskin wrote:
> Put it after CONFIG_DRIVER_WEXT, as it's the new Linux wireless API.
> Move comments about kernel includes next to CONFIG_DRIVER_NL80211, away
> from CONFIG_CLIENT_MLME.

Eh, no? The kernel includes are not required for nl80211 if everything
is set up correctly, or maybe for client mlme only?

johannes

--=-j+LvombhFSVWo3XDKtPS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJiXNwAAoJEKVg1VMiehFYx3cQAIkTkP5HzDflllpvJV/jEsT2
8I8hIcnP5qWBmtwNLA10SFfJLBa706fotMQjYMzlUty6E5VQPG0Mwcv+OlgzHqH4
PJ3LvGlBzQkjZ7h8Znj2HREMwLabz30czWjnTKQEJqSFkJwcBwuRQYATfa8jHajq
F+orutAKvB7ibiqR4WrR0Gi0Ft5u3QM9TKQcELd05qNRNVShKkkrTaj+MTyIbAo7
eueTxhJv5s9jUcS7qWZVLABUCIFXjUZOhwwqXlMUKBynr5G8XYsdrA2iu+CYUt49
dsR92iE0S2W2+/HDl4Z9o2HwAqSKQyyIwrddtpt2blM8saVMu1YsUtVx5xzjZjPS
L+AvIoBot3oHQbos4fOj2bcW6V7xEkpPojC2Qim0cD5GHkTmZULJSn+XNC6sDL+c
qoBuZPS1pvJtYTsa114ngayFi16j9WUjar+yt9q9sSh1mESVaSBb8OdpXkOEmezM
qkPNEePBETOxdlKxHQHL/rV/0f7k4nOcvQf3lGCMKeHGDmo9mWB1RSbEO0A45Nvl
jFEs61fnL5/Hs7mQSAgzyJY9ZA2n1FliB5T4DyDkskPZAOYg4YwGPi/4QzrGTMsV
PPpIRcv/DXyxzo74TtA1RdzEZaxnolzvL43vfMtVsbvX5NGOzhe1jh2iPoMKsg1c
DgSvNDQXp74FtyxnZndK
=QARt
-----END PGP SIGNATURE-----

--=-j+LvombhFSVWo3XDKtPS--

