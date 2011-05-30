Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57094 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516Ab1E3Vem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 17:34:42 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Chaoming Li <chaoming_li@realsil.com.cn>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mike McCormack <mikem@ring3k.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-CR3xGLoCZkKVlu4bYBOF"
Date: Mon, 30 May 2011 22:34:31 +0100
Message-ID: <1306791271.4277.39.camel@localhost> (sfid-20110530_233445_941591_34CD9BDB)
Mime-Version: 1.0
Subject: rtl8192se replacing rtl8192e?
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CR3xGLoCZkKVlu4bYBOF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm happy to see rtl8192se in Linux 3.0-rc1.  I noticed that it claims
PCI device ID 10ec:8192, which is already claimed by staging driver
rtl8192e.  Is it intended to replace that driver, or are there two
different devices with that ID which they will distinguish in their
probe functions?

If is intended to replace rtl8192e, shouldn't it also claim these device
IDs?

	/* Corega */
	{ PCI_DEVICE(0x07aa, 0x0044) },
	{ PCI_DEVICE(0x07aa, 0x0047) },

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-CR3xGLoCZkKVlu4bYBOF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATeQNZ+e/yOyVhhEJAQrS1RAAt4aHZP72Nw+Tk6s1z9HYfvUDPMpYjcz2
zkAyTGmNedxZtwmcQwbMS3YvQX7bkwI+31mYoBlQWc1Fl/PzLOE/apgnC3g8DRk9
n+ySBW0rWzq8n0ogyasmFAzWZA22PEAfgsjuA6bHegCyR7xinqLy7kdrulbp5VyJ
mBZsCudL0DkFPcMEpH0eMjdaT/o+eNK8Y8ZEhUUEoFd9hTKlrM9+np6Xq+1vaGcU
qUDxCqtVvs5xicanLLzQDV9J9tzz3s9KclddKJYJwfKJqhm6HBK9tAjaj2/++RIO
sylURHZeU2QK+Rdl9Hpo7CqY0h4yc1T/LCI0zEh75wHVUENp/GC/JIu2buRSUY4y
tVpppdoG2ZWgudwpKtZ8F2t+sx9tbhgDEYlbcn0yvcWcrOOZUfQJXZryUv9O20Ja
IpndCLl3bg2P1a50PUruFzgKVZDOcPEkrk3l+Dtef71atOZQXQlFSIjSswWUAD3r
dEH7NFqYMfQVeAU1kPG4jgtU1LVsTUaKu90zWhkBsUhSg7+ATHDQwnxsbcY5HnCc
sNIby2NyXBUwHAc0iEmsUipt/RIYRDoUAA0vmmJ05x56pXf0V8qfxVGGv5pFqpGH
rAExSJF5mVQ2EEVMkGBPeXTTCj1m+xR0VizZMGzia6rgPLjITPzBpoP3Bmpp0opk
yfaPegCF22k=
=X9PI
-----END PGP SIGNATURE-----

--=-CR3xGLoCZkKVlu4bYBOF--
