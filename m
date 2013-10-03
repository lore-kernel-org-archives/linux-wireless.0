Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gw90.de ([188.40.100.199]:49005 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab3JCJPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 05:15:06 -0400
Message-ID: <1380789618.8125.7.camel@mattotaupa> (sfid-20131003_111512_755587_31872999)
Subject: Re: [rt2x00-users] [PATCH 2/2] rt2x00: rt2800lib: remove
 TXPOWER_DELTA entry from extended EEPROM map
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Date: Thu, 03 Oct 2013 10:40:18 +0200
In-Reply-To: <1380742914-22486-2-git-send-email-juhosg@openwrt.org>
References: <1380742914-22486-1-git-send-email-juhosg@openwrt.org>
	 <1380742914-22486-2-git-send-email-juhosg@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-jE+VkKHxDZAQCEw+9dQQ"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jE+VkKHxDZAQCEw+9dQQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch, den 02.10.2013, 21:41 +0200 schrieb Gabor Juhos:
> The TXPOWER_DELTA field of the regular EEPROM
> stores the TX power compensation value for HT40.
> The extended EEPROM has no such field, it stores
> separate TX power values for HT20 and for HT40.
>=20
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    1 -
>  1 file changed, 1 deletion(-)

[=E2=80=A6]

Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>

--=-jE+VkKHxDZAQCEw+9dQQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEABECAAYFAlJNLXIACgkQPX1aK2wOHVgiHQCZAUv2GWxc/yptmpcVbIRlRoOW
MR0An0VLfZ251m/RpBSYY24BvKmDXCSZ
=y7I7
-----END PGP SIGNATURE-----

--=-jE+VkKHxDZAQCEw+9dQQ--

