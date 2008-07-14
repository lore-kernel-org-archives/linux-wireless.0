Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbYGNMgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 08:36:09 -0400
Subject: Re: [PATCH 1/2] mac80211: pass dtim_period to low level driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-domwe55I6qS3bnZ86WKe"
Date: Mon, 14 Jul 2008 14:36:06 +0200
Message-Id: <1216038966.11189.12.camel@johannes.berg> (sfid-20080714_143613_099009_E40F3353)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-domwe55I6qS3bnZ86WKe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -191,6 +191,7 @@ struct ieee80211_bss_conf {
>  	/* erp related data */
>  	bool use_cts_prot;
>  	bool use_short_preamble;
> +	u8 dtim_period;
>  	u16 beacon_int;
>  	u16 assoc_capability;
>  	u64 timestamp;

Can you add documentation please, especially about the fact that it can
be zero if the network is buggy / IBSS.

johannes

--=-domwe55I6qS3bnZ86WKe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIe0gyAAoJEKVg1VMiehFYoLYP/jw75INfNYpSkOBEF4iw+n2R
9SjQb2hLLx/lv8JRDA445PolvP4403Amv/S10WXr52DstfuNknbX+oW1BHEvHjTV
jUoelGAfOWcllt+xkjCHM6MF+tnuxz0UGgo4qQg2PFWLn4MRTxta2z2iP1+eNzbp
MbYsY6oYCgpFT5GZJ7mQdkLcsqRpW6j8SajnFJIvg9HWfVkc2Av2JuXE4ykXRTk9
TBwLJEr3ubpu9E2rO87ORODHg1sl/O9KmwXprbsIEwuxe8KtHp9S5TaUigMH7dZ+
f7FFY+k4gEBvkN6ioAGOLpcvAjhHd3xRJqdB7TqhiOZ/BDRyqe5f1YZ52m3G284V
c5kWPxQ+DU8Ci32B/DRx9Bkbqr/PkOaarkK/FfEmbwJQH1tlrzh66BIy2Zd8q1Rt
LylV9tZ3ZtvkfzAJacTTxIp06nPb60zm3FKCWosYlhk2cxWSK3Uk08Y/55/N+VM2
qopOwqDf5f+qvHgwus8ZWKUVqRGNCBCI8LvQ4+hiEVNbpYwJRFVe848selnLIh6J
kGCTImnu4LFCGzsL9gl1kqHBaP+UFuk2m9sa7LyoxGkPgMcrzFK1aBEqt4aSFqkb
ZwB+oRmfD6+4bi3u+x7n2F+/0LXvFq6jKm/+LaZ/QMqOPfQZdVRor3iTlgViT5GM
vd59vveJRtRAZVnLp4WU
=CsGj
-----END PGP SIGNATURE-----

--=-domwe55I6qS3bnZ86WKe--

