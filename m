Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34744 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbYJGQ6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 12:58:46 -0400
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Christoph Hellwig <hch@infradead.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240810070703j471faa30mce3678febf3c20e8@mail.gmail.com> (sfid-20081007_160333_602786_FAD0D1AE)
References: <1223311803.15196.36.camel@johannes.berg>
	 <1ba2fa240810061135t24f2dfbv2a5eb0cd5d9e8cd7@mail.gmail.com>
	 <200810070821.56462.hs4233@mail.mn-solutions.de>
	 <20081007071529.GA5010@infradead.org> <20081007131615.GR3448@tuxdriver.com>
	 <1ba2fa240810070703j471faa30mce3678febf3c20e8@mail.gmail.com>
	 (sfid-20081007_160333_602786_FAD0D1AE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mPLxwSSzqQ9n6OlyGtPc"
Date: Tue, 07 Oct 2008 18:58:44 +0200
Message-Id: <1223398724.7328.45.camel@johannes.berg> (sfid-20081007_185850_915647_41B80E1B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mPLxwSSzqQ9n6OlyGtPc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-07 at 16:03 +0200, Tomas Winkler wrote:

> > Now, can we discuss the patch rather than Johannes' intemperate
> > word choice?
>=20
> With Johannes permissions I will split the patch into chunks first so
> I can take smaller steps second
> it will better fit into patches I have in pipe.

Fine with me, can you adopt the first one too that cleans up the DMA
code? And please keep the 10 pairs -> 20 addresses, it's a lot easier to
understand :)

johannes

--=-mPLxwSSzqQ9n6OlyGtPc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI65VBAAoJEKVg1VMiehFYCfoP/Au4ihnwj718qDy5w15JFYY5
ktvDPMhiN4ALrW4EIer9ODktgndFrYVw+tQS4V+GBQBdh5Zh/7OTrpp4L1CIHTOP
U431yTt96rF5G5uAbqsaQTMml1bHi91gGvO1tOq7OzBH8J3HhA38tkY/IdDIoMVy
ZELdYBYYGoj+pftHy7ip/hKaarU3ht+MsBApoIOGJasbjJdDagd7qucH8PA1fxRh
+VYKNxKeoZJcaNeagEh5DhrBIMKKhP8VuAzQmJ9hte55Y7Gfu/bhcljMiZ6Hhm4B
Bns+3uWaLBDtJmtqzjZhGkyqLhAiSh/ygsWDOEsxyDb8FHTkRqxrnCKJT+4DAhcC
XP/XCHfLtwz9fMgTz8JiqgGS9CHrVKRwy3dpzOGN7MaeH1dv7H2OsuCcstJnXfo6
GJvj3wWzwD1ZVfBZVAqLA3jdtjQbFEM5uUFtVIDKu67lSoJJIku9k0n/XjlEV+F6
XuCdP6InruVJJW1ASXGq0TZ3yzZFE36gYckVggD8I7phewTi9rZ0IOVf74bJ54dj
N7NsN8h2rGjnQAm/d8kniEjFoc/iRRQDZUGiV6ThHxNpeVBmwc/ykfHIIQJcSbS/
H+JtWQnFfoSsv2utM+DNn7VshfIRwfXeXjxhgB5acwUd+yQtmZ8HU5YxxfymZOK9
+ChRhqOdAxlkkaAkyIAp
=uilq
-----END PGP SIGNATURE-----

--=-mPLxwSSzqQ9n6OlyGtPc--

