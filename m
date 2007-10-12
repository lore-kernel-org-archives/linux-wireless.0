Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbXJLUxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 16:53:31 -0400
Subject: Re: [PATCH] rtl8187: remove NICMAC setting in configure_filters
	callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071012204512.13393.84281.stgit@magic.sourmilk.net> (sfid-20071012_214915_385291_FE84E4EB)
References: <20071012204512.13393.84281.stgit@magic.sourmilk.net>
	 (sfid-20071012_214915_385291_FE84E4EB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-a9tkRK+N61oEfgaIjhs9"
Date: Fri, 12 Oct 2007 22:53:43 +0200
Message-Id: <1192222423.4770.84.camel@johannes.berg> (sfid-20071012_215346_955349_D5A5FA63)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-a9tkRK+N61oEfgaIjhs9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-12 at 16:45 -0400, Michael Wu wrote:
> @@ -602,8 +600,6 @@ static void rtl8187_configure_filter(struct ieee80211=
_hw *dev,
>  	if (mc_count > 0)
>  		priv->rx_conf |=3D RTL818X_RX_CONF_MULTICAST;
> =20
> -	if (priv->rx_conf & RTL818X_RX_CONF_NICMAC)
> -		*total_flags |=3D FIF_PROMISC_IN_BSS;

Does this mean you're always operating promiscuously, or was this a bug?
If the latter, do you not support promisc at all? Or should the FIF flag
always be set?

johannes

--=-a9tkRK+N61oEfgaIjhs9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARw/e1qVg1VMiehFYAQLNpxAAr5AwnXIs8LC4l1Qfq5U//B7FT49kKB8k
ckWBX3kfkFJg0mvMBOApjZlpFX7FrH5X0H9wrquoCbPNaF2SJSjbxf8YOnZK0bLR
55bbuENGfOq0YqL4SOnYsQtiNoPftTGs7RGNTsLyt7XCu6CjYIutkUXKC4LYCG5Z
zQXLYxkWy4naqJZkH0aKd5HFwXVYnKgam1Krm/pTxeEr196jKUpourMZjpiXY6Ol
EGutAsr0Ky/mgWxwfAuOigXxVgJNVSLzVIDTNytiI5G5/yVc6mCglXIJiLNVJDvk
VB7cMkMQ15BfKbp6+sF3zF9LLaOZAnuJLARX6pRCvrs0TzcVumJSubD7ZhqSWGAp
TcNhUYiQ/P6TXMYU4XAeOfpIm9fFa4awcExI3nt5VvHQC9EVmrDgHTNP196zowns
CWXqQPwbizFCUIhgGMHmMUZZMYHUJPFMyAud/9RvDmitm4hex2vBveEVD3dTjPQx
x83fOFagCp5uT18kK0LJBNXzNnGSiln2ZqrlQsPLsfyeQD8+ykz9Uw3qQZT4bQ3B
L0NNthC991Eu+wBbdm5MlEpaQCoxw0naN/uANdL3uOXR5VT5p3xpyozOXTIamdPq
iGKv6OPvVfYUc6czz5UybyLc34TLHSq39BWmUjqdZxnCw4JG+S0G+4a07v6lsL6t
VSoK57trKRo=
=lgqd
-----END PGP SIGNATURE-----

--=-a9tkRK+N61oEfgaIjhs9--

