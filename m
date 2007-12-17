Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47439 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbXLQSIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 13:08:18 -0500
Subject: Re: [PATCH 2/8] mac80211: A-MPDU Rx add MLME structures
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11979070782201-git-send-email-ron.rindjunsky@intel.com>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782201-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mBCrLE+2kEcyJhMwfDXB"
Date: Mon, 17 Dec 2007 19:08:13 +0100
Message-Id: <1197914893.4885.76.camel@johannes.berg> (sfid-20071217_180820_861921_5EB27C36)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mBCrLE+2kEcyJhMwfDXB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	struct sta_ampdu_mlme ampdu_mlme;
> +	int timer_to_tid[STA_TID_NUM];  /* convert timer id to tid */

Since you only use that as an identity mapping it can well be a u8
array. Not that I like the trick used, but I don't see any good way to
avoid it either.

johannes

--=-mBCrLE+2kEcyJhMwfDXB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2a7DKVg1VMiehFYAQKtDg/+PyrFlOzJCqb61wAQmsFd1PRXLFN6Lcu8
cWIUXnQhge/iNTuoEu6QxcQb40HBecs1UxDfLsb3T0F4vt4tbWkv8YzXR85ATBHY
w3Tx5BEFrf9xMyT3d0UzivBFB9SHpsM2bRpKD7Xw43ZHW1VxV747sUTVWGRDV5+M
dDE04RL48AbUQ63qyH4bQR46QmKh53yIR1UBF9VPDCgbeLN1UP+ywYn9jzzcUoqG
47lYBkYG3ufcR35mzAn4LCvbK1VlARCryttP5Ac5eNznNPOV4evHmP4ORbtZLmMg
n/vXGHybrOqT/rhKFr7q90Z8kQ758PhUm042N5E/5wRu5AIY+6Owqe+NoCKCKPiK
WToyfg+f3KTDA2TQavN0DCWjIIbKjSAzJOHdEKs++bhcQjtyhx7hQY6lRScZtI8Z
2HFcl1nGQ59kb/3yi/6OwqxYFDbeilLAjMls9TL+SfuG/PCaIpfg36W6sMFDX7zi
YEbL8hhlcjPCAf2O6wbxEyB0CcAjnryEz7wxd1X/fBdFtMVSDFyFEu93lOBR1/5z
b7SvG3xUnWZ20DWHGcP4YEPvNkwehtv2lNJE0/vnzAbmaidpkOiUnDHW/RlUty/g
lZ7jgKwUGZqFsgL0lMga2z/Gfg+Vt/imOztHTBFi4o/b6q/agIgvxlZtVb+/w0Dm
0NqXQzSkjXg=
=7Xqd
-----END PGP SIGNATURE-----

--=-mBCrLE+2kEcyJhMwfDXB--

