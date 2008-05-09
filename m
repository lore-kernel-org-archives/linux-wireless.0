Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59730 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYEIK1P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2008 06:27:15 -0400
Subject: Re: [PATCH/RFC v2] mac80211: fix association with some APs
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Tomas Winkler <tomasw@gmail.com>, Helmut Schaa <hschaa@suse.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <87ej8bykp9.fsf@nokia.com>
References: <200805081030.57966.hschaa@suse.de>
	 <200805081334.07599.hschaa@suse.de>
	 <1210246602.3547.45.camel@johannes.berg>
	 <1ba2fa240805081445p4fb5e47cvf2743a868c7887ae@mail.gmail.com>
	 <87ej8bykp9.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OJbKS7uFL0Wd0liTJWHn"
Date: Fri, 09 May 2008 12:26:59 +0200
Message-Id: <1210328819.3547.90.camel@johannes.berg> (sfid-20080509_122608_812445_959BCED9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OJbKS7uFL0Wd0liTJWHn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Most probably this isn't the only AP which has a similar bug, so it's
> better to add a workaround anyway. Let's just hope that it doesn't
> create any regressions.

Speaking of which, what about the Nokia AP bug that cx3110x works
around? :)

johannes

--=-OJbKS7uFL0Wd0liTJWHn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCQm8qVg1VMiehFYAQIf3g/9EqoLEzmZbjtONkyIkX0hOkbJ+aKc8I5t
KyCcq1sxFv89D+k3FbYjI68sUJephD4TLHpq12FAJVBRkPTO+Kd1Tmm2MC+pYadu
SiLtvFgoNPSnS+wJGQh5RKKALz6M/WeddQh/mfMuVJQ72QM/Wr6iOD9+GcadfSbS
wHXp1TBftHhDzVWDDbCOZwPn1AEsVghI1nUriz7H379PBCVyC+7jQ0D730Pazd6x
rCZCKewXAjeBTJ8ChI9Q42hOvTHdWdqsDjDds89vG1r/zVz3VYBouQin0coFhdD8
/1VtFvMfTQy6bvqNyJty9BQSJw6QccVpELGSoDCt++HFj1jo2dRRI2iUVxiPGRtq
W6XaiqvgpVtz9GrGZAMlwgVsXOPuyWXolv+B/zJvNXELCYdFSouSNWC6iietPuQz
ylosLfDKqfeCKYOzhycOw38OWE5U2CFPiChZklmNun4RwsEbC8oXXjYtyqcE2GJA
PbE8So8s1ovn9j9vWVmmjAs19YIxVxx50u8EU6J+kIT3i3sDZ11J+iOFBnYkJLZG
Yg5N9yr8a4/NxMpQco2eNqCW03LQyN2cNOzKtb0SY66L+x7m0cQqTD3Y4LfbqBf1
0MgW5YY7YNDABTwLunCJH4gmO+7mAsL1839z0CqNgTbYEqqSxx+eMeASxW9vLy4L
510P09E+jxY=
=0qsq
-----END PGP SIGNATURE-----

--=-OJbKS7uFL0Wd0liTJWHn--

