Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYK0Xep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 18:34:45 -0500
Subject: Re: [PATCHv2] nl80211: Add frequency configuration (including HT40)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081126141524.GA8607@jm.kir.nu>
References: <20081126141524.GA8607@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hbp2rn9mUe+qZtX7ATyN"
Date: Fri, 28 Nov 2008 00:34:08 +0100
Message-Id: <1227828848.7559.45.camel@johannes.berg> (sfid-20081128_003448_886038_3F90D54B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hbp2rn9mUe+qZtX7ATyN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-26 at 16:15 +0200, Jouni Malinen wrote:
> This patch adds new NL80211_CMD_SET_WIPHY attributes
> NL80211_ATTR_WIPHY_FREQ and NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET to allow
> userspace to set the operating channel (e.g., hostapd for AP mode).

Should we support this in iw so you can, for example, set your card to
HT40+ mode for monitoring? Not that we can properly support HT
monitoring yet, but still.

johannes

--=-hbp2rn9mUe+qZtX7ATyN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJLy5sAAoJEKVg1VMiehFYw3EP/ArcQSn1e681tyi2psrQ5Hlb
CLTZNvW4/R+tKZAOuTGyFUZsoO3WzuNtEVpodt8EgqCIVAAbj6genkGb3doCOSRQ
sW4PgYZEaCrp8LrLG3i1wqVpUWE4n5u56YoAGTRXUvKa2pPjlH/uqiN3XGcLbAsg
9IqSJt3kk17c1h27AV7IuYrV0iMbjlm6mnaLSr9otwTTy0rBuUu/8UNcKEutiedq
EMzVMeNNpO1/fCH4jxHKM+93vBHb4H/ybP/Gh9Oahul7f9fBv0+onVxTzPQtbPnQ
zS7+c8TzWHh/AFO9NeFw6EkCjbvrutn97XuOyNlzbKL/FgCKs5rSFTiUzI9e5UCb
IaSvlI5ZhG4bBdgrTqAhjVyaISxeteWvqttlYwLVwZ9mcGz/Z1C7dALGOQXXtkhN
wElbxbGM6T/t2uBfNj9lMB8mlB3kYil63swIancO5YzhlyuOTGdYUC7uJk5+RDJN
dV5DTMFxilhuJLwTQyt3Y26iAxOQhC48cB8UInwY20AwoOcxGL22rVbg7q1G0xXl
eRzAkoM5c9XTvfkGE/1qvNxnYXfJ2HGcW/HqiwY9FQZJtrQ1DCcc3Ma0P6gi7mA3
yJK24BhikY31Kmq284NVULoBA1jtmlDk647NDvSBtNZpnp7o/Oh1FnhTrwov7As/
Ps6r2UeezbgBf+AP+/IK
=Wn8V
-----END PGP SIGNATURE-----

--=-hbp2rn9mUe+qZtX7ATyN--

