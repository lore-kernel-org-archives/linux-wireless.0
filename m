Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbXH2IgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 04:36:09 -0400
Subject: Re: mac80211 AP mode powersaving problems?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <87fy2355yy.fsf@nokia.com>
References: <1186990509.27916.38.camel@johannes.berg>
	 <87lkccf30m.fsf@tikku.osso.net> <1187270479.5141.44.camel@johannes.berg>
	 <87643f4kkh.fsf@nokia.com> <1187275344.23489.6.camel@johannes.berg>
	 <871wdphsus.fsf@nokia.com> <1188290911.7837.65.camel@johannes.berg>
	 <87absbsz5f.fsf@nokia.com> <1188299159.7837.96.camel@johannes.berg>
	 <87sl63prsg.fsf@nokia.com> <1188317935.7837.106.camel@johannes.berg>
	 <878x7v8rcm.fsf@nokia.com> <1188326593.7837.118.camel@johannes.berg>
	 <87fy2355yy.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dgQKwjqnSjuA725IVIZR"
Date: Wed, 29 Aug 2007 10:37:17 +0200
Message-Id: <1188376637.7837.149.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dgQKwjqnSjuA725IVIZR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-29 at 07:18 +0300, Kalle Valo wrote:

> > Can you disable QoS and see if the same weird frames show up again? b43
> > doesn't really support QoS yet but I don't think that should be causing
> > such frame corruption.
>=20
> From b43 or N800?=20

N800, I guess, if possible. But since you didn't do this yet you might
want to try the stuff I sent you first.

> > Interestingly, your N800 seems to pick up the frames correctly since it
> > did reply to the ping packets...=20
>=20
> Yes, N800 managed to receive some ping packets from the laptop

Yes, the odd thing however is that it replies to these mangled packets.
I would guess that's a bug in the QoS implementation on the N800.

johannes

--=-dgQKwjqnSjuA725IVIZR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1TA9/ETPhpq3jKURApelAJ90iO7NPDry+LhSZS1odsUoF+5o2QCghOru
txLaWc2gDDoNcQT7vC/aqoU=
=9SBT
-----END PGP SIGNATURE-----

--=-dgQKwjqnSjuA725IVIZR--

