Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56648 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZBKOao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 09:30:44 -0500
Subject: Re: [PATCH] mac80211: Free current bss information in few places
	where we don't need it any more
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090211084310.GE6589@vasanth-laptop>
References: <1233752328-6918-1-git-send-email-vasanth@atheros.com>
	 <1234258903.18748.0.camel@johannes.local>
	 <20090211084310.GE6589@vasanth-laptop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wwnrhteOHsyrNbhmpVz0"
Date: Wed, 11 Feb 2009 15:30:01 +0100
Message-Id: <1234362602.4016.0.camel@johannes.local> (sfid-20090211_153047_844077_7B78D387)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wwnrhteOHsyrNbhmpVz0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-11 at 14:13 +0530, Vasanthakumar Thiagarajan wrote:
> On Tue, Feb 10, 2009 at 03:11:43PM +0530, Johannes Berg wrote:
> > Just a question: was this needed for correctness somehow, or just to
> > purge the BSS list a little?
>=20
> This actually stops choosing the AP to which we were connected and
> received deauth(reason=3Dap moving out)/probe/auth/assoc timeout. By
> removing the bss information, scanning is triggered before selecting=20
> right AP to join upon connection request by setting ssid.

Ok. Good thing I kept the semantics in my cfg80211 scan patches then :)

johannes

--=-wwnrhteOHsyrNbhmpVz0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkuDmAAoJEKVg1VMiehFY668QAIbIKxLVRDyRDpHr8Nz0Pemb
2tZFLGgEHZJC5dnKtnr4Fz/yk1Cdkn4/pzMqFTZxqF1rxBZRGaEwvWwPk+BHy/uA
6MXJm2NvlUKzr8zAhwCNGXAHVybLeIo5vNfcVEs8gPh6UaQBlQ6lE78LhY2rbdrG
QEl/1IHNcnCLEF6BLKjJCtlHGbwyFjHy4XLtFcTm00cm1qol7HE5vYRv/LyZzQ76
C3XCj/TgAEZa7VElCwRC8PNA4hbTnQPksoQW1opI82q2JF7C/evytxJIihRQ0PZI
3SEjfU63UjOQetFbyMMWnW3rdKhC4qZ6SlLS5SClfXts3ZU75Odyy+5AzLqGkeMI
aaOTjmPbT5Zef1X0d9QWU6zA0vk3+JVcGbtLbc3btQhjTj7JXCqfc6l/uja0kixm
KLfl6B7uTMYqEhJCRBRjlckcsE7Q+iSfSsgKV0gV4Au2mguPW9uRcOK0AercVbaS
E+4tijmtgsdkalAQqmTeJc36UhLRa7733oFAqaTHYKRsd+CT57hVLRJiIaen5Kw/
o9YqSN3xjgsTTKgKjdO+3RQ1M3nwrEnuPEXV8kp8AoosV8cQlu2WA1jBcxdCih3C
Uuj05Zbk0eo0avcz+pr6OWQFqe/V3CqndVnPoo1ChDF3wNP15heS8GRUW8YZ8kD/
k2DdYD/bL+r2Ej15Zg+A
=pmPn
-----END PGP SIGNATURE-----

--=-wwnrhteOHsyrNbhmpVz0--

