Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57588 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033AbYDDOvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 10:51:19 -0400
Subject: Re: mac80211 -- My log files are filling up with: "wlan0: RX
	non-WEP frame, but expected encryption"
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Miles Lane <miles.lane@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080403165255.GI2025@jm.kir.nu>
References: <a44ae5cd0804021732s6ae5ed81ma5e229ae0faf4aaf@mail.gmail.com>
	 <1207226756.3636.66.camel@johannes.berg>
	 <1207231313.3636.100.camel@johannes.berg> <20080403165255.GI2025@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9IF0QjAmHQdQ0oioxsxM"
Date: Fri, 04 Apr 2008 16:51:11 +0200
Message-Id: <1207320671.19189.36.camel@johannes.berg> (sfid-20080404_155123_080883_E193A16A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9IF0QjAmHQdQ0oioxsxM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >     Duration: 44

> What's wrong with the duration field value? The dump here does not
> indicate which transmit rate was used, so I don't know what TX rate the
> ACK would use, but 44 sounds like a reasonable duration value for
> 802.11g rates..

Yes, you're perfectly right, my rough estimate was totally off, I
miscalculated.

> > Does anybody have an explanation for that except that the AP software i=
s
> > messing it up?
>=20
> Looks like an interesting AP behavior to me..

For some values of interesting... :)

> > In any case, I suppose the message in question isn't actually necessary=
.
> > I'll make it depend on verbose debugging maybe.
>=20
> Yes, that sounds reasonable. The AP should not be sending this kind of
> crap, but well, what can you do if it does.. In theory, this could also
> be showing up in multi-SSID configuration when another SSID is
> configured to use unencrypted frames (though, that would cause interop
> issues in association for number of clients..).

That would be ... interesting. But yeah, the message doesn't have much
value, it just tells you your peer might be buggy...

johannes

--=-9IF0QjAmHQdQ0oioxsxM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/ZAXqVg1VMiehFYAQIjDw//WvREJtSnWb+6g1Gg3s7z/+x40Rt3+Z1C
0JFJFiSIOPq4O9OXI2rRau7uL5i3Que1w5FqJycTRPd1oh+8uDuWqA5H5iEdH8d4
EYMEJIBsBU0xgNN3941mDETvL54E140zq1gX1uyVCUwRK0YZ6C8GnmQsyNg/xY6x
3V/veCRVnux44UDcPwlPx2p+iW/p9JtVbnQdkeIXsAiiqTY7/ugy2lq1OZzDUmK6
ZOYrbPwPcD3zs30b+7Ayrk+tVcZHi0elJJbRBU3C9MjaQvBKkDvMVkUwnmRi2/Cf
erqbx6rn4i9rJs107SFuTzJQsfZIdVLFIZilfEFBDUW2TVqnkep5bKt4yQ0CH6Ev
bYmemYunqb5BxG91ngeIU3VN41wg7F/FVF8KX20nhiXUQBO3ib4moAQzGV7Tb2lH
oEnb4Br37Ga7GbaJK6q1G1UB2tj720G5Wab4fH+D7UTIB11vysWzhYtn7BrqgQWS
w/a4ygEaoT/BNarq15D351dAaSiNjYQCjWhhXgQeG9zz0ugGWC4IFCH6UlWm86W0
B8u7SCN1gy6PcIBiLjzOe1yzVhEtTVoFuvHF4DQRTFMACPEc3dU+fBEJ70VJ5xES
r/apCtNrKhjOrl+54fCANOsZWJBsTco48fZHBdRnvKEiw8f1ehk54xuxp8iqxvSo
/H0TQ52zyXg=
=XN8O
-----END PGP SIGNATURE-----

--=-9IF0QjAmHQdQ0oioxsxM--

