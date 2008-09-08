Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45505 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYIHOWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 10:22:16 -0400
Subject: HT action frame code
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BBVUpiZ69EYm1NG8V+Xz"
Date: Mon, 08 Sep 2008 16:22:10 +0200
Message-Id: <1220883730.31304.60.camel@johannes.berg> (sfid-20080908_162220_292297_C9AF0D87)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BBVUpiZ69EYm1NG8V+Xz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I've been rearranging code a bit to make mlme.c more readable (putting
things into ht.c and scan.c in the process) and am now a bit surprised
to see the action frame handling done for STA mode only.

When we're an AP, shouldn't we also in some way honour the block-ack
action frames? Or will that be done in hostapd, which then sets up
block-ack via some unspecified way?

johannes

--=-BBVUpiZ69EYm1NG8V+Xz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxTUOAAoJEKVg1VMiehFY0CcP/3yNjJcas4Z1juCArJG3EN8X
BnO4Ij2SiP7rzH4MSYp31AoKFdK0WQElvq8XCC0BAGkDJB3Bm9t2oce4MhtGPatz
ivzh4YsTdPZuIoArUvySZtnqTcaKUF7DnldcTVJE55r1RI2XTDIY0klY8DQpXGzk
p7HmkbnM+xwGsazgS49L1D36E7jXDDms5DDaJnc8632Ih7WQFxpk3WuM9M75nNLK
YtuUTfz7latHMumvvJWrudQVo3bu74KV6VjfYoFSDjzRB9Q7Rpf91yMphU47Yekd
1QWd1Eaha9LyyBKmBFBzn+Zac5QndRoVDtPprN1X/LqpHic8N8o0bC28qwD+K4QG
mggUp8dLZ3tyk+dIQFezhBP3uBdCy/zhAYm8o05NUZR6p01WOjymJTmS4k7beBv2
GnnFf3uae/cQuNCZYOdHEIIXYuqnlv71elW87wq3a4VbkR6yJYA9gMkUILH23QVy
8WMRZj5q6RiX3fkUhs+uwXBdW3vXhpPbqN607RbZxjJu6Dj1OpRho1Bq5I6laPEt
LMkLXadwo0HH1egTMlXGgyi5C/eKy28Qcrf/7ZdSeh5JE6FjH8qEBLyf34b+NZTD
JYB/XZ5dCJBwBqqq5iGdPsvmDlhQ3IY+L9//wsWwihT820jMCJhH+jrcXiH+JfVV
r3ZwPXtbfqPZ8Ik++749
=d4Bv
-----END PGP SIGNATURE-----

--=-BBVUpiZ69EYm1NG8V+Xz--

