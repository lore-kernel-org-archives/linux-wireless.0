Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50683 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbZCZIy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 04:54:57 -0400
Subject: Re: wireless powersaving (in NM?)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>, Jouni Malinen <j@w1.fi>
In-Reply-To: <43e72e890903260139k29d9e9a0ub418cdfbaef03418@mail.gmail.com> (sfid-20090326_093918_011896_56866168)
References: <1237891149.4320.73.camel@johannes.local>
	 <1237910398.9082.7.camel@localhost.localdomain>
	 <1237979070.4320.156.camel@johannes.local>
	 <1237995072.18896.9.camel@localhost.localdomain>
	 <1237996137.4320.161.camel@johannes.local>
	 <43e72e890903260100w75896d0fi9121f227cc7ca8dc@mail.gmail.com>
	 <1238055060.4331.1.camel@johannes.local>
	 <43e72e890903260139k29d9e9a0ub418cdfbaef03418@mail.gmail.com>
	 (sfid-20090326_093918_011896_56866168)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qbbx1pLMY3Oegggk0vBp"
Date: Thu, 26 Mar 2009 09:54:21 +0100
Message-Id: <1238057661.4331.16.camel@johannes.local> (sfid-20090326_095517_535881_28019CD0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qbbx1pLMY3Oegggk0vBp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-26 at 01:39 -0700, Luis R. Rodriguez wrote:

> > We talked about that briefly yesterday -- it's not very easy to
> > determine this because of the various ways things break:
> >
> >  * one AP sets the broadcast/multicast bit one beacon too late (after
> >   having already sent the frames)
> >  * one AP doesn't buffer frames at all
> >  * one AP doesn't respond to PS-poll frames
>=20
> It sounds like all 3 things can be tested for.

Yes, but how complicated does it get, and is it worth it to invest that
much work for these (hopefully few) ancient APs?

johannes

--=-qbbx1pLMY3Oegggk0vBp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJy0K6AAoJEKVg1VMiehFYcvoQAJ7hc4N92JRIUjOVZILq6zXr
kLa0iHl0UiDBqdj+1wB0UBC+GsRItZhHEGg0y6p1gbPg+U7WTQq1Hf3q9z2YtdgP
q672ZDbUIl+Qg3cdODzNhRxEHGQMNxRGpg1rs+BnGrj/4uD/AhdDzMbOj4Xy1Xmk
PkrnHDAXuiWe8/6i5c6MyWB1J+mKuMdxHEnQxltMWDy/bWCKhUx/pI65tZHheuFN
W7VzfBd/Wc/5sAitkTiX/rUFyBb/k8ydbgefY+Pnpsx9tnYFNhG90Z8LP9SkTHqp
SCtRZd4QgfomJpb/AqoGaZggeuVHbf0P3UbjKPdvgrOqNmS9QeCIxz1U5XFQzHSe
IrU9pxxjnwwKCFACRJRwwrexlTx6lFl78e9TdvM+V4iuNpuLsbIuPOykuIIuJh5n
3ifENYwG4e0uGCbSZvtef2ahUvHUjjINdfLzPUr5dmAnTSzk1/6fmdazmV0KemlP
YFKuh2I8gMGOFiTx/t0He2XbeB/woy1Htrc7Ynb/iqMgxukW6ABNPKZwpzAjPCfm
Ns4Au5v9VMkyunseILKvrD7sxZttg+oZhWH35r63Ky2SOdYwR7AHo3zWrkb8dqjB
ND9M7G4ycZQedrJcO6P3ToHux8yBEh1jRJ8ZYlG0YYOU2fApYIepm8jxbPaDZf1t
8Bi3m5M9ub4uWx+tiKQG
=s5Vo
-----END PGP SIGNATURE-----

--=-qbbx1pLMY3Oegggk0vBp--

