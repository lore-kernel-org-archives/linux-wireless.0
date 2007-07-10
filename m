Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46249 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbXGJOu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 10:50:59 -0400
Subject: Re: [PATCH 00/14] major mac80211 restructuring/cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070710162912.17899683@logostar.upir.cz>
References: <20070621221603.778432000@sipsolutions.net>
	 <20070710153456.471e395e@logostar.upir.cz>
	 <1184075439.15565.11.camel@johannes.berg>
	 <20070710162912.17899683@logostar.upir.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hUrUcHZBtd50icd181CD"
Date: Tue, 10 Jul 2007 16:51:18 +0200
Message-Id: <1184079079.15565.13.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hUrUcHZBtd50icd181CD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-07-10 at 16:29 +0200, Jiri Benc wrote:

> But even if it can be applied upstream, it doesn't solve anything. Imagin=
e
> a patch which was merged into wireless-dev before this restructuring and
> which is not upstream. Merging it upstream would mean taking the patch fr=
om
> wireless-dev git and manually modifying it to fit a new structure. And we
> have a bunch of such patches which should go to 2.6.24 (yes, I really
> mean .24). Perhaps I'm lazy, but I'd like to avoid that. It's going to be=
 a
> lot of unpleasant work even without this...

Which all goes to say that pushing mac80211 for .22 was too fast.

joahnnes

--=-hUrUcHZBtd50icd181CD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGk5zm/ETPhpq3jKURAox/AKCsldD0TQKUzG2+660NdBq7Gfpm1gCcCGP1
ZmwQSDZehCgucU+NTharUwI=
=cL7Z
-----END PGP SIGNATURE-----

--=-hUrUcHZBtd50icd181CD--

