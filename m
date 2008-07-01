Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40953 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbYGAIFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 04:05:34 -0400
Subject: Re: [PATCH 1/1] mac80211: fix warning: unused variable ifsta
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1214898291-6232-3-git-send-email-tomas.winkler@intel.com>
References: <1214898291-6232-1-git-send-email-tomas.winkler@intel.com>
	 <1214898291-6232-2-git-send-email-tomas.winkler@intel.com>
	 <1214898291-6232-3-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MrT4c4ihii9HTIimrlh+"
Date: Tue, 01 Jul 2008 10:04:50 +0200
Message-Id: <1214899490.7763.11.camel@johannes.berg> (sfid-20080701_100540_278813_42140A12)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MrT4c4ihii9HTIimrlh+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-01 at 10:44 +0300, Tomas Winkler wrote:
> This patch fixes warning unused variable ifsta
> when compiling without CONFIG_MAC80211_VERBOSE_DEBUG

Thanks.

> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/mlme.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 4fc843e..283e55f 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -366,8 +366,10 @@ static u32 ieee80211_handle_protect_preamb(struct ie=
ee80211_sub_if_data *sdata,
>  					   bool use_short_preamble)
>  {
>  	struct ieee80211_bss_conf *bss_conf =3D &sdata->bss_conf;
> +#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
>  	struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
>  	DECLARE_MAC_BUF(mac);
> +#endif
>  	u32 changed =3D 0;
> =20
>  	if (use_protection !=3D bss_conf->use_cts_prot) {

--=-MrT4c4ihii9HTIimrlh+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIaeUeAAoJEKVg1VMiehFY8MQQAMCT21fH9TWnKVA1luusSAhq
WlX6F/G6BkoCjfo6ST2sQxbO53xwnMOLya61F22xA8EMFUsaaZATwvzpuChnYBeP
zDCP9gFmRsSMKcjgxpN4MNj5fnOxbmFvRT/G2tpaFC5V7eDdIuEDKNDS2f/TnMgB
Ts9FCXk33B3ouLDRFpckRNecePYYMeNr6YpjVWB3mq/snPYSe2VK+5B/Ra1FT/zj
9JNxM2ne0n7g+s8P8Hg1LujPbBWlsXil1V+sYjlQD39y8ZQKp9V2A0STwvMzwXmU
CEQeA2gp22egQWMWazNNQrrtF5EKYeso94bTwK3n7ExiwrEDsT6NF8rRNa33mfpf
OIVHCMsH/T0HnVxk2pH9nhLe896ieG4bra2oXvPFyeHs8pyclvQscqa9ya45m7s/
nB1ZbSsyAjg12jqiUZ1YRNI00xeMd2NbJ5O86iF83hiJdH8uYtKtF8iLgExbRmvs
9OZDfbOEypTT1sJumM0xRlxjrV9uELWoyjFpDlwFIO7vmdbiHrHGLLkgfdzF699t
BSHR4jv6oAcnvqVpey4lu9XN5uo7NKS88d69yT8PNztmHGMD4SXluMTirt4Tjh1w
ASFtxMHhs9jK/ufCm7Jnf/wEb3a2itKu3jdn95fc/q7Kmt95cEGK2JLdCgXMpF5J
Uo6cs+HpFGhZvKCfauIc
=LtN2
-----END PGP SIGNATURE-----

--=-MrT4c4ihii9HTIimrlh+--

