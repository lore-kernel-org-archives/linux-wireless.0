Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52490 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZLRLvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 06:51:47 -0500
Subject: Re: [PATCH] mac80211: remove remaining qual code
From: Johannes Berg <johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1259748910.32171.150.camel@johannes.local>
References: <1259748910.32171.150.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-RsIXCgrXBv6duaKpzPnt"
Date: Fri, 18 Dec 2009 12:51:35 +0100
Message-ID: <1261137095.23178.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RsIXCgrXBv6duaKpzPnt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-12-02 at 11:15 +0100, Johannes Berg wrote:
> This removes the remaining users of the rx status
> 'qual' field and the field itself.

can we get that on track for .33, so that we don't have lots of
deprecation warnings in that kernel?

Alternatively, remove the deprecated annotation for .33?

johannes

--=-RsIXCgrXBv6duaKpzPnt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLK2zDAAoJEODzc/N7+QmaPfQP/2xWJ3KctA4Tn9yXQSatE1Rl
6gdLQqNIwRakxM3EosdiTkACdEhW2/ncKExGu8IAlhXfOztB9HxwJC7CeDgap/1G
EKvWoa6unU9S7O8c5pRBUwBeDUfv2gxKGLbOT7KAVzIcifhC0TtMwe8wTRDc5VPo
xtrG5KPID66p4+tn6vihislavgrcWyo0YPZbAIGmzD36qOTsh9PnFWOywk0vSXu4
uHRsCNqo7WFUN+Q9poAbmmz8uv0jUZi2juDepcDpZGushJDPdbiavrZx48pFf48s
F3QYqgyd/A9AY1CEZQw06cfVYoKHDlLh4+KiRM7PCPFqWmMKUYJZ8YMUjNpVcKaN
JUXNYGsff6PeJzCHQqOLz6MeiQhRNTriWj4Fwj3ueSTwpJrBREs8xKcCtoafxO+S
DqEdv9Eb4GF6GuzXLLkmTTOgJ3+PBzVmPr5eQLcAH7zKe1bdY9Ytki6bCPN80ABM
5QKSlvomJ8VfhcMPhkc9ipQHyCEx5MWMoaZmRPU0skRrNIPPI5FX7vG8HUPlLRdq
wNNm1Vu6FVP7b/OtRNMoWwSjWEItpPZf6OXCHG/+c/jf5AQ2TgNDnHPX31/1HyTm
ZRdXNHr9GiFiEHN8G+xXf2A4+qjxvTJ/yuZ2eU8eEvNr5J+LVzLXSVUezpgaVYeY
FZiS+hz93vMtqyETQ1wE
=9PA6
-----END PGP SIGNATURE-----

--=-RsIXCgrXBv6duaKpzPnt--

