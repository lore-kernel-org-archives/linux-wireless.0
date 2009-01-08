Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbZAHM7M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 07:59:12 -0500
Subject: Re: [PATCH 4/6] cfg80211: fix typo on message after intersection
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1231379017-28363-5-git-send-email-lrodriguez@atheros.com>
References: <1231379017-28363-1-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-2-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-3-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-4-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-5-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CjQ5CNoAIRyCCKLdJbf4"
Date: Thu, 08 Jan 2009 14:00:09 +0100
Message-Id: <1231419609.3685.6.camel@johannes> (sfid-20090108_135917_258865_E2EF5990)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CjQ5CNoAIRyCCKLdJbf4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 17:43 -0800, Luis R. Rodriguez wrote:
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 10a3b11..3d56a1d 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1205,7 +1205,7 @@ static void print_regdomain(const struct ieee80211_=
regdomain *rd)
>  					"domain intersected: \n");
>  		} else
>  				printk(KERN_INFO "cfg80211: Current regulatory "
> -					"intersected: \n");
> +					"domain intersected: \n");
>  	} else if (is_world_regdom(rd->alpha2))
>  		printk(KERN_INFO "cfg80211: World regulatory "
>  			"domain updated:\n");

--=-CjQ5CNoAIRyCCKLdJbf4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZfjXAAoJEKVg1VMiehFYxI4P/irV2kk03re1rjbNHaivRdhS
irLyHn3G+gmq+FnExDxLOgtC7a10zbAka/LZ84zFtOZGVz5SwoNx6qNrJ+QugkUC
j+ok5k9ANcmFD3Yd2NN3tN5nVtIhpOL4GLIYdrVjADLcOykIcpXI+Ih1iLshbc4V
5TCMTHh4pTLWIcuGUGbt/2SNUwUVBxV0TI3GBacYSBiXeiuXl6sHyHTbPFIaMQxt
5hMkJVJqQtoL0nj5eqhAAJ5G7SbYpI4t3sWdLRqen8XpZQlUnH31G9LZLflB5/2w
KqP361b727huVdP01HGIeKQmniNw1NWZ44dct7Am3OIOrfK3p/R4mqI6/tG21OxD
NeHGkH2Hzz+0tLyOzSwscM106cevRbPTXGVIK7bZpRy9UHdIBHu7EqGEcmwtlfAh
vF/2YtW+SUEIrPJqRkIAblAh8mQqH0jUoRSLoXfTD65QGgOzU/QlVfZg4w3AjHCL
9DoQCv7NFCCd6i033RvN05opVys1C0kEb+AqcX/3Sj56PJuEp0XJJaInK2+RKdzM
Eaah2vOL9VwVpmSqdvW4JARBhhe2zvKWXxGMj4o14CAYVmfFV7dIXCFLxYTHciKb
o1jOBPq7IykNpRvWhGFOnv5ql8dNvw3Gq84pPQOmD7plkZeMAUFuNQr3l0RSZpmN
GlHKdM+ZWo2Giura9cKf
=BRxi
-----END PGP SIGNATURE-----

--=-CjQ5CNoAIRyCCKLdJbf4--

