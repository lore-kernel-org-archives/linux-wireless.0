Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbZF3OAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 10:00:52 -0400
Subject: Re: [PATCH 8/8 v3] mac80211: re-add HT disabling
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090630135207.GC24667@vasanth-laptop>
References: <20090630115245.675553951@sipsolutions.net>
	 <20090630115303.111250594@sipsolutions.net>
	 <20090630132547.GB24667@vasanth-laptop>
	 <1246369077.16643.10.camel@johannes.local>
	 <20090630135207.GC24667@vasanth-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0E2p6i3cWs3XW0Hxg1bs"
Date: Tue, 30 Jun 2009 16:00:52 +0200
Message-Id: <1246370452.16643.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0E2p6i3cWs3XW0Hxg1bs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-30 at 19:22 +0530, Vasanthakumar Thiagarajan wrote:

> > I thought it was both, but I guess group doesn't actually matter. OTOH,
> > this seems to match the standard better (HT STA is not allowed to use
> > TKIP/WEP)?
>=20
> Section 8.1.5 of 11n draft-8.0 says
> "An HT STA shall not use either of the pairwise cipher suite
> selectors: "Use group cipher suite" or TKIP to communicate
> with another HT STA".
>=20
> That seems to only talk about pairwise, I'm missing something here?.

I probably misremembered, sorry. I'll send an updated patch.

johannes

--=-0E2p6i3cWs3XW0Hxg1bs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKShqQAAoJEODzc/N7+QmaaNAQAKCuE86VFJTVS2pdV00gvlki
4Um76lZ9KOSLIy6SU+/81ygnmH5TPpsfb10q9Xa5txTmlqVEve/H3EauM83/C4fM
l+dceBr1K0j2xJmVjXGdvKGPGF1cH6o+TcXbnyWz6t/wNn659+Plotzy3K0WtM16
/X6P2agtSqNLqR7XzjCcTXFq89oBKhXMNZPQZ1QpeEfkM05bEmpjGy8JdX5h0q8K
I4ayyFk8z/ROc8cPERDK9q0yBNR+UC4X7NZAeKklevvJ4DLBfHQwB1BWzAMJh/WY
pNyL62KgB2bHjFh9hn86oy7BMd2wFOkmbE76d+rqnvyAR5hnOoxoJtoKA3/tXTZ2
52muhoxnzUeWSnZenlTc99ZItcbErz75NRS+gEGKV5cTNqI/EnyiVoZTv4iEhm9J
Mu5z5FqiA8eGHIgV8jdh2GKFDCO16q0Jj7C3dWOEYUcv7Bp0wp4vSbQdCZcYmwOd
81pRGHmP9iXCd2b7IjnM3Sc6uqoew/bvWT9VDTd9efWJ2BIJwf0YsS0tqQCkcP5L
6X7HL34GAapXJBvI2xUmHESG7VIHAQo1zAsmLcFLeABIVF9lqseSRsvVcfdFwT+Z
iOj8r9w1A3H5lnAe+i86flmH7os8Jr9ptbxI1fCQQ2Chgsk6/QRLv8+FNnyYgNJT
EP/42ceTUeG6bc3J7wGj
=zUAm
-----END PGP SIGNATURE-----

--=-0E2p6i3cWs3XW0Hxg1bs--

