Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYJUIfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 04:35:53 -0400
Subject: Re: [PATCH] wireless: get rid of pointless request list
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1224577049.27899.103.camel@johannes.berg> (sfid-20081021_101741_281960_2F5ACD69)
References: <1224577049.27899.103.camel@johannes.berg>
	 (sfid-20081021_101741_281960_2F5ACD69)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4MtK4M0LL8aAlLMVQYCg"
Date: Tue, 21 Oct 2008 10:35:48 +0200
Message-Id: <1224578148.27899.105.camel@johannes.berg> (sfid-20081021_103557_300618_9F563CAD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4MtK4M0LL8aAlLMVQYCg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 10:17 +0200, Johannes Berg wrote:
> We really only need to know the last request at each point in time.

This was wrong, will resend, Luis hid side effects within a BUG_ON
(don't ever do that)

johannes

--=-4MtK4M0LL8aAlLMVQYCg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/ZRhAAoJEKVg1VMiehFYOrMP/3Qw1Phx3ASdta7MKeDEehom
rluvBJMc5Ec29wOur/lqC5A7bqAHu/zglgsKbe3M+Ca2mp9sKW4zPnwFlMcAhrsl
o/Ctzdp6ut3goA3M39UpSeej5uutxiNrG8Qh6+mewjk7FqoaHfVr9R5kzOFR+JBI
ueH16OGKtSXiX7nWJns8Z+sNN70l2Jd6L8aBwCY9DmqGpd6nnQDXRs0sxDilhOdD
VDOgk6tcSzbfHFQuYMWrbL29a+1zH7xKhJXdSQ4xQMJhUa4+bIega9Qnxrqx3UAA
Peeq44+ZiGAiSZnoxmA9s5zQQbcrPloO5VUVZWI4noevtgs3tTGdicXpegMYFVZ2
Ei9iJmWkt15DgHF6VN0Wierj7MS/ydrpvwaZsQb4tN0Ihjq4yShCRoMAIZAnnf2U
NVNXe5OLrSCejE/8lDnn5jqT87+IyPooRB2HjuO+1iuE2fiVdFYTNsMQo3Y8974D
5sWzErDDKBNGC8GY4Dt2pRdO1jF+13bmZCK9UlIXrXcB7fVMgMwlfLLH/vBWBSeO
2URhj5is4zR1PLCmL2Q5LUyTHVYoCC6aESDX2Dqkc57RenuIoSrFKxtBPZeS82fv
PNAJURRkcsxMnRBSkd/SkWgkSSfF9LWeRCim9Jb6c6Sqcz+Lf9lc/maa5cZuvsPr
jD3IPiyjuiMMBLm1UGTs
=+p22
-----END PGP SIGNATURE-----

--=-4MtK4M0LL8aAlLMVQYCg--

