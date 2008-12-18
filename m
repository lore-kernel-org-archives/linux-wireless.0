Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbYLRVVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 16:21:38 -0500
Subject: Re: [PATCH v5 1/3] mac80211: enable IEEE80211_CONF_PS only when
	associated
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081218211658.6842.99133.stgit@tikku> (sfid-20081218_221728_472418_E1A72F13)
References: <20081218211532.6842.88104.stgit@tikku>
	 <20081218211658.6842.99133.stgit@tikku>
	 (sfid-20081218_221728_472418_E1A72F13)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XiC8kVyfpFppT7TE7c3H"
Date: Thu, 18 Dec 2008 22:21:37 +0100
Message-Id: <1229635297.3601.45.camel@johannes.berg> (sfid-20081218_222143_722299_898F4983)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XiC8kVyfpFppT7TE7c3H
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-18 at 23:16 +0200, Kalle Valo wrote:

> +	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
> +		local->hw.conf.flags &=3D ~IEEE80211_CONF_PS;
> +		config_changed |=3D IEEE80211_CONF_PS;

IEEE80211_CONF_CHANGE_PS

other than that,

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--=-XiC8kVyfpFppT7TE7c3H
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJSr7dAAoJEKVg1VMiehFYCG0P/2lNp2huCHHI/HFYfeTfFL+O
1KoGPPAE/xjEJ8wNgFOFYhLmZ4M5XTMgp+oLUsDf7z3u1eONVGmYsgJIx6z7Gex5
Prgp+5/07kIIyzPg/69RsgaUDNDsMgsngZgOnwWq8Mw0jz4785atrRDDm3x1IR+i
PpXvUe+nPem6yrpAPv/srT8LVg2ghC6nIazodus0pXHb1K2uB7rG4DzDP/Mb8ldG
8sf4bSZ4DnFpyHvCJepZNe6K4JqQYK0RbEcdMYteKQi0Z3vB70tvA3OoMkUPo3/3
lGihDxcrkWAVcIBUFFPeBF7CGnODTq209RM1OrWlyLZSY24jg1VYti3zKU5+W44T
lyqKlmrWl5gwp29/qDlGfgvI4xtvS0sagdu5xwm+SkZMRLfB0nMedrZ2ldKu6BME
QA80MAozS7DPdPHZ+uN+vyUXeYteyFppiFhdRHXV90VL1bGMWBxyW2BrolcZ6Mg7
0nx6RvBcsWBudrtjut820bT8JaUnuJh3csdgin7dV5tPyszDMe0Yu2Zl9uARfX3E
1MJZWh+pzxDbTA8s/mzrFBm2O9RcSHjrJSY8cQ85ij4BWzMdM2pRd7IxBuF0XKY4
aYl5+i0KuQXmJlPV28f5AUTDU7xVjhx6LhgRGB0JjnIBq0NMfiTJxnLB5MBk1sbn
WsCpV1DnwtXNM6tZvrEI
=geUa
-----END PGP SIGNATURE-----

--=-XiC8kVyfpFppT7TE7c3H--

