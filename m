Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38558 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbYEEQhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 12:37:48 -0400
Subject: Re: [RFC] mac80211: Don't encrypt beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200805051841.51408.IvDoorn@gmail.com> (sfid-20080505_183418_816623_69DDA6C1)
References: <200805051841.51408.IvDoorn@gmail.com>
	 (sfid-20080505_183418_816623_69DDA6C1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1clDKK/LAuuZuBqg7T39"
Date: Mon, 05 May 2008 18:36:54 +0200
Message-Id: <1210005414.8245.40.camel@johannes.berg> (sfid-20080505_183706_739633_CB51152E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1clDKK/LAuuZuBqg7T39
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> This patch is intended to for your experimental patch:
> 	019-mac80211-tx-info-skb-cb.patch
>=20
> Beacons shouldn't be encryped, so mac80211 should set
> the IEEE80211_TX_CTL_DO_NOT_ENCRYPT flag in tx info flags.
> Otherwise the driver will cause a NULL pointer dereference
> when it tries to access the info->control.hw_key which isn't
> configured.

Shouldn't this apply before that change as well? I'll happily roll it
into the skb->cb/txinfo patch, but it seems it should be there w/o that
too.

johannes

--=-1clDKK/LAuuZuBqg7T39
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB83paVg1VMiehFYAQJ76xAAiqNiZcoNol1VfA6gyGrD5hcOxMosu0fI
SNrAUPSfFCLcszdYYnyG9HtPCbtLqX7GkVtPOLvjiAmHcjjzaeo+jUEndx6PNR14
dTVIRk4qIraGYgKeSV9Yy5WfBVyr5dc1/sPINXHH4c2wTvFOE5nGtNtiF18znXmB
aiTZ4hEG8xI3QQgFStISbxE0YRXXSA/GTwqUMri743wnm++6HAnsjHl4rqB8kfqp
dKD/g1k3t59216ca1uKM//z4B8sXKPV0zuX7o5bdSq2g07JLtmCYgtmF62SmHy7f
InQSWr7KSHi8UUNXdfWYiW4JSYszRENDHm5shaZDRdtUUl4WyN5DfTXRr+m+Inpi
eu9hMTa+I1HxULKxd2OKpgvXKbKkhqhtICv//pneJMGiRglF+Jh4CtoOCi3Nn5y9
qFvl0n5sSvdlasl8Ytas15ER0PuZAKZLovql9TNgDCkIMZIOwAXC2YV0Zu852IDp
UKqt+935zETyY3uLauyCSMXLmV+mHaHnWtS2YCuqoofX8W659X+2akZpER5Vihv6
WTUUa58u1o1PM5P03siEaVJt3Bx7Ap6S/9DUpCiZ4elHb5jBiMXhQNsBJagIbXA3
1DzUmgqek7bQ+8vEOEjRepLW8FLdeEvnF2jyxGFTPzzwLfvsnXZBfyV0qu3xVC1J
lwEuW6GM5R4=
=ZMPV
-----END PGP SIGNATURE-----

--=-1clDKK/LAuuZuBqg7T39--

