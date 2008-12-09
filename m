Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51880 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbYLIBFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 20:05:42 -0500
Subject: Re: Userspace tools: Roadmap?
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan E <trg_info@mailhaven.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1228784501.31197.1288992887@webmail.messagingengine.com>
References: <1228692546.8826.1288759933@webmail.messagingengine.com>
	 (sfid-20081208_002919_244971_30E436F9) <1228723993.22164.65.camel@johannes.berg>
	 <1228778295.10662.1288975589@webmail.messagingengine.com>
	 <1228778801.22164.156.camel@johannes.berg>
	 <1228783416.25383.1288982771@webmail.messagingengine.com>
	 <1228783903.22164.166.camel@johannes.berg>
	 <1228784501.31197.1288992887@webmail.messagingengine.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zhyqjLdRMnkF+8bgvrjO"
Date: Tue, 09 Dec 2008 02:05:09 +0100
Message-Id: <1228784709.22164.168.camel@johannes.berg> (sfid-20081209_020544_794491_5C82182A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zhyqjLdRMnkF+8bgvrjO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-08 at 20:01 -0500, Dan E wrote:

> > Strange. But .start also runs, right? Something must be turning up the
> > interface.
>=20
> Eh, no you are right.  It doesn't run.  iwconfig was giving me an error
> message that I mistook for one of my callback printk debugging calls.  I
> jumped to the wrong conclusion.

Heh ok.

> > > An additional question, if I may... Is wlan0 considered a "virtual
> > > interface" or does that term only apply to additional interfaces crea=
ted
> > > with iw?  The whole vif thing has me a little confused.
> >=20
> > Yes, wlan0 is a virtual interface too, the first one.
>=20
> So I should expect the callbacks (e.g. .add_interface and
> .remove_interface) when wlan0 gets created?

Yes. Well, no. You only get those callbacks once the interface is set
UP.

johannes

--=-zhyqjLdRMnkF+8bgvrjO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPcRBAAoJEKVg1VMiehFYk0IP/i2ZNlxRS104XAczDmOsS5p9
/RLhc6Ai4PgL7/irxDPVDrz5Ahuf8WnC2TzdOZyzZJiGO4Tgs+bYSxs7mcuRiVNc
gXosQhy0jfgzFqNo5NhFnw5ahGpE0VhTs11b9Ee9bBLvyLkkDsGl3ncgpDo34QP/
+ga8Ek7rm3Z1t16qZVYN+HgCuao6BR4Bi0C7E6mbjQJUu98PKVLkCNAWUzqgZ1m+
iZMSz9/roOgLQEP5UnQNQ2HInD5pwT4eiRcbOeLKbNoAXtalKJhrcJukmTBzoFzx
o3EDUzJEuDv3WQVs9r3qtcabw+eQEpga731nD/PX3wsvpqjfiBtXVMu1HsXlRwrg
fnB6eGuqtAVgul3uJpzOrK+thh3eKQokMWq1X7jBQJVIKXAe1NKoL+AF57yPtUTU
GI9RRgo9eVcWnuai+1sUgJVoaI1UgEvaA5ZsV4lcBJHdHim+FuCEjrDFpEw2TS5l
hvm5taCSJmBKoRObwz5QCmxahFASdK1KYS6wsow+ZVrqlNoKp6m229/EmwNI77/S
Ve3CCqkcs1pwSYhQuEqy3iFe6tS8KN9JDwcSpG6w4NifjhNm/B5ZhNKfSIrzTYtI
WEOgTfrPqdlTqTwdw8ksmKe8+lYPbO9/LM8prlNrSbjiqe9+I4hWI9uf/6TeGfAc
hDRkaWpaJx57nMQgpy/T
=Cceq
-----END PGP SIGNATURE-----

--=-zhyqjLdRMnkF+8bgvrjO--

