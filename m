Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZGIRsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 13:48:20 -0400
Subject: Re: nl80211 and wext interoperability
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1247159625.28654.30.camel@mj>
References: <1247139797.2144.27.camel@johannes.local>
	 <1247159625.28654.30.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hYfd8OSh/pdLE57dSHEY"
Date: Thu, 09 Jul 2009 19:48:16 +0200
Message-Id: <1247161696.22527.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hYfd8OSh/pdLE57dSHEY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-09 at 13:13 -0400, Pavel Roskin wrote:

> I think using random data is a problem by itself.  Are we exposing
> random pieces of kernel memory in probe requests?  That's bad.

You misunderstood. wpa_supplicant _explicitly_ tells us it _wants_ to
use that 32-byte random SSID. It's just like it telling us it wants to
use the ssid "foobar" or "Pavel's House" or ... I don't see what we can
do, other than actually take it seriously and at least attempt to
connect to that network.

johannes

--=-hYfd8OSh/pdLE57dSHEY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKVi1dAAoJEODzc/N7+QmafzkP/AxYvAK+DIoaQ239fFCaBek7
hKN39SAX3d4+2WLjVsBpa70ay6U86BDj+kGMxMaZDHC0OGUPUL6YydGM28r4fe5n
40Fw+9oPEbMzdxOLV2zRs938TRFMBIZxJS6yacXcjupjzGV9e9iT+gsWGw2t0Xgu
EMRTNXZHjaBJzdoi4NoKJWWf2dBnXI73yf1JN5KnBEEGzjIQ+yQv83Ri1KZ5NBTG
V9YrDgn6QdBSs3k8OD0zlwYImCCkz+RHZPl5kiZl1ZS7XeM4vIBhYMbc2fx67pu0
q4/L5UqcGtY+1qTFhkzRoS/a2p/hcrCbv4ZtVV751PBF2ZDb1CXG5XRYZpH9t7i1
wJSWbgx7oDC2NAiPtiEX7xqaDmqUTx6uR4vgjZQrfF6spu3OGjXL9oyiz+7L26BG
Wh487eGIL/QuEjZox6KZ6Bf0ei5scaBligcMsriwYDeg1iG6niCmMeqqJXCwKMof
aMKhrCOKbx2ecTvBPRoVRW9xwN9+w3e6pBxVerYMTyXWGhQtEQEGQ5COPR/QZaPs
6HgDVHhAD7U33cNlkVCaAhZc5myeJYD5m2JwvOtN4W1WsutbfQrcNkP85rchlk4z
6mHlJdFoD3rQ71wlPQhXmVTLlqSt/FGF3xlFdxR90qN1B6DlzN2PMQP5WqsA8PqK
DUTbtBuCZMLvdZ6p5Ach
=EmR0
-----END PGP SIGNATURE-----

--=-hYfd8OSh/pdLE57dSHEY--

