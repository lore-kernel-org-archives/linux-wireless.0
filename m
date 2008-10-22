Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41989 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbYJVTk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 15:40:58 -0400
Subject: Re: [PATCH v2] wireless: fix regdom passing semantics
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20081022123621.GJ6190@tesla>
References: <1224579720.5521.2.camel@johannes.berg>
	 <20081022113751.GD6190@tesla> <1224701263.30459.45.camel@johannes.berg>
	 <1224701394.30459.48.camel@johannes.berg>  <20081022123621.GJ6190@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aBcGfY8zQR0B5jJUBQa3"
Date: Wed, 22 Oct 2008 21:40:51 +0200
Message-Id: <1224704451.30459.67.camel@johannes.berg> (sfid-20081022_214101_818158_4761BFB6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aBcGfY8zQR0B5jJUBQa3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 05:36 -0700, Luis R. Rodriguez wrote:
> On Wed, Oct 22, 2008 at 11:49:54AM -0700, Johannes Berg wrote:
> > The regdom struct is given to the core, so it might as well
> > free it in error conditions
>=20
> > the current documentation for
> > regulatory_hint doesn't note that you need to free it on errors
> > anyway.
>=20
> This last part is not accurate, typo again?

Ahrg. No, thinko. I only saw

- * @rd: a complete regulatory domain provided by the driver. If passed
- *     the driver does not need to worry about freeing it.

not the fine print.

johannes

--=-aBcGfY8zQR0B5jJUBQa3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/4G/AAoJEKVg1VMiehFYW30P/3ggJdspCL7NpFQiWtNu+boz
4E3jPqToVs71eMtRd13axbfRp+osdTc+DoyKjsysGW7/nxNInFPdp31mBQAygIjD
Y6+aKG6Dv7t7w8c0O+GYo0TJpIqQCz6FJX2QXrovqd6ZsG3kAu6sMaV0Vh6hMfkG
wvVajDi2wMv03WPO1N0G4hFK4qQHOyLXf0tGQTv9VtnwyYCvnzXsaDQMmrqQS+jU
WyNn19mLObd+V6HngDuH4WTrfV4L14V+UDjVsr8lH8hAoYqth66LFHfht09ziTKX
lBcTgVZRliRjjKPPrUMu0lSQZegwHLjNXW8xeS/qbnaAVnbWkclHRDLF6Sg34GEi
pTe9W7BjNgrSDVuDJ+NHN6m9Jw6tfe0/lnrk5nVzFQcmPI/SJNmHWVm+g5RCzjH9
uKv2HEQpgLINdkV/CmYHSP7s8wfSZs29Z4QB9MQKe7b3XK9aNI2pPSQgpLPQkbGR
klvchJzDAM9fuG95jgt2A5S/70gFWoAySTnKjYFu3Lsa+aUxfWz2Qne9/3Xi/CBA
vrlD7F9xniolLaNI01Qi/je30+U2FdpED0dn271M4RFllV3TY1va/i/2jWJ8bF4E
btLAgo5VBXMO+w9TmYfZ3O6zIYlfaMJ5MArMdhONVr36XHjFKpjDwE6JSTctJccY
1xxNml3O+7YpCrrkHoxC
=ZWcu
-----END PGP SIGNATURE-----

--=-aBcGfY8zQR0B5jJUBQa3--

