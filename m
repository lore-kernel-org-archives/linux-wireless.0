Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbXLRMuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 07:50:40 -0500
Subject: Re: [patch 3/9] mac80211: Add PID controller based rate control
	algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197925731.7505.17.camel@localhost> (sfid-20071217_210923_640348_00234834)
References: <20071217012517.882216322@gmx.de> >
	 <20071217012550.127484236@gmx.de> >
	 (sfid-20071217_012722_935905_F6E718EA)  <1197892210.4885.21.camel@johannes.berg>
	 <1197925731.7505.17.camel@localhost> (sfid-20071217_210923_640348_00234834)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4JAXPKhVi+bM5Aysw/ut"
Date: Tue, 18 Dec 2007 13:50:29 +0100
Message-Id: <1197982229.4885.126.camel@johannes.berg> (sfid-20071218_125043_933470_57EB3107)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4JAXPKhVi+bM5Aysw/ut
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > As far as I know all compilers the kernel can use will do an arithmetic
> > right shift if the data type is signed.
>=20
> Where is your information from?=20

Just empirically :)

> I actually had some misbehaviour that
> was fixed after I introduced this. I'll check the assembly gcc produces
> to shed some light on this.

Ok. I like the macro that stefano introduced better than inlining this
code and I can live with that. I know gcc can emit arithmetic right
shifts.

johannes

--=-4JAXPKhVi+bM5Aysw/ut
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2fCFKVg1VMiehFYAQJNGxAAlnH23JiVSeCey0vO5tyl3cyeCrraWMRg
fbpd3EXdrJ7uahcwARPyDIz0BG0mkkL7SOJ8MD4AiSxFWtn/14HOd7ct9AgHQ5hw
BaCl1lYM/tjBxdJpOmmms6OPPsofWy+H+oXY1RpVInG346PzSSA3r4k1ve3HpRcq
VOFwyWkHcUjYR25gYsBZfQzvXGv3Rj791WCUhnxdmdwM0VEREIlBLr7K0zYtm8B5
XHrBTyyFg8+N4V8IqWAAuQN+pYMBgah/t6yOPF1f7Wdti+toSi83/AXlrQNU7WoX
0e+TTpkyWymM/bRv2K2Iix7QVsYPr4drptQVAuas6ji+82Xq4cqf8SIMnsXwVz02
ncaxDOZj040CtiRla0xndllDLDP1bWfNu6yfXEoIsreI8l2Y7gwTK2vmzzxDJ7wr
sahOLMsOGGCL5sPX6+d/jtVmQdXLFRjPiX04L3hLZQ6q56OCx49uUrPJjTvh1QPe
eyqGtk6dprwlzeRaxlsdmGujgUoW/W8WKPsVTmQMMqwvlqxOs151oL9mraOerpd8
fdYgV4JujoOCJJiZQeRkWobDjXEz76AspkDm47UYTaOuwjZ7SBJKEo5uN4SHW0Eq
t8LMbCWbhNNhK/Ot2z2PYUCuqSLt0edY0Q/yKUb/0JU0bMjLZhhtiY5fM9TyYNWn
YR1kOWEH7E8=
=iSwz
-----END PGP SIGNATURE-----

--=-4JAXPKhVi+bM5Aysw/ut--

