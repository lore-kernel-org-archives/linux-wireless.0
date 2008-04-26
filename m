Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56725 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758855AbYDZUyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 16:54:52 -0400
Subject: RE: Roaming problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: "'John W. Linville'" <linville@tuxdriver.com>,
	'Dan Williams' <dcbw@redhat.com>,
	'Holger Schurig' <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <00da01c8a631$bfbecce0$0b3ca8c0@gotws1589>
References: <00da01c8a631$bfbecce0$0b3ca8c0@gotws1589>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IsP8SYoYTo7JNamsKQ1K"
Date: Sat, 26 Apr 2008 22:54:15 +0200
Message-Id: <1209243255.10943.63.camel@johannes.berg> (sfid-20080426_225515_007631_90F9383A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IsP8SYoYTo7JNamsKQ1K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> - Driver authenticating with new AP while having a valid association with
> and other AP.

Yes, that is the problem, we should disassociate first. If you can come
up with a patch to send a disassoc packet in that case (and test it,
preferably) that would be much welcome.

johannes

--=-IsP8SYoYTo7JNamsKQ1K
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBOWdqVg1VMiehFYAQKthBAAu4pL2DO2FW4qDovQe23FAepueMYAEpJ8
+U4qPjpWxjTWjv6Nt7ZxqkbMVMF6o79vIBAgI6ApHbSqJLmXGrrnCry2poZG/zLC
ezecwQLp2BMoQ6zwO9QB2nC3RuZd8x4V4dG0bZmcTAZafVJU28VWqpKerduaYfmM
HUuQubk7pPwSBwWmrlAyOTDQPoO07Tp3QB3mgOKpkLhQepWpxdrnAnULeUdIGfRi
jhXJNqgaeivPyt3XvRbAbH1bMPjtYyQTYvMqPnbqKVCcWqMZjsZovQA48lvmfMNR
gjvOx3tLt9xsBlBXd8IF0PAn25U+8NZpb3RSlAyeQ+XbUAk2tCC/b5tPpwneMxNb
92JVALJ4iF8Fj++b8qKiet2+0WaDAelyfUbBmbeRq8g4BU9dGldssujGelP2sOth
aOOIASuflwXOkXkFtX5Bjv81Xu3jKB90IIMnKd64zVhONhKCw2ARmhnprdcyaSfV
Ck0sB/nBHLTxbSQZf8mb45Ks2pg1UAPheuY4jvxRkIxz2Qb2FY6NDB8IF0SpIblH
/gVG7dpIgQZlpISGA+s5KPUfduHR/8jrPNl2LSRergN52+yPiZmXNHYVfhCoU//1
iAYP09oyy2hl+wqSQrVep+rWFnX3uuWsINs2qhYhUhClbIWEq9VEguj7+MDfgIko
359a9qMn2jg=
=7b6F
-----END PGP SIGNATURE-----

--=-IsP8SYoYTo7JNamsKQ1K--

