Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYIWQyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2008 12:54:36 -0400
Subject: libertas tf warning
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Javier Cardona <javier@cozybit.com>,
	Luis Carlos Cobo <luisca@cozybit.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uTaSFZyzBIXAIBghSa1S"
Date: Tue, 23 Sep 2008 18:53:38 +0200
Message-Id: <1222188819.18015.28.camel@johannes.berg> (sfid-20080923_185439_721818_6C521666)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uTaSFZyzBIXAIBghSa1S
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

on 64-bit:

drivers/net/wireless/libertas_tf/if_usb.c: In function =E2=80=98__if_usb_su=
bmit_rx_urb=E2=80=99:
drivers/net/wireless/libertas_tf/if_usb.c:334: warning: cast to pointer fro=
m integer of different size


johannes

--=-uTaSFZyzBIXAIBghSa1S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI2R8PAAoJEKVg1VMiehFYTgIQAIWTO7+oC9rDE+41XavT9LQE
1cOjC7nFh6mR0X7t6GioSAR3qQ1tzOYe8K30CjnRpXpOzRI7zsnqRqTTQsN4ZLnj
5Swj8VF3+XMbXsBTUTSdNfs9oiE6hDFjWDHHtreW0zx03+vzT826JVaEY7TNujlp
Jy2+uhYPHLUfQ57MbZWs6yrDU3kisrCutSw6n9G3qNHna3nzlAD9u0CilB9h+NBe
ajraaz9U8ZyvV/BPiHLYBZt7RbBlCmgqGk5nKQ8KKEvoinZqQMXMfSRNJb/u3wBg
AvzfeZJA+67XE78XCtfZDaPhLOVQxBVu5qlyDWQBwNTS2j4EpTv+PEtQ68i2yWXq
6uDteAOcxUTpyVwIbm08b6j/W+STrystxlL8Xv2DkBt+tsE28/iSxZvw6dLXraPP
1LOrzAgawKZ+hyNAbYoZhGy8AI7RCgKZxUefnvGh8xyymrG9dQKO97byl98FiTAW
n+2pkJHE74TQ2Htt/FQgDLL2wrP8wWJsfZu0raPHeLZBTo41QTJmim82lSNCIqow
54bzOEYOTVkJztIAlMLAiq/x/bY+CIX5VbXDa6ogT1H8lLZrOuxx0BDyK5uYqKgF
2irO3AP7yp9z0K6e1eEriACzj5ZT73GeJP087402A6YWNX3CorvOceauhQ7CWMm1
8QlShfIeWMOzoso9VTdB
=DmaJ
-----END PGP SIGNATURE-----

--=-uTaSFZyzBIXAIBghSa1S--

