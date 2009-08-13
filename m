Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbZHMTbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:31:06 -0400
Subject: Re: [PATCH] cfg80211: export cfg80211_wext_siwfreq
From: Johannes Berg <johannes@sipsolutions.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20090813173931.5382.67689.stgit@fate.lan>
References: <20090813173931.5382.67689.stgit@fate.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2G0JJVNrCYO77dZazjxZ"
Date: Thu, 13 Aug 2009 21:31:03 +0200
Message-Id: <1250191863.21250.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2G0JJVNrCYO77dZazjxZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-08-13 at 20:39 +0300, Jussi Kivilinna wrote:
> cfg80211_wext_siwfreq() should be exported with EXPORT_SYMBOL_GPL.

Indeed, thanks.

> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
>  net/wireless/wext-compat.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
> index c449174..c12029b 100644
> --- a/net/wireless/wext-compat.c
> +++ b/net/wireless/wext-compat.c
> @@ -771,6 +771,7 @@ int cfg80211_wext_siwfreq(struct net_device *dev,
>  		return err;
>  	}
>  }
> +EXPORT_SYMBOL_GPL(cfg80211_wext_siwfreq);
> =20
>  int cfg80211_wext_giwfreq(struct net_device *dev,
>  			  struct iw_request_info *info,
>=20
>=20


--=-2G0JJVNrCYO77dZazjxZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKhGn0AAoJEODzc/N7+QmaDOsQAKr8JmDiHubKQmPYsfE0w5IO
bHnnH0p7WCeFs0zsg3kwSBrZ1WnpjVZKYT02J1xN6ySTy3ljd6GSyysoYPk0Wo/z
uexQUvnT59BJlKvgDR760Hnth5Om1YW1RKPqQg6SS178JwHWXxAaLxp8b4YpZa8p
Ts6ZinmTsseXL0uoo+6dyTUHSJd22rgstlxUvKBb2apUYNnt2iQxBM2K1xYNRzqs
XYb2Z9+zEPifHoxbVAmD3p6vveQtFZcRnbl8KCQddiTUXUDh7fF4r61yhsYEMmNL
efn657xrZcPzJstGZE6vSnLITs7Jnix+gx+mUNYxaxhyx4pB2CVkucA01TS1p98D
3f2rgTjyWR3GGEMazNJWxVC9D6tNzFwVGQs9tZ8nicf7KmTclaL8H8oVcv8YpG87
X15+ZH3Mf+gTcyRdtlnvoLylKumz8EXrrnnzruwaay8Cv8p8t+sqk4+46VM7/omd
LM07kDgsWFfqKARqswnIIaOUkgc0kEpB/Y6aS33XfkMht7ljrdgxlHviojqqLY+O
uQcDD87TixugRlsIQNxgDJpAZN5Gvr15fHbS6XPPnfgRfZ9qQ6Hpthlevto/ALsb
YB/jdTFeHvKaPvup/YPEw8MG4yeZNxhWsnZJ/npwHKD1ZLiY6qjLO5ibYAPKOQiM
2z57ZYhby4p3Zi/gpIl4
=oFA/
-----END PGP SIGNATURE-----

--=-2G0JJVNrCYO77dZazjxZ--

