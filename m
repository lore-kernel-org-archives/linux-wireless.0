Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZHCUDm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 16:03:42 -0400
Subject: Re: [PATCH 4/5] mwl8k: prevent crash in ->configure_filter() if no
 interface was added
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nico@cam.org
In-Reply-To: <20090803195857.GK18639@mail.wantstofly.org>
References: <20090803195857.GK18639@mail.wantstofly.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XickxLhOFOnH+IqCkBY5"
Date: Mon, 03 Aug 2009 22:03:10 +0200
Message-Id: <1249329790.4561.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XickxLhOFOnH+IqCkBY5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-03 at 21:58 +0200, Lennert Buytenhek wrote:

>  	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
>  		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
>  			rc =3D mwl8k_cmd_set_pre_scan(hw);
>  		else {
> -			mv_vif =3D MWL8K_VIF(priv->vif);
> -			rc =3D mwl8k_cmd_set_post_scan(hw, mv_vif->bssid);

Btw, there are pre- and post-scan hooks now.

johannes

--=-XickxLhOFOnH+IqCkBY5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKd0J6AAoJEODzc/N7+Qma3LMP/RbdJvgp2IyPYJx4875lmGdi
+xPanCrVBtfM/ro9gLT10GXjDykbvlz3n/D5aeeNg0bgHpV7UEl17/BHm0nb+odZ
+nvoIzrROJlcim9TdrCoCR887z6AVTOdIe6QL6D8z43pwiwZ+19Y/gspoeIDsN9/
YtQ8w0UHOrVEUjCqV/UdtMlTuJN1L7iIu7ngvXr0a0Es5EY95LXrznNzuUt8FCyJ
9fxQllnX55arzDDwemuO8XvuWXqtUcskyPvlYk97JyWHAmbWGgK9P2Otz53ZYOPO
3SwBDSIOmb1zm+Lny2QysBemKu0C4Kiq1BEhQpVw/95T1jnL+KKtgt891CTHetCs
8hsuIRt+rylnNySf/RP12ffzXhhIbxTBnTx4Eu9+yAx2sUksKJuwEGNcWZfLN6jV
FyC76n3vJu186CMSuTTFol3nvqaIdd1v/tAPlYqr4SUHIDOMmYQWRTNpOHg11Be/
TMuzh/iovs26DPLGbLCT4He4BmZTkSKCqvaodk1Ao6Mhv78+ZBOC50OUyLUpvm8L
cF6wvoR5PyLJMc2koO3lzreh/u9eTd0zN5aWDikD9j2ZMJKVvZOnWXcGuj3h5TSU
vughQWaqflSoKnwVqOtmt30WzdwRAjBfXpey8/uhz4cOMsqVU0GHDBgxZNqSDob/
h6REt/7/5CrajYsoZ60B
=W7VF
-----END PGP SIGNATURE-----

--=-XickxLhOFOnH+IqCkBY5--

