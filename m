Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60123 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXH1Ikf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 04:40:35 -0400
Subject: Re: [PATCH 05/15] mac80211: remove HW_KEY_IDX_INVALID
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46D2E953.6050202@lwfinger.net>
References: <20070824122705.549190000@sipsolutions.net>
	 <20070824122905.350213000@sipsolutions.net> <46CF327F.4050002@lwfinger.net>
	 <1188212460.7837.1.camel@johannes.berg> <46D2E953.6050202@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ycucH70/pVSG4mks3jFc"
Date: Tue, 28 Aug 2007 10:41:53 +0200
Message-Id: <1188290513.7837.57.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ycucH70/pVSG4mks3jFc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-27 at 10:10 -0500, Larry Finger wrote:

> This fixes b43. It is a bit more difficult to test legacy, but it should =
be the same.

Ok.

> The code in xmit.c for legacy is essentially the same as for b43. It cert=
ainly could be trimmed a=20
> bit since no keys are ever set - routine set_key returns "no support".

Yeah, I figured you'd already gotten rid of that code in which case it
shouldn't have made a difference.

johannes

--=-ycucH70/pVSG4mks3jFc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG09/R/ETPhpq3jKURAkMbAJ43YHv+A2vUIGMg1UopkUUgTPnOWACgjinQ
lAiaN5FeBCJpyJagUNADsT0=
=w925
-----END PGP SIGNATURE-----

--=-ycucH70/pVSG4mks3jFc--

