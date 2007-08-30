Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815AbXH3Lzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 07:55:48 -0400
Subject: Re: mac80211 AP mode powersaving problems?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <877inev2bd.fsf@nokia.com>
References: <1186990509.27916.38.camel@johannes.berg>
	 <87lkccf30m.fsf@tikku.osso.net> <1187270479.5141.44.camel@johannes.berg>
	 <87643f4kkh.fsf@nokia.com> <1187275344.23489.6.camel@johannes.berg>
	 <871wdphsus.fsf@nokia.com> <1188290911.7837.65.camel@johannes.berg>
	 <87absbsz5f.fsf@nokia.com> <1188299159.7837.96.camel@johannes.berg>
	 <87sl63prsg.fsf@nokia.com> <1188349109.7837.147.camel@johannes.berg>
	 <877inev2bd.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iTGaw/q7DRACwiWfcqgb"
Date: Thu, 30 Aug 2007 13:55:32 +0200
Message-Id: <1188474932.2963.9.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iTGaw/q7DRACwiWfcqgb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Applied 055-b43-timb-position.patch and 057-b43-mcast.patch to commit
> 0347a7c86f. Multicast is buffered correctly and N800 sees them. Also
> DTIM count and multicast bit are now correct in beacons.

Good. However, it appears that in STA mode we need to enqueue multicast
frames to queue 1 as well, not 4, so the patches aren't exactly correct.

johannes

--=-iTGaw/q7DRACwiWfcqgb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1rA0/ETPhpq3jKURAnEBAJ40Sj8SxA/kArtj6RpJZ958gdGO0ACfSvhJ
UHq5YeyFEGG10MxTyGPS4PU=
=UEpW
-----END PGP SIGNATURE-----

--=-iTGaw/q7DRACwiWfcqgb--

