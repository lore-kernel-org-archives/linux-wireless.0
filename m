Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51481 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbXHTLVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 07:21:46 -0400
Subject: Re: [PATCH 07/20] mac80211: remove unused ioctls (2)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070818040725.GG1415@jm.kir.nu>
References: <20070815144920.135826000@sipsolutions.net>
	 <20070815145044.386019000@sipsolutions.net>
	 <20070818040725.GG1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4WilsKjipoHKOFXQZNrQ"
Date: Mon, 20 Aug 2007 11:13:28 +0200
Message-Id: <1187601208.6090.46.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4WilsKjipoHKOFXQZNrQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-17 at 21:07 -0700, Jouni Malinen wrote:

> Well, maybe so. But again, some are useful for testing (e.g., allow
> broadcast always for continuous TX tests).

Again, a case for debugfs. I've already moved the WPA testing hooks
there previous to this patch series.

> Default WEP only is useful
> for optimizing hwaccel in some multi-SSID cases, but it seemed to have
> already been broken before..

Could have been me, could have been elsewhere, I don't know. However,
it's also undocumented and there's no driver that actually cares. If we
find hardware that requires it I'm all for optimising it, but until then
I don't much see the point. Yes, it'll require some more effort for the
author of that driver, but at least then we'll be sure that it works as
advertised.

johannes

--=-4WilsKjipoHKOFXQZNrQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyVs4/ETPhpq3jKURAkRoAJ9LJbV0ekuUxWRJNSYkT3nZionhogCePq3D
cbmQXKIPuCzdHaPx8M0Z+Cw=
=MU5l
-----END PGP SIGNATURE-----

--=-4WilsKjipoHKOFXQZNrQ--

