Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124AbYD3OHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 10:07:46 -0400
Subject: Re: [RFC/RFT 0/4] mac80211 QoS-related enhancements
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <20080430124055.091382000@sipsolutions.net>
References: <20080430124055.091382000@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jC68af71yrtJ4IzHOuIK"
Date: Wed, 30 Apr 2008 15:07:29 +0200
Message-Id: <1209560849.18659.1.camel@johannes.berg> (sfid-20080430_160742_078417_D2B23C32)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jC68af71yrtJ4IzHOuIK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Any testing of this series is welcome, even just the first patch by itsel=
f
> (especially with drivers other than b43), it doesn't make sense to test w=
ith
> patch 2 and not 3 though, so if you're going to test one by one treat 2/3=
 as
> a set.

I have, of course, tested this series with b43 (and founds dozens of
bugs...) Michael, thanks for your dma overflow injection feature :)

One thing that turned up was that if I enable dma overflow with this
patchset then b43 hardware spews lots of PHY TX errors. I have verified
that the ieee80211_tx_control info is correct, and the frame data is
also fine, so I'm not sure what's up there. Could that be unrelated to
this patch? I haven't tested dma overflow injection w/o this series yet.

johannes

--=-jC68af71yrtJ4IzHOuIK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBhvEKVg1VMiehFYAQJ28Q//U+xPFJRQXl/4lKMTRjYJllzAfjWErc4i
aiEqHamUZ6baPwXJ4YV4cJfgR2QgDMnhwcKOvzWtnJa5ml2RVn6xjo2UqlinEc0+
RqRMvgdQBO1jGYvSnbrRCm7SprrPHRYk8coyz3QiOtHvkUm3yrI8mcCxCLnYLecG
Rb/MOPeTyT4SXyzWPq1oCsftv86jNsn2yuD0j5+6TmKw145bnhKyEeYzqhtbile6
dD92TIvR31fjVgfixSuVxzvxU7WUOmZh5BhRuel0aEn3pzEcVN65Xk7QCL8X+lmm
gVdNpaCxxnW9DpnKDwkcwStoh54LgQRKQN5moOJrjediT5XIisJkw7EehVtVYLh8
Rr7u75C1M2ilmTkq3nWwykHeR36sAh0LxJNuPFrZxeYYLeWy0A14b3TBRbvqOxva
cPYoR6ZFRDuIKzjV0UTTjweyqHxDE2b6CKZvQDVJnMu/4bgnAH9Zu1xceLboKOQm
CKjp/c5R5T/e6Z91yA1SCMFoBd6P50zKxvlOrtQ8yYTelVmD8SPSwmTtmT+LN+Bq
1UAgj2de39kZBFftg+ReA0ooaq4aXPNaNae26bQJjV1GGtQEL7Vs1RxlOs+jB3QX
Vd2Da9XphJWIiHvbikqJgo0T7Ulfq0xvWcEkX1iVamtA27cxdR1rJQ5+TKOU0SlK
NtEBxcQHEVE=
=nbgr
-----END PGP SIGNATURE-----

--=-jC68af71yrtJ4IzHOuIK--

