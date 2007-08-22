Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47237 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759861AbXHVNEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 09:04:21 -0400
Subject: Re: [PATCH 1/2] mac80211:  Remove ieee80211_privacy_mismatch
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Volker Braun <vbraun@physics.upenn.edu>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070818034146.GC1415@jm.kir.nu>
References: <1187406018.30247.17.camel@thinkpad>
	 <20070818034146.GC1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xKi0BjpxcrjiYtosgLQj"
Date: Wed, 22 Aug 2007 15:04:15 +0200
Message-Id: <1187787855.4314.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xKi0BjpxcrjiYtosgLQj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-17 at 20:41 -0700, Jouni Malinen wrote:

> I don't know what has happened here, but ieee80211_privacy_mismatch()
> and being able to disable/enable mixed-cell operations was here for
> purpose

Volker, can you try

# iwpriv wlan0 param 1039 1

instead of this patch? Yep, that's the UI for enabling mixed cell as far
as I can tell. Great huh?...

johannes

--=-xKi0BjpxcrjiYtosgLQj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGzDRP/ETPhpq3jKURAqAFAJ4ibWwnlnys1SujqgagQ4ix8tyjCwCfUnHu
NLmQGpPJ30xgft1mHJD90Zc=
=S1pu
-----END PGP SIGNATURE-----

--=-xKi0BjpxcrjiYtosgLQj--

