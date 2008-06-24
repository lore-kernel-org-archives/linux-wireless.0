Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56738 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbYFXI4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 04:56:34 -0400
Subject: Re: [PATCH] mac80211: add pre- and post-scan hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1214149401.8585.2.camel@localhost.localdomain>
References: <1214149401.8585.2.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7gjJjkxcsgxqVsbgHdFk"
Date: Tue, 24 Jun 2008 10:55:45 +0200
Message-Id: <1214297745.8967.255.camel@johannes.berg> (sfid-20080624_105637_951159_3F855BCB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7gjJjkxcsgxqVsbgHdFk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-06-22 at 11:43 -0400, Dan Williams wrote:
> mrv8k has commands that get called before and after the scan has been
> done to save and restore hardware state.  Add optional callbacks to
> mac80211 to enable low-level drivers to know when the stack is about to
> start scanning, and when it's done.

I'm not entirely against this, but does it mean the driver will not work
with the userspace MLME that does scanning itself in userspace too?

johannes

--=-7gjJjkxcsgxqVsbgHdFk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYLaOAAoJEKVg1VMiehFYizEP/2Lk9+wwKZJJuFC123ddqtPM
6MoME02lfDKRTinMcOegWplTAS7yjE41o9m7t0pZ5MSG0HJGJNlSEouI2LwwUqUN
xXtD0tHkLHKugDXFdWKGEk/d1qGa48eGXWD5bquSCyPNYOe1Nzvuh33MwiDMeV83
bTYvW1UEnvV61Gn3u1zN4p4zDw8XYCbY77aCitv4gvmNkJdazWxf+QGdG5feeULK
Mvq6ofFOdwBFNVRwP4w//04qHsWwSxr41/EBa98ATBfmGKNnpXgNq9R50svzvkLo
IFMZtX67/arp2iooScn0DUgvJyVUXZHBoPlS2HLgSj5RMljOFSfpfgjs1rW8eFjS
pdWVBuR/laNLruReSeccGOKeHB80SbF2BxmnWMQai0vlWPSCqsOdCsgO0cN+oj7E
y1tUSplX1Htf6vpWnLuGOOIS4Gc5FucG4ExKghxxRLOdLclUBM6lrR9c/h0ANn3N
YRAQA+/4PgUyMpR4TVpNLHx8OXP/dT7ASR0lafN94vro+6ImJCtUx1yb3FERa+U6
SfL4s50W34469SUpbtHaveeGRpo7AIRe/GfL2dEgc9QWYSZrolXzL2MG4T7hQQSQ
mmR/b/JLqijnY7uziCJNwhcifkfehQCU6Qm43gzgb69UH8vWOIpmmLD4T+rrn26U
FMOJKBRi1bf05XnzvyUq
=y3wV
-----END PGP SIGNATURE-----

--=-7gjJjkxcsgxqVsbgHdFk--

