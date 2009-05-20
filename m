Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jessica.hrz.tu-chemnitz.de ([134.109.132.47]:54702 "EHLO
	jessica.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946AbZETUd5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 16:33:57 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [PATCH 1/3] ath5k: add support for radio LED
Date: Wed, 20 May 2009 22:33:54 +0200
Cc: Jiri Slaby <jirislaby@gmail.com>, linville@tuxdriver.com,
	mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
References: <1242850139-25438-1-git-send-email-jirislaby@gmail.com> <200905202216.43996.tobias.doerffel@gmail.com> <20090520202124.M71221@bobcopeland.com>
In-Reply-To: <20090520202124.M71221@bobcopeland.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3042557.ePcK33gbVB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200905202233.56608.tobias.doerffel@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3042557.ePcK33gbVB
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch, 20. Mai 2009 22:29:42 schrieb Bob Copeland:
> On Wed, 20 May 2009 22:16:42 +0200, Tobias Doerffel wrote
>
> > If there's interest, I'll  prepare a new patch which represents the
> > current state.
>
> I'm definitely interested in seeing rfkill gpio support getting in,
> it's overdue.  So I say repost it and we can fasttrack that.
Should be rebased against wireless-testing branch (with the changed directo=
ry=20
structure), right?

Toby

--nextPart3042557.ePcK33gbVB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoUaTQACgkQHsjdpw2OaafD6ACg2lX1MQ2RfqsQoMMdyUS+Z5q3
HYoAoNun+2WiaoFozF4Zmp/LXE33tOOc
=ENYu
-----END PGP SIGNATURE-----

--nextPart3042557.ePcK33gbVB--
