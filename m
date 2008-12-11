Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44625 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693AbYLKWIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 17:08:18 -0500
Subject: Re: [PATCH] ath5k : Fix correct padding
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <49418D23.8060905@free.fr> (sfid-20081211_225920_318663_0EE458F5)
References: <49418D23.8060905@free.fr>
	 (sfid-20081211_225920_318663_0EE458F5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9voV1bFFNl7lUueMC2/w"
Date: Thu, 11 Dec 2008 23:07:42 +0100
Message-Id: <1229033262.8081.89.camel@johannes.berg> (sfid-20081211_230821_697170_8725450B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9voV1bFFNl7lUueMC2/w
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-11 at 22:58 +0100, Benoit PAPILLAULT wrote:
> Padding the 802.11 header to a multiple of 4 bytes needs to be done only
> for DATA frames. This fixes a bug where 2 bytes were missing in monitor
> mode for ACK frames.

That's the wrong way around, you're not padding anything, you're
unpadding it.

Your patch is also line-wrapped.

johannes

--=-9voV1bFFNl7lUueMC2/w
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQY8rAAoJEKVg1VMiehFY3LIQAI005UCGVbLk/T8Do20qdxNn
4AzoDi4hTJlUvNPzDANwYAhtbE74a3tM7Mxg5Rr+fIfhulwUETiMR2w3s/iLVOS0
4UNcnQZW9bPwtm8mZR++eb6a/huTJBRBRQ/A3HQQif8dy6gSOqCJuuku6TVAAgBL
2h+EdajBfzIoDiT2dk4r92GVJxsJZUSGyKzTB3RgHltsJnUCcDAuy87AvY5NPJ+L
/De25gBuU9v6sHOzqd6FjTszPOu/fPAnh7HvsJv5CGcNPFfsI9LXI8v/AVq46XKH
amJYn5HUcWOml3XB/KDTRdeF/40FkEf7tefbu6FvZEVGT1RPwRFrZtNBT80k9Y5U
Lh5RmqZafxgP2S/cAQ0yYk4ALohZ44Y/VcW4fNlLonDF1U5DzOQI6U7o+DvXUJP/
05T/vukD7b55nnpT+sxsNGHl8tdw/vGx0hV6B9zloc66EwLYoFKFVaIEQEjorGNL
ZgAxeRbX9HHzjnIg9gKpo9eueuh2tvKto34XE09HoA3t3ODp0/DM4dcmUcW0V/+m
IeL9WApjqjIEpWMYptnj6JIP3EKNjb6b2W8enkkKn7inZ3pLZlcpIIldO8uPvUYu
HmtU0sCLFvxk/dKNYL6noHBK3zbT5hhfRB0AgLvUR8PtHdalMpIz1Rnz+qjjO9EG
FreTchiQHPOjkuNeZ9dM
=8vQ6
-----END PGP SIGNATURE-----

--=-9voV1bFFNl7lUueMC2/w--

