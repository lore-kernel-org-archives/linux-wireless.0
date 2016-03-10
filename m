Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:42607 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323AbcCJRna (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 12:43:30 -0500
Date: Thu, 10 Mar 2016 18:43:13 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
	Jia-Ju Bai <baijiaju1990@163.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: fix memory leak
Message-ID: <20160310184313.06eb8b91@wiggum> (sfid-20160310_184333_743138_2FA01B89)
In-Reply-To: <56C72FA6.3090102@gmail.com>
References: <1455798876-32186-1-git-send-email-sudipm.mukherjee@gmail.com>
	<20160218173212.03670d97@wiggum>
	<87io1lqh3j.fsf@purkki.adurom.net>
	<56C72FA6.3090102@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/GHQ5gnZ7A.ML5mBfrfA46=F"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/GHQ5gnZ7A.ML5mBfrfA46=F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Feb 2016 20:37:18 +0530
Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:

> > https://patchwork.kernel.org/patch/8049041/ =20
>=20
> I have an old laptop running on 800Mhz CPU. It has "Broadcom BCM4311=20
> [14e4:4311] (rev 01)".
> I will try to test it on this weekend.

Any news on this one?


--=20
Michael

--Sig_/GHQ5gnZ7A.ML5mBfrfA46=F
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW4bIxAAoJEPUyvh2QjYsOqw8P/2IzLNPoxyOPZbUMHk1NB7HR
0okKxsME2S2USPDyZqnRiBbZlJjP4vj26PZ7CkH/XT9YyZqlrWnpIvUZ+fffALoX
zJ0M6+U/ZCU6Ia5uDT/Wi44dw0ULRZExFGMHPfat7um+TdKg8oRtxb3O/H+IV79T
8xoZ8jrudgNwWuCV+2XaHpid56J3+2l/CE94SYenXmwMG0fOVXm5we8exxtGbVTY
Rey4NBfXP5q3eimO9s4kr4nj+5SWxmkrO2zvkyVYyph3AuFZu2LK1uMba+eAXxRa
fXo4nG8TPvepn9qSm8yim7BdDNmUfawjxLd9SO1ddRyuZtW29aqOWzMXUe8WLsFj
Ve/5y6XLvzL3N+FCAkmMeIqBYzKsjg+JuzicPCQqHugoSfutYuT1du9ybj1TJXWI
fjwLnh+toiR4Lr4krPU8Usk+LtwhzsoqhMSn1nrXY8ykYJe97HvQ5neSX748I7Hi
PGRvIZqXpTgtEL5Q5XCzfQnBT3zcBTZ5cUIJnca5yfO1C7e0x/Be/ypZ4Oc2vs9i
5nyyKxOHQFyMfRw5hoziijSbIJTYZp7CapB1TbQhsks5Xx0sIka7uMb+LVD5mFIT
CJkziFngbaG5KWohFrb0VeX1X1ju30Y9b3bWm2ZKET8wcFUToDBLT89BVhvkDnrB
rqReG4HRGX7BSgLLdHNk
=gg9f
-----END PGP SIGNATURE-----

--Sig_/GHQ5gnZ7A.ML5mBfrfA46=F--
