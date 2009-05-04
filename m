Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53861 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbZEDSKs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 14:10:48 -0400
Subject: Re: [PATCH] add support for showing power constraint IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241457795.2903.32.camel@localhost.localdomain>
References: <1241453167-3720-1-git-send-email-marcel@holtmann.org>
	 <1241453408.8683.53.camel@johannes.local>
	 <1241454909.2903.17.camel@localhost.localdomain>
	 <1241455125.8683.60.camel@johannes.local>
	 <1241455848.2903.18.camel@localhost.localdomain>
	 <1241456088.8683.62.camel@johannes.local>
	 <1241457795.2903.32.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9u2aQ0DIDpash7LMeJWh"
Date: Mon, 04 May 2009 20:10:18 +0200
Message-Id: <1241460618.8683.89.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9u2aQ0DIDpash7LMeJWh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 10:23 -0700, Marcel Holtmann wrote:

> one other thing that comes to my mind is to have a convenient "iw scan"
> alias to just trigger scanning all all interfaces. The "dev wlan0" thing
> is driving my crazy. And most people just have one card only anyway.

That would be hell to coordinate with all the waiting and stuff...

> Do we really need the "dev" versus "phy" details here. I guess they are
> needed in case someone renames "wlan0" to "phy0" by accident, but
> personally I prefer that the "dev" one is optional and it falls back to
> just use the interface name.

Personally, I'd rather have bash completion ;) And it's not so simple I
think.

johannes

--=-9u2aQ0DIDpash7LMeJWh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/y+IAAoJEKVg1VMiehFYh0wQAIe+XiMwqwW8yNfniZg9cxQA
a7Aoq3m22OwR9fOLjFAJ8vekQjNV4yLzGLSv2PR362cfYBNg69mzvKn4faIJbBS6
kn3Rlu11H4RzWr2yxZcOEKZtk7xR4jyZ1zdgomXb41KvQKYdzhyNojsFy0jyZwkC
WttHXtcsAHHeWcE1DlSJOKeK1BEb5i7xBPOWnbbo7semtriLBNsrl1CTLpsvFzJ4
QMp38mUJ+3I9Az4+IBOzpI3crrMlT98TxuoGkeJD24hAikHMmTGxM7TiBH0xX2UX
oJcPGzCfRgIUf0/F113f+n3mphD0BUcYcmmXvLJ1idd6bT1+MBslZBz/xK8mnvHm
t9RcK9eYqTpYYN7wgcDAjv9LqB2lpKXXPAXWSN4uq0mcRgKxV6B6vS+ysl3CB3RD
NtJcbF2fCOQG6XAlBfuyTi7EOM2pdX93aOLNhOHjyDSFoB0gjThQRShJ+G6/7Ypd
a7W40ddi81cCvapbcZxxlow8QfvGUHbS8opU9dr7+03xF77LR3aUjBLQ2ehpNM9w
keYSXnaHm5o75IH3PBS5+ce9YGgW0lqNF3HwxkVsah9j7QGsOoyEBXVftT/Sasno
SLMFvGJPNxTIK59qHcLOkiUOht9IhG9vYZ5MrAnLzsCLw5m8Xi4oVdnM2lGN4Kkd
HgSNqaZx5isNj6UYFDY0
=nxFF
-----END PGP SIGNATURE-----

--=-9u2aQ0DIDpash7LMeJWh--

