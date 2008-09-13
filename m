Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbYIMJUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2008 05:20:43 -0400
Subject: Re: The new regulatory code kills my wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221272779.6695.22.camel@californication>
References: <48CAA8D6.1030605@lwfinger.net> <20080912174036.GC6134@tesla>
	 <48CAB90C.5090302@lwfinger.net>  <20080912191919.GA7722@tesla>
	 (sfid-20080912_211933_280898_C5E534CA)  <1221250959.5576.10.camel@johannes.berg>
	 <1221272779.6695.22.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Rjx0ba4uX0mkJ0cyrOZ+"
Date: Sat, 13 Sep 2008 10:33:30 +0200
Message-Id: <1221294810.3700.3.camel@johannes.berg> (sfid-20080913_112046_991546_7D6E8D90)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Rjx0ba4uX0mkJ0cyrOZ+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Marcel,

> I am pretty happy that you caught it, because that was my whole point
> from the discussion we had at OLS. The userspace part might not be in
> place and we must ensure that everything still works as before :)

I thought your point was that you wanted regulatory_hint_regdom(...)
that the driver can use to tell us what the EEPROM regulatory is, which
wouldn't have been affected by this bug :) But anyway, yeah, it's a bug.

johannes

--=-Rjx0ba4uX0mkJ0cyrOZ+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIy3rWAAoJEKVg1VMiehFYgPkP/0CltSEobbELct96QsajCqCr
JnetpmQkN/rSDVuCm5hcG5IDe6p7WGJt6kSzVldbZuRyEksQgXKMTYk/7o1Mw5g6
TfBDf6q2nskVCNMWNKjrmgE8dE+a4foi9qK/noYcBSH2I3iq6ZIQyNEcqcZ0kXcA
tvyOBJkGEIFj6mDjC/zPl0cSISq8aUFVriyQMllngpfFB8Mo/mfpg7P0M84l6lt+
bsGrj3IA6hPWQZRA/jb+wiQh4khnzEMdpf2EiADYNdOI2ymsj0ZapIvpobiXpa4B
D/WID4dvXgKjPRQWZMLUGH/6aHzKqsEPSsWHu7o5AVzRc7QkoI7GkOLQWw3BiXW2
WOtZLr+5bcidak9AAZoWmend1+i7Ugoh+h3CP4U1lL4MCnYr/n0pdR44vUm/yk6r
tFbMiqJq4YAwzx4X2WAVoBIypqIHbnWFcNveCRRMHX2kxHsE6f/Qo85Y3tCHMu73
8YTBcNM5kDphGrWWEAXzM2D/Ron36K3MPxNyaVA11hsu66Z6TT3Sw6XEUXbIATwC
RSEXJcPPC/JwqerjaLhDDvY+ykYSGTKtVjdqpLR4+b2A/04zBJMLHKQNHF/kSxNv
hSY2knNG8+X6W48iSMQPxQd0xV2I8piZn1TH2sSsFejl4B4/TDu4ZGbYU5oRsDBx
ycjOqaIxL6K2x4s7vbIy
=C7rj
-----END PGP SIGNATURE-----

--=-Rjx0ba4uX0mkJ0cyrOZ+--

