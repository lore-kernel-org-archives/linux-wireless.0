Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33571 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbXH3L5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 07:57:01 -0400
Subject: Re: mac80211 AP mode powersaving problems?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <873ay2v279.fsf@nokia.com>
References: <1186990509.27916.38.camel@johannes.berg>
	 <87lkccf30m.fsf@tikku.osso.net> <1187270479.5141.44.camel@johannes.berg>
	 <87643f4kkh.fsf@nokia.com> <1187275344.23489.6.camel@johannes.berg>
	 <871wdphsus.fsf@nokia.com> <1188290911.7837.65.camel@johannes.berg>
	 <87absbsz5f.fsf@nokia.com> <1188299159.7837.96.camel@johannes.berg>
	 <87sl63prsg.fsf@nokia.com> <1188317935.7837.106.camel@johannes.berg>
	 <878x7v8rcm.fsf@nokia.com> <1188326593.7837.118.camel@johannes.berg>
	 <87fy2355yy.fsf@nokia.com> <1188376637.7837.149.camel@johannes.berg>
	 <873ay2v279.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ay3wW47XhPBpii6JKJst"
Date: Thu, 30 Aug 2007 13:56:47 +0200
Message-Id: <1188475007.2963.11.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ay3wW47XhPBpii6JKJst
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-29 at 17:35 +0300, Kalle Valo wrote:

> I tested your multicast stuff and it worked. Do you still want me to
> test with QoS disabled in N800?

No. But please test the little patch I gave you that should clear out
the QoS header properly.


> > Yes, the odd thing however is that it replies to these mangled packets.
> > I would guess that's a bug in the QoS implementation on the N800.
>=20
> Good point. I'll look into that.

Thanks.

johannes

--=-ay3wW47XhPBpii6JKJst
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1rB//ETPhpq3jKURAmPrAJ95YPCvmnDRpjRa6RTJG3W1FDWfuQCggRUI
K9kvVSlFRthbW9YRjGcF678=
=kNvH
-----END PGP SIGNATURE-----

--=-ay3wW47XhPBpii6JKJst--

