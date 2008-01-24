Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37669 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbYAXOsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 09:48:40 -0500
Subject: Re: [PATCH 02/12] mac80211: A-MPDU Tx add MLME structures
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <12009163392459-git-send-email-ron.rindjunsky@intel.com> (sfid-20080121_115427_748133_32BA5E41)
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
	 <12009163392459-git-send-email-ron.rindjunsky@intel.com>
	 (sfid-20080121_115427_748133_32BA5E41)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IpOkyT6vsXNZ+cwaZVJI"
Date: Thu, 24 Jan 2008 10:29:26 +0100
Message-Id: <1201166966.3454.59.camel@johannes.berg> (sfid-20080124_144856_236060_F72DECFF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IpOkyT6vsXNZ+cwaZVJI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +#define HT_ADDBA_REQUESTED_MSK		BIT(0)
> +#define HT_ADDBA_DRV_READY_MSK		BIT(1)
> +#define HT_ADDBA_RECEIVED_MSK		BIT(2)
>  #define HT_AGG_STATE_REQ_STOP_BA_MSK	BIT(3)
> -
> +#define HT_AGG_STATE_INITIATOR_MSK      BIT(HT_AGG_STATE_INITIATOR_SHIFT=
)
>  #define HT_AGG_STATE_IDLE		(0x0)
>  #define HT_AGG_STATE_OPERATIONAL	(0x7)

I think you should probably change the last there to use the first
three.

johannes

--=-IpOkyT6vsXNZ+cwaZVJI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5hadaVg1VMiehFYAQL2XA//f7Rgj3erkDdPvpjtp3NCrn3wf1fvq6C4
CD4lV+aM/oDUmkH68hxrgC1mplvoMBSJ29W58GQyvvdw5km9yXXNYjPMGF5ZAZj2
+tmTuqc62xieCGpmtPYHNkfScmRJVUjUpXb5UuI5ayVdxDkOwy76eD8jjxX1bnKK
7po4UD/4BZ7Lr5AM35UU0L/whLLuM3Kx6YdsQPjBKFAMwoGOOt8t1OE2RZla+FGJ
emdr8DzOga6H6fMtOpYwM3u47Z3RuZiE4m1dWCaAt0zjR6ZvptuCgLR61BEyDYms
oMK37SDOlQWHN7vcktT4+OPfH7ZqzpmvqfE0hsDZwIcf6wPxZjxoUTWLWZgYatvC
Of1DLBGQy3AsIhauxgw/vhjQCPonhkec+KaZD9ecX4llPGegshID9LuZyzqPx4hr
25WVvDYEk4hamwkKoKxW29BQh9tqD+HW2Ph9ofiUJV7RcgQKJya6rNNMwbluxYda
XMNMEOOo1ku2AzppG1lHuUxpgQ1QtZfutDUync5C70vKSWglgadYsjeADN4MazVt
7mzxXx9O8rhfl+4UVrt131A8+oKkkLGInYSmsuBIpaP14IK1JIKetBRncsmm1dv9
7bmrWS5nvE6OFCx8MSMu91jyeifwgqlw6ciqNDS4TjnLOxO2p7LSxFvRzj71KZMe
3aQWHQZc/1w=
=8RUK
-----END PGP SIGNATURE-----

--=-IpOkyT6vsXNZ+cwaZVJI--

