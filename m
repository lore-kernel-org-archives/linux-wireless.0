Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbXH1Sls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 14:41:48 -0400
Subject: Re: mac80211 AP mode powersaving problems?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <878x7v8rcm.fsf@nokia.com>
References: <1186990509.27916.38.camel@johannes.berg>
	 <87lkccf30m.fsf@tikku.osso.net> <1187270479.5141.44.camel@johannes.berg>
	 <87643f4kkh.fsf@nokia.com> <1187275344.23489.6.camel@johannes.berg>
	 <871wdphsus.fsf@nokia.com> <1188290911.7837.65.camel@johannes.berg>
	 <87absbsz5f.fsf@nokia.com> <1188299159.7837.96.camel@johannes.berg>
	 <87sl63prsg.fsf@nokia.com> <1188317935.7837.106.camel@johannes.berg>
	 <878x7v8rcm.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7pbPhL1p5ev0Ad7yflie"
Date: Tue, 28 Aug 2007 20:43:13 +0200
Message-Id: <1188326593.7837.118.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7pbPhL1p5ev0Ad7yflie
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-28 at 21:08 +0300, Kalle Valo wrote:

> I hope you have time to investigate this, because I really would like
> to have Nokia N800 and 770 working with b43 AP. So if you need more
> testing, just ask.

Can you disable QoS and see if the same weird frames show up again? b43
doesn't really support QoS yet but I don't think that should be causing
such frame corruption.

Interestingly, your N800 seems to pick up the frames correctly since it
did reply to the ping packets... Did you have a capture size limit?

johannes

--=-7pbPhL1p5ev0Ad7yflie
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1GzB/ETPhpq3jKURAghGAJsG5Sa5qxHj6Ob9+qyv197tRhNJhACdEoWQ
pTX6moHv+Qhw/pbggvSJLEY=
=Dytr
-----END PGP SIGNATURE-----

--=-7pbPhL1p5ev0Ad7yflie--

