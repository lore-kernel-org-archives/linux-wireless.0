Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbXHQKMR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 06:12:17 -0400
Subject: Re: [PATCH 14/20] mac80211: kill key_mgmt variable, use  privacy_enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070815145047.834125000@sipsolutions.net>
References: <20070815144920.135826000@sipsolutions.net>
	 <20070815145047.834125000@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-12Sdi8A7LcaCXenHl2Yl"
Date: Fri, 17 Aug 2007 03:09:09 +0200
Message-Id: <1187312949.23489.97.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-12Sdi8A7LcaCXenHl2Yl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 16:49 +0200, Johannes Berg wrote:

> -	if (!ifsta || ifsta->key_mgmt !=3D IEEE80211_KEY_MGMT_NONE)
> +	if (!ifsta || !ifsta->privacy_enabled)
                        ^ be gone!

That privacy_enabled test is inverted.

johannes

--=-12Sdi8A7LcaCXenHl2Yl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxPU1/ETPhpq3jKURApw7AKC2EepUHd+3PsFxe1eXaQOitzXpzwCfW8yx
7upLCkd7oXajdf1Gzsz9nrY=
=qOCJ
-----END PGP SIGNATURE-----

--=-12Sdi8A7LcaCXenHl2Yl--

