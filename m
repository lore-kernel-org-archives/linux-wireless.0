Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51401 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYFBQzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 12:55:36 -0400
Subject: Re: [PATCH 2/2] mac80211: removing shadowed sband
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1212421452-5635-2-git-send-email-tomas.winkler@intel.com>
References: <1212421452-5635-1-git-send-email-tomas.winkler@intel.com>
	 <1212421452-5635-2-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2Bom/ueYhqdMljgFJfYu"
Date: Mon, 02 Jun 2008 18:54:50 +0200
Message-Id: <1212425690.20021.2.camel@johannes.berg> (sfid-20080602_185540_391653_A660EC66)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2Bom/ueYhqdMljgFJfYu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-02 at 18:44 +0300, Tomas Winkler wrote:
> This patch removes doubly defined sband variable
=20
>  	if ((info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) ||
>  	    (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)) {
> -		struct ieee80211_supported_band *sband;
>  		struct ieee80211_rate *rate;
>  		s8 baserate =3D -1;
>  		int idx;

I guess we can remove the double assignment too since it's the same as
already done. I must have added that when doing the mechanical tx rate
idx changes. :/

johannes

--=-2Bom/ueYhqdMljgFJfYu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEQl2aVg1VMiehFYAQI6hBAArhbwBqYFWmO5Mq9/9Kn+k9OW38hd8eI+
tt3ZzJyGSzyttjzT78OZrqYad/57v2P+0IP5/iDROysyaC3RsWQD4OR9uxQ7senm
1x/Q9ezm6f/imZauFv6FkURVO2g106pCcgDxYYIYiupl5OOdjVAM1Bevz9dI//Ld
mHOS5+hBm6yWWSTIIcBMyeDVY9Hrny3Xp9EdxWcU2hCpZtyQJTiAFLltxDBQrbCm
GfW8+C9h+S9Vzfh3HkQKY/YmBcBILNwxOZch1od3O/m19pvIqtN6hkZvgHBN759N
Y+1xCQ6CZQU7+NVQWxMC6+cq5K+Eyiw2JLkzQCYDiHYyPdAXMKcX8nwmCNo5ufJ2
4a7Yoy8Q3VIQ99BZkwKNB8gcrnJNJEQY8HMlxVX1rDV37mGv3MV50qdnv6UHztqg
4xfbNPaPWcf1xuGGTfFj70o8w5zz8e35MPNQ7r75+c/prFzE8DVH2CX8iGnicFtl
/ANHV82iPR0uSMhyax1kw/8H58g4Nfcni5xzDwcq/EMX6DRwhvVpVRhjcxH9kOuG
B3wL9k3WHm4YBxh7ublULbgQJBicPqEm4WnNwhgJ2TOmsYrhmINuECUBIlHkV/Wh
aShui1HinFuyRPOOv7t/KhHt+7QtAwsPk+ErADHGGTCOFJqcuzxFqOUeNFDVVhNR
HJSi0hYESSM=
=Uvl0
-----END PGP SIGNATURE-----

--=-2Bom/ueYhqdMljgFJfYu--

