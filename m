Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43907 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYL2KtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 05:49:13 -0500
Subject: Re: subdirs under drivers/net/wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081229101138.GA15022@infradead.org> (sfid-20081229_111142_550654_AFAD09B2)
References: <20081229101138.GA15022@infradead.org>
	 (sfid-20081229_111142_550654_AFAD09B2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6xU42IbDT+P7VDDeP0pS"
Date: Mon, 29 Dec 2008 11:49:35 +0100
Message-Id: <1230547775.3116.6.camel@johannes> (sfid-20081229_114938_310960_3882389B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6xU42IbDT+P7VDDeP0pS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-29 at 05:11 -0500, Christoph Hellwig wrote:
> It looks like most multi-file drivers moved into subdirs in current git.
>=20
> Any reason wavelan didn't get the same treatment?  Or do you plan to
> kill that driver because it seems mostly dead..

Nobody cared enough to do it, it'd probably be a good idea regardless.
But those drivers that did get the treatment are, afaik, those that are
actively maintained, and not just sticking around for historic reasons.

johannes

--=-6xU42IbDT+P7VDDeP0pS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJWKs9AAoJEKVg1VMiehFYxngQAJ9yhe0L0LJJcFwOeDQwyMgT
iBjKcgL8dFul/6wpcPTgG8REJj49ikVOEoQj/e0LOtve6+BPyO30H2cx2gvHViFX
ozwRy/1pmwAYz63eqXC+cR75AohoS9J5APcrAQtpHPaHXp3/rPUjael1GPqJK1Oa
4lrpoq1PcEmdGSlOkaW75kJNXmgrJjjcHQZ8LefN/471C1uXYFQ08CRHSTEG6t+o
0v9ogQ7aKqkfzO07vp1Es31Rs4INO1BR8gvogMTQ8ctalX6gHC3L/307z17RZSTM
S5VbctJqlbX67U0lYub809DBtV33EINuS2cfFlPOkv7btOD+LdCKbyYGVi5XLW/U
dDjGGXSTTwlmsVgPyGEz80G0/c0+D3e+ITkEzqS7JBz/ifj3CGNJ6pIxnIQGpBw9
RcpjkjVAFYoT3HtfMsWHNDZmIKeMMrHLdDqrr62YIozg8nAlZSi0Jll/oTkbi3MR
lCDfjb1J0Wqi9HSLGNxWFZR20ectVtNHsqTrIE5ubboirhCJd6VhUrwHcyQptEKY
1CvABxaqxRKsS/GU6DDzxLIJOuzL/5dmYodj7pJwN9tLJXrUDi0dQIF+cR1jC1MZ
uLRvjZo+p9sf4br3Fm682HKWBW7uOc7y+5nnnJrfuf0DngsLOR4dgIMwLjWsaX+h
KIthPTjrT0pZTjxLn2xl
=RA2l
-----END PGP SIGNATURE-----

--=-6xU42IbDT+P7VDDeP0pS--

