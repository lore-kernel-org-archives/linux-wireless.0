Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34040 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbZEUNlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 09:41:42 -0400
Subject: Re: [PATCH 1/2 V2] wireless: move some utility functions from
 mac80211 to cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Samuel Ortiz <samuel.ortiz@intel.com>
In-Reply-To: <1242912045-554-1-git-send-email-yi.zhu@intel.com>
References: <1242912045-554-1-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IvVxCMUeN9fIU+2vTAHM"
Date: Thu, 21 May 2009 15:41:36 +0200
Message-Id: <1242913296.4212.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IvVxCMUeN9fIU+2vTAHM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-21 at 21:20 +0800, Zhu Yi wrote:

>  /**
> - * enum ieee80211_key_len - key length
> - * @LEN_WEP40: WEP 5-byte long key
> - * @LEN_WEP104: WEP 13-byte long key
> - */
> -enum ieee80211_key_len {
> -	LEN_WEP40 =3D 5,
> -	LEN_WEP104 =3D 13,
> -};

You don't seem to be updating the users of these? I have no problem with
keeping them here either, but as-is this would break ath5k/9k/ar9170,
b43 and rt2x00 compilation afaict.

johannes

--=-IvVxCMUeN9fIU+2vTAHM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKFVoMAAoJEODzc/N7+QmaWO0P/3K6lxcJF1PgulTp9Ng9kbCZ
LJubmF1peEK6musJbObgbKS5ZjQsg8zvDYf3fAUBelpTT+Ve3MHPCNDwSTCQ99OO
BYi70zuW+Sq39JrfjHommRxkqsD+rd4YT1Kbu/nci9oX9TK6Ct/v9bSYQxWyRvbd
1FKbp9j20FHBqrcz6P6J2UbyzUj93WO+qxMdBwxGtlFp8b2Lw/iIL0kebf0gJT7O
3YU9eY2Kerc9meVzGDWT713PnF6hG7mAYJvyy59wTzPFkHGkNcEQQoMgIAQTWB4/
qqDyeRRF3Yk7OpZnLDfIJXNPxVLYh1Y4QKy3kiYVW+/bL6kiFE9tzZJ5apUzCfIA
Sw5a2+HDTP5O5SPFH5neX2mseeSr2bAMgh0akdJyPwp8NR/H+3FL4wyszf13krdZ
/wXCp6YpDukDZHvXOeaJt806DJf9o1T41KNcNq2kVmD2cQKvdo2w5mKVxdLSV3NB
1afDrcEAcvw53xPALnH+xjho7my/V99HheumnmYKovEeNWL/yI/tflRpMyQhZZT5
yOL1nKWjQFbsr8fxQqjIchfOxZO1lfhWUSB3v9HcdmzRdsiaFNuofOxLtapaGj+U
TSIrrnHfUQvG6hrVuJtesUOgWYnGDpEbd6aGgB1VvwQuZBDKBWyUkt5VqBkdwhJL
ad6GrBgMVHr9Q2k7S+v6
=tzwT
-----END PGP SIGNATURE-----

--=-IvVxCMUeN9fIU+2vTAHM--

