Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbZDCJWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 05:22:42 -0400
Subject: Re: [PATCH 1/5] cfg80211: Process regulatory max bandwidth checks
 for HT40
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1238711166-2208-2-git-send-email-lrodriguez@atheros.com>
References: <1238711166-2208-1-git-send-email-lrodriguez@atheros.com>
	 <1238711166-2208-2-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ktyv5rkEP8c7A+2BAzIV"
Date: Fri, 03 Apr 2009 11:22:06 +0200
Message-Id: <1238750526.27712.12.camel@johannes.local> (sfid-20090403_112245_343938_925EF8D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ktyv5rkEP8c7A+2BAzIV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-02 at 18:26 -0400, Luis R. Rodriguez wrote:

>  enum ieee80211_channel_flags {
>  	IEEE80211_CHAN_DISABLED		=3D 1<<0,
> @@ -52,6 +55,7 @@ enum ieee80211_channel_flags {
>  	IEEE80211_CHAN_RADAR		=3D 1<<3,
>  	IEEE80211_CHAN_NO_FAT_ABOVE	=3D 1<<4,
>  	IEEE80211_CHAN_NO_FAT_BELOW	=3D 1<<5,
> +	IEEE80211_CHAN_NO_HT40		=3D 1<<6,
>  };

As we've talked about, just a little work and you can live without this
constant [just for John's benefit]

johannes

--=-Ktyv5rkEP8c7A+2BAzIV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1dU8AAoJEKVg1VMiehFYITIQAJEy/37v+T6OxPNB2e6ade9M
H+unrgPKQhgB2VkBLELXAtUlRLcGYVjUy8H6HtDDKk/pWn9EXUM7ZM6pUJdH1vWp
fYxwRzVS1HSd5tbxj/b5FtccjIg+6lRzPLAwGPYod9kIgRlWP6+LeX6Dv1TxC8C4
0pjfHhvJZ0ZLA3cPhYGmofdj+glKXNayT7KEVrOGX6Yr5ELY93Jm6Zi3S6kSHRDg
BuR+piwUiEQiYuSo6Rhaax/UF2yJ8GoKUhZhBRYrhefPcraAhP1mSwDz47tpYuRY
31o8dLGiETIcdK5qLt5OAhIwdZnvRGNaEdE9AKJ+EjCyau9dmZWnZfFec7HfxSJq
2bRdq+PMK4IcWe7Fp5o1mA4tezuBB3DFDVsD69sL86mxpLtT9fXU8h/1VJXiVYRO
S5TVbGigO2F8z6whXpYMLvwux7+96DfSuzX/Dn2+qHBEZbQZrcYO4HkdSDuXRF2+
7+xTmj5qSSNMODFXvwGiy2DvkOS1cbk5oJ19FiySIeG0xnZY58659g9KJmP/5Gqx
oJC92QvitzxL2A7smfErHI+3incxKCjRSpInVvxEBfv+Bx+uqcA3srpbZglD/6LT
SMfvNpHCUyf39Tp4uBF/QeiIwzmgeo8VboIBVrs83eDdovQy8IC90V+02GFzvgYI
68VUbsRjwxQz5eWwKVUd
=QejH
-----END PGP SIGNATURE-----

--=-Ktyv5rkEP8c7A+2BAzIV--

