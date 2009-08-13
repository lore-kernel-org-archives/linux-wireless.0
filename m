Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44601 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbZHMTjO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:39:14 -0400
Subject: Re: [PATCH 10/20] wireless: group Broadcom wireless drivers on
 kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
In-Reply-To: <1250191909-21682-11-git-send-email-lrodriguez@atheros.com>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
	 <1250191909-21682-11-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cvKFWuW6SDOixysPnV6l"
Date: Thu, 13 Aug 2009 21:39:06 +0200
Message-Id: <1250192346.21250.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cvKFWuW6SDOixysPnV6l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-08-13 at 15:31 -0400, Luis R. Rodriguez wrote:
> Cc: Michael Buesch <mb@bu3sch.de>
> Cc: G=C3=A1bor Stefanik <netrolller.3d@gmail.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/Kconfig |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index 65397fe..1a8e9bd 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -378,6 +378,14 @@ config USB_ZD1201
> =20
>  endif # ZYDAS_80211
> =20
> +menuconfig BROADCOM_80211
> +	bool "Broadcom Wireless Cards"
> +	depends on WLAN_80211
> +	---help---
> +	  This will enable the support for Broadcom wireless drivers. This
> +	  includes b43 driver, b43legacy driver and the rndis_wlan driver.

Ok ... so what's the point of all these patches?

Also, I don't think rndis wlan is always broadcom, and in an case it's
almost never marked as such.

johannes

--=-cvKFWuW6SDOixysPnV6l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKhGvXAAoJEODzc/N7+QmaIiwQAM0NyXyJvJP/WAvbGbDc3+01
wDXuy6D/BL3An5v/Y5pgvKJ3kf4d+SlAakxUD9T6F3mrfKsDMjfPrkrcSXzyzsd+
ZjeE3huSqCc9ooZUVOnw8n/NXmQD5il7xzm5m/nOn793AKFKONNsiCSwS6/UIKLX
Ba5VGbNguA5J+0R2pfACFukU5P4VrRjthi9BpCwszX0RbtPJz44e5Cs9Et8Xwh6d
y1kFR5sUnlRkPgOi22qR3xHPbGraQZbbBKkjCRyoxIf6iHYhtjHUfK1e01N3Mw4/
HpCHJlS/ioKVQytlDFjghTJBIuilWtFLQ9ttu9GwJ3ZlDHX9EoYctVcOoYJVbZlW
cqfMag1ez/kic9IqBLb7QDVcpZI+RwknYEF66ZjCpvm4GghhhJ0wfvTcziTNO6TZ
31fdwTStpvNRR2z5QdlGXAXFYcKXf+DJ3Abd7dCPc4oFaGifHMIJBBdjE9HmIVRo
z/Bre6tIgeCjswOrR20Cuefk0uLepTz8EwYLavA8b8mT/icnL4Xxl3nXsUWhyFvv
WMgHuD93heLpX974lc2jpKrCSJQlWUzzQqOuCa8qOTkVDHGcsbPvjjY4KMgrc5bZ
u6zpRw9JygppICzaruDIPs5aAxiZlAAYtu+BPGxcZkSYQ/t+7S85MBs+uqYPsHMP
dy4gvmTuPPNYLFVc8WBW
=+Jih
-----END PGP SIGNATURE-----

--=-cvKFWuW6SDOixysPnV6l--

