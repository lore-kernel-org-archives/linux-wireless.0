Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60884 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363AbXFMQNw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 12:13:52 -0400
Subject: Re: [PATCH Try#11 3/4] cfg80211: Radiotap parser
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46701643.3040908@warmcat.com>
References: <20070612130435.896010304@warmcat.com>
	 <20070612130502.157979021@warmcat.com>
	 <200706122242.08045.flamingice@sourmilk.net>
	 <1181749596.29767.82.camel@johannes.berg>  <46701643.3040908@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GcukI61zhx7gMWELOLXD"
Date: Wed, 13 Jun 2007 18:13:56 +0200
Message-Id: <1181751236.29767.92.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GcukI61zhx7gMWELOLXD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-13 at 17:07 +0100, Andy Green wrote:

> Is it useful to report that there were items in the radiotap section
> that were not illegal but were not comprehensible either?  Any app that
> is written against the parser will be using the contempary list of
> constants from ieee80211_radiotap.h, and anything added in there should
> be added to radiotap.c.  Put another way you won't be in any better
> position to understand or handle radiotap args that cfg80211 doesn't
> understand than cfg80211 is itself.  Is there a case where you don't
> want to ignore these unknown later entries that could appear?

Good point, I guess you just want to ignore any new items hoping that
they'll be orthogonal to the ones already there and thus you just don't
handle them. In any case, if we need it we can still change it, so just
leave as-is.

johannes

--=-GcukI61zhx7gMWELOLXD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGcBfD/ETPhpq3jKURAvIJAKCfxrue3zaL5zl90w7jrutdE+UlsgCgmilf
jbUggDgSwr9SB6SR2TzFGe8=
=BYFN
-----END PGP SIGNATURE-----

--=-GcukI61zhx7gMWELOLXD--

