Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51807 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbZCUMqj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 08:46:39 -0400
Subject: Re: [RFC PATCH v3 5/5] mac80211: add beacon filtering support
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	"Luis R.Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <20090321120930.11613.15570.stgit@tikku>
References: <20090321120558.11613.56299.stgit@tikku>
	 <20090321120930.11613.15570.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-m/QlDTbtoFutU+9eJVNc"
Date: Sat, 21 Mar 2009 13:46:32 +0100
Message-Id: <1237639592.5100.182.camel@johannes.local> (sfid-20090321_134710_825766_1897078D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-m/QlDTbtoFutU+9eJVNc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-21 at 14:09 +0200, Kalle Valo wrote:

> +/**
> + * ieee80211_beacon_loss - inform hardware does not receive beacons
> + *
> + * @hw: pointer as obtained from ieee80211_alloc_hw()
> + * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_co=
nf.
> + *
> + * When beacon filtering is enabled with IEEE80211_HW_BEACON_FILTERING a=
nd
> + * IEEE80211_CONF_PS is set, the driver needs to inform whenever the
> + * hardware is not receiving beacons with this function.
> + */
> +void ieee80211_beacon_loss(struct ieee80211_hw *hw,
> +			   struct ieee80211_vif *vif);

Strictly speaking there's no need to pass both since the mac80211 sdata
can be obtained from vif and that has a pointer to local, but it doesn't
really matter.

johannes

--=-m/QlDTbtoFutU+9eJVNc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxOGlAAoJEKVg1VMiehFYjbAP/1nYEUNnw9xnlaEt8YSbSnRD
MgpnbNpTfKJJJ3VGb6D8katosH7yxSp6NsBeJ+XVxBVZkLTRlbTFNqTeoX1Rdf6L
gPzNJVA07FrlSNd3EGJiK361zrhlV/FuhOFTru9U0WkN8ZcGl1nMawuA20uiiNMS
v3VOyutf4E0WnSGinw8Q3uy3Ur924Fo5+mcZls5Lp5u7OanHTBG624XDnm8ou+Hw
wRkNjlykL5Pxizj1N4cZA1bc3OdVgvvuPX/vmYLaCfuQfSGFKxRM3ObiDPqTlrJr
EHfQn0OTPZth417NtT1FQO/GcrhZVh1o9K258U1MBnXx/bfrMACP6kmPwKFSlqdB
xMqwH/5OkbKL7DpfL0rFZfG44qk6MIC0yfNmWagcow7Xel8yhsXX5H9BqrtGTcZ5
3F/lf7o8Y5XllpF814kPJINL3WSX2m1mEfbFv093zy+bi04uXmn/Ln7lUeCzg3BG
NyECU0qz97ECBn5ulFuH1UZWarLUXHwRZYDqReSGbKpdFZe68pE48j6LEGLxyzLr
d0vDke/ZHkFC1o+oo2Lx218tvAyS3iO7J119upfKO/iu3wD2wsNwm2V/LKC3rQBM
k4vX3ER5t7fw8wY7BSFMVxD4HS+j88F1/WV9/cFmdwcxaua4Nie2WSRCMSvtuyy+
bVYKNOyxBiI+QyJe8nk0
=qIex
-----END PGP SIGNATURE-----

--=-m/QlDTbtoFutU+9eJVNc--

