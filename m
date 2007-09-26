Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57365 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbXIZHDS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 03:03:18 -0400
Subject: Re: [PATCH] mac80211: fix interface initialisation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890709251702q27bbfa5eoe65a626ced383dd6@mail.gmail.com>
References: <200709252206.57855.mb@bu3sch.de>
	 <1190755892.18521.330.camel@johannes.berg>
	 <43e72e890709251702q27bbfa5eoe65a626ced383dd6@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BYDV+YcDAxvxpwbA6ru7"
Date: Wed, 26 Sep 2007 09:04:25 +0200
Message-Id: <1190790265.18521.334.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BYDV+YcDAxvxpwbA6ru7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-25 at 20:02 -0400, Luis R. Rodriguez wrote:

> What still uses ieee80211_if_add_mgmt()? I don't see anything using
> it. Also, did we decide on what to do with IEEE80211_IF_TYPE_MGMT?

We don't have a replacement for hostapd yet.

johannes

--=-BYDV+YcDAxvxpwbA6ru7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG+gR5/ETPhpq3jKURAm29AJ9qxPQbxIMIeRL5ZO3YIKR0xbRWgwCdEX7m
jyC/IQetLzHUbInEJfhH0DU=
=5M7P
-----END PGP SIGNATURE-----

--=-BYDV+YcDAxvxpwbA6ru7--

