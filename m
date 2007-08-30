Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbXH3Lzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 07:55:42 -0400
Subject: Re: mac80211 AP mode powersaving problems?
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Kalle Valo <Kalle.Valo@nokia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <200708291950.04237.mb@bu3sch.de>
References: <1186990509.27916.38.camel@johannes.berg>
	 <1188349109.7837.147.camel@johannes.berg>
	 <1188382312.19891.7.camel@johannes.berg>  <200708291950.04237.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bgd4RzH9NpX+9K90RCKK"
Date: Thu, 30 Aug 2007 13:54:47 +0200
Message-Id: <1188474887.2963.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bgd4RzH9NpX+9K90RCKK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-29 at 19:50 +0200, Michael Buesch wrote:

> Hm, I am wondering why this "more data" thing is needed.
> Driver sets it and fw clears it? So why set it at all?

It only clears it on the last multicast frame, if you read the 802.11
spec it says that it must be set on all others.

johannes

--=-bgd4RzH9NpX+9K90RCKK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1rAH/ETPhpq3jKURAnJeAJ0WLOMM3LWyQO4qdmH5UIxRI/CpigCePn2n
3sfXf+X365LGcRVYMu5+4ls=
=mPKN
-----END PGP SIGNATURE-----

--=-bgd4RzH9NpX+9K90RCKK--

