Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58549 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbXKNPZz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 10:25:55 -0500
Subject: Re: Virtual wireless network card for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Henning Rogge <rogge@fgan.de>, linux-wireless@vger.kernel.org
In-Reply-To: <20071114150839.GA6226@tuxdriver.com> (sfid-20071114_150909_422701_3EF1A531)
References: <200711141316.50393.rogge@fgan.de>
	 <20071114150839.GA6226@tuxdriver.com>
	 (sfid-20071114_150909_422701_3EF1A531)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aDqkIqrSi/6iqgKrK3f7"
Date: Wed, 14 Nov 2007 16:27:11 +0100
Message-Id: <1195054031.4091.22.camel@johannes.berg> (sfid-20071114_152618_681624_383EC639)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aDqkIqrSi/6iqgKrK3f7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> No, but I have been thinking about this as well.  It might be a nice
> capability to have, so long as the regulatory spectre continues to
> discourage some vendors from disclosing information about their
> hardware.  At least such a scenario seems less grey w.r.t. GPL
> compliance.

This could be doable with a shim driver and uio, but you'd need at least
some DMA engine programming etc. in the kernel. But you want that
anyway.

johannes

--=-aDqkIqrSi/6iqgKrK3f7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzsTzqVg1VMiehFYAQLmvg//ZHsX0+iQa8acWo8igEbbSydc3kDJuNZp
MoDBm02Pv1cxSyPtI4ktRHT//x2dmrygUO9425Bd5Xf5UoMWhCYi0W8rL68y/Tjz
aJ2G1HIqQhJ8K5C8/w2y+TKYJ4zChSrSY2l0CnsWCkZPr2VslI/l/fNkFLyno/xV
XFGUce/H1LieWwQCXspU4sweEE8nn2CUBcr61tzKlnJwiMRmQGGaXP7OFh9+c4Mq
QYhd3vlYMuPyalUDYa9JyB3sB9GLyM2EiuMw6Ok0m3nE/kTAuLiJ2Gtp+DYpZL8f
znxjhZT97dW/fN4XvHgvpq7TcMKr/0f7wXBSO27cUofYy0zsNO2vcrsCAu5BhK8W
XfaRfGC9JFVCyrYXSDfbovV9tdyQfTE+Zh7H3vOOEX1qKFG67vrLe6yM/08rDcXI
VCALvMRJYUyGD4m2WORLjS2+wIdJUMUlnpWficLAKP0ikUYGry3H5vzVClr68f/p
vXlCQyT/QcneKb8nR1Cg1ggv5h/DsyBykGQRNceLnijumoBw4+CEuPMsZPUEodFM
8FBBoIA37p7vG6Uxtv+jiQAKt8VNqaGFFAwZhVUBDwI3pmo5M44532P34PPp3uo3
AWaxxl44gKRSSCeA3Eiw5TCXqKL1SE6E/Wb+xgBbsLParkLGcCvjVoeo8qXOV1Uv
E3NNhimGI4Y=
=b03z
-----END PGP SIGNATURE-----

--=-aDqkIqrSi/6iqgKrK3f7--

