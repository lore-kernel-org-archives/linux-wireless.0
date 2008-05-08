Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37508 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbYEHVvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 17:51:38 -0400
Subject: Re: [PATCH/RFC v2] mac80211: fix association with some APs
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Helmut Schaa <hschaa@suse.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1ba2fa240805081445p4fb5e47cvf2743a868c7887ae@mail.gmail.com> (sfid-20080508_234453_219240_F85B7872)
References: <200805081030.57966.hschaa@suse.de>
	 <200805081334.07599.hschaa@suse.de>
	 <1210246602.3547.45.camel@johannes.berg>
	 <1ba2fa240805081445p4fb5e47cvf2743a868c7887ae@mail.gmail.com>
	 (sfid-20080508_234453_219240_F85B7872)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TlpzMwc92owsc9UBnoEu"
Date: Thu, 08 May 2008 23:51:24 +0200
Message-Id: <1210283484.3547.73.camel@johannes.berg> (sfid-20080508_235035_569925_CDBCEBD6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TlpzMwc92owsc9UBnoEu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Are we sure there is no  firmware with the fix for this AP?

Even if there is, does it matter? Will everybody install it? It's not
like we're doing something that could cause problems since we announce
the subset that both we and the AP can support.

johannes

--=-TlpzMwc92owsc9UBnoEu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCN126Vg1VMiehFYAQKgFQ//aLGVC3KTfQHfijXPopiBORqyu+4JbLsQ
FQvfqoruaycSJJjznk8Qw73EWZgkev1KVcShK2O11whrovoBbgJWQtZwlKDwSams
wFNBNozWfe4Tn5pe2kU5JX9CA2r8f6Xa0npJz6FIcxRsW5u5bntLKyS3ncadgE0V
Htjb1wmU7MECSZ0CtPsDFEaK6/T6ExDz3x9GFkhHoTHY0Dn4q9SNW/Qb23lgfKJq
yF4bWI50j5qNy/VurzGjxMAURO6URr/LR/dwnP2tCunA/CpSs1CDSEkz+DPAW2Y9
i0a023st1vJrfz0g/AVkyIzoP0X+oZHMwtjIpwulXJjLZqdqz6uYEjTiF8adrAFT
YkwkstiSjRI7IdbP4i8yPxmvA9WUF4WYXaVrXtAHSWMNIrUfxA71pRJV77OzAIN9
v90fV0Dw8Bb+j3uMOQTqqxAZeSKpXb9McK79QFaBQjx5rIuhooxoweZUI1cz6X20
w9xxoYIZYBugS3quv9Hz728pc8snxIupczNEZA6dEQfbpf/5wMVGKymr1WhPCjp8
ZzZmrt7laIs0ZvwwPAUTTImgwNKz7XXX9yvuf/njiUd7wQxf/c6ZyC1bYSbPK8vS
SDcg1urKJjcqfbVdmd9o9d45ru36+417PazW8qvkAoLrRnQ+npvXmwoe/xbZvKLk
FA3lBxanFpE=
=JO70
-----END PGP SIGNATURE-----

--=-TlpzMwc92owsc9UBnoEu--

