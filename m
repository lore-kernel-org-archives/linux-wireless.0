Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38041 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbZDVJjO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 05:39:14 -0400
Subject: Re: [RFC] Simulate medium behavior
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Wagner <wagi@monom.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090422092159.GA24586@toronto053.server4you.de> (sfid-20090422_113107_838388_2485F0AE)
References: <20090422092159.GA24586@toronto053.server4you.de>
	 (sfid-20090422_113107_838388_2485F0AE)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MaV5cNQUyB8hQPnpFbW+"
Date: Wed, 22 Apr 2009 11:38:08 +0200
Message-Id: <1240393088.21756.3.camel@johannes.local> (sfid-20090422_113916_734012_C11E038C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MaV5cNQUyB8hQPnpFbW+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> Writing a 0 to /debug/ieee80211/phy*/hwsim/medium enables rx/tx for
> the specific phy. Writing anything but 0 disables rx/tx.  Not a very
> good API. It could be made something more realistic like reception
> quality is 80% associated some statistical dropping algorithm. Any
> thoughts?
>=20
> Is this the right direction I'm heading to?

This looks like a very simple knob, just a little more work could get
you much further -- have you seen this email/thread?

http://thread.gmane.org/gmane.linux.kernel.wireless.general/25001

johannes

--=-MaV5cNQUyB8hQPnpFbW+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7uV9AAoJEKVg1VMiehFYbuIP/i2SbIgtu9Sn17Cm5oJ18Oj2
/ZGhLk1v3xJ3BQx8SByZO9T3FW7P+kEguVW6B37xGNINZCUK87mEU/J/mtOUHV12
7QtVkoJ+zi+s3xqOXYdtRMfgAdWDN2mLrWEjRCZZ4/AUsfit4SDOqEN8Ne1Y4qHh
t5qdOYcK811UpJA0aAeToyeC/EOL96Azj3yNvzGXYx2P/V9F2XYD0XcLVL3+7ZAk
KWjwYNbfW2ysFPUhvReKE/WjzdQp8lQr7xAHKs+ekagC3ZJ0XUqqSYzbtQjFPLXl
FgxLKuRf9f2o9it198vdZ0scZmHqfxIRQhmAtlnlqwiyNzFpngN90tg9dhTJKD+U
//L/WZfuYWtvDHVwm2Z/a73Y04OoCk8zDZlXzfIM8F+lUTlMylzEZelKcFcn8BeK
MnPwN3yteTwStyfj++8zjSXAGJvpi2SKgGKoBg7Yhwmw+vhepQEXl2lWkcseHJSl
UnHpPnO0OQwS84tgTgVjPgVxx0ISkgQ8tRUris5V0O6/e5Qk448c819oXhdchMew
d6iR3EZ3b2IM/czSFx6G9BhPi/4ifzt4RDF4HY5qBRufXE1euMnMBZmthkFn9Ub/
3RrqsDs1mFGyD2zCuE1dJpfdrkNXDI9hn0DZPT0OX2Z69IAcebLzW4eL7vK4Pt4v
3jzdSkH5YbTuuHnNikIA
=5Mce
-----END PGP SIGNATURE-----

--=-MaV5cNQUyB8hQPnpFbW+--

