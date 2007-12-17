Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55175 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbXLQAtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 19:49:18 -0500
Subject: Re: [patch 4/9] mac80211: Make PID rate control algorithm the
	default
From: Johannes Berg <johannes@sipsolutions.net>
To: mattias.nissler@gmx.de
Cc: linville@tuxdriver.com, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071217002056.351743954@gmx.de> (sfid-20071217_003027_856429_02EA0E67)
References: <20071217001956.640555983@gmx.de>
	 <20071217002056.351743954@gmx.de> (sfid-20071217_003027_856429_02EA0E67)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HLrCPaKzCtj1tkywZUng"
Date: Mon, 17 Dec 2007 01:49:06 +0100
Message-Id: <1197852547.4885.1.camel@johannes.berg> (sfid-20071217_004926_611700_49DAE964)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HLrCPaKzCtj1tkywZUng
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> -What:	iee80211 softmac wireless networking component
> +What:	ieee80211 softmac wireless networking component


Unrelated change, please separate.

> +
> +What:	rc80211-simple rate control algorithm for mac80211
> +When:	2.6.26
> +Files:	net/mac80211/rc80211-simple.c
> +Why:	This algorithm was provided for reference but always exhibited bad
> +	responsiveness and performance and has some serious flaws. It has been
> +	replaced by rc80211-pid.
> +Who:	Stefano Brivio <stefano.brivio@polimi.it>

I don't think we really want to do this. We can't even change the
algorithm anyway except by recompiling with a different default.

Will do a code review tomorrow.

johannes

--=-HLrCPaKzCtj1tkywZUng
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2XHgaVg1VMiehFYAQK3sw//e6zBSLlVkI4c0dD7Mdx2jcapDv1EpaNF
mrSjjv0Ow7Zy+AoynESI1Y5AFkFvF1aCmayh3t78koRHuDzoUPrWX2tZZCRAUkk9
YtiiuauifIaiWSObg67Qo3m9WCdgRUIivjY6kfvCEVpK6o2Q+OHAdCiYkYFUBRNd
svMYOwIOmlqKCaLf4fTYgpHj5Kv774gOe1cIkEHPUt09Hwe47LXbHYbKN+Tc9/Sh
n8M3KOh3AfJgnB628OXxqHZ4Y0vvN9b9G8hnsQoBPBX1tl/nb5NezYoMbCLqlljD
krl/317khZ+qenQyVP0OeCf8Tc0hs4BTx4IzJLH/cXxj/zoZCMQFzAa8DN5HCfwE
hNXD3PvTiI4ubmhOFRskqkDZWsbaGjpGlV9HBLOIbRonp64Nvv3nLvrHEQyAbLnh
I8N6MKJX7NCfTVo9mcuMI96YGPHseP7k8iFhL++4V/RI5Pi8Q+6fCLO/FdAwAmoO
3ksndgksFouOmt/Kg6KV/ovCPVNRRFApJaZaT4aV6serDp+umyqUmmpNLgriCVAd
GsS3ZDUHGjZjJPotZAgNc7LdfeHYK1gRAYQW0ufWumxyhBmiXKMIZUQ00fXPh1/u
J3iTOAbbi9uF1H1qerP/rIPDE2ww8s8ZdwtHI4xF88oL3Xsk56UwYJgCwxdDiNeL
60ClkCPW8/I=
=q+V4
-----END PGP SIGNATURE-----

--=-HLrCPaKzCtj1tkywZUng--

