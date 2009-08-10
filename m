Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbZHJGIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 02:08:05 -0400
Subject: Re: [PATCH] cfg80211: Set WEP ciphers
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1249868558.3967.32.camel@debian>
References: <20090806190439.GA22647@sortiz.org>
	 <1249680982.26088.48.camel@localhost.localdomain>
	 <1249868558.3967.32.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lKMtc/Eo4cDkB75E+32j"
Date: Mon, 10 Aug 2009 08:07:53 +0200
Message-Id: <1249884473.4636.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lKMtc/Eo4cDkB75E+32j
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-10 at 09:42 +0800, Zhu Yi wrote:
> On Sat, 2009-08-08 at 05:36 +0800, Dan Williams wrote:
> > If you're talking about static WEP, then the ciphers are determined by
> > the WEP keys that have been set with iwconfig, and you determine
> > WEP40/WEP104 based on the length of the current WEP TX index.
>=20
> Exactly. But we need to pass this cipher info to the connect API anyway.
> With cfg80211 key rework [1], driver's add_key callback won't be called
> until it is associated. If driver needs the cipher info for association,
> passing it to the connect API is the only choice.

The other question is whether we should actually pass the real keys to
connect() too, at this point, instead of waiting for add_key, but I
haven't really formed an opinion on that.

johannes

--=-lKMtc/Eo4cDkB75E+32j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKf7k1AAoJEODzc/N7+QmapMcP/1Qi9YGz4QKy5BOd1hpbrzzm
fJ+3bKpVCEh34DjuelNX2YTXKMT+pdiIjJjyzWkv/Q1ziUW/BmCmx0jvd/9FWUYI
9EgxUCqHbCWwJ/UvCaXCrO5XdDIeYMaF0bByu5Hl9lCKniSDiNI/3RplthyQjxx/
Rm9E0AxWAvXirxj/y2JKalfRADoAhhdoqGgsYo5fiKLNQPLce2Ql9kKqNUrmSAnU
+hKd0IAFbHVV590QdnS0g15ndr2PIB9uJl2p3tWvkhvILpCQpjMDqDyjTtOXXZqY
AhvtgVkqrm0m2Jkr4aNWaJqYCUvMKjUu0EukS40O9W68S14LBeUA6IlHQYxX3Tsd
RZ606Tdl7ujsupWKWtBpKxa6RJceJzbMyZHLqDKTEcJEu9ICXg3lWw5pEjDdFwFv
DUY4sYT9uc5E4qgjmwDmdWL+JPjvPBA3gNje3KJo78tRvL0G3okHHdwDMPMwfVOJ
6bYU6rhtFNlgPhbYQChfPqSGEOAgFlxQS1FHgXUWLH9YsPXZBXBOudHpxonZDae7
0IQrbnVLFq5Hd2oLRp68q/r8GZBQE8EAEEyxPVNNejKGbz5a9no0tZUm5vzc/uDi
jejzYNAv1Tyz1ewb+Hh09DBNb79qtRIsi62giM8skRjviXjGahkdqE7wHZ4qnluC
SlnrjqdvTlEWogrZl6xF
=kwFH
-----END PGP SIGNATURE-----

--=-lKMtc/Eo4cDkB75E+32j--

