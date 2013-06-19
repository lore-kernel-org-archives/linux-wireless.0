Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gw90.de ([188.40.100.199]:55780 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935191Ab3FSWlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 18:41:24 -0400
Received: from e178069037.adsl.alicedsl.de ([85.178.69.37] helo=[192.168.2.49])
	by mail.gw90.de with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <paulepanter@users.sourceforge.net>)
	id 1UpR49-0004tP-1X
	for linux-wireless@vger.kernel.org; Wed, 19 Jun 2013 22:41:25 +0000
Message-ID: <1371681682.11916.14.camel@mattotaupa> (sfid-20130620_004137_673775_5D7A8F73)
Subject: Ralink RT2870: LED on device does not blink with 3.10-rc6+
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 20 Jun 2013 00:41:22 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-FZrhWJyg9LXDbjnQNiuO"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FZrhWJyg9LXDbjnQNiuO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Linux Wireless folks,


with a self-built Linux 3.10-rc6+

        $ git describe
        v3.10-rc6-84-gc069114

and a TRENDnet TEW624UB USB WLAN device

        $ lsusb -s 001:005
        Bus 001 Device 005: ID 148f:2870 Ralink Technology, Corp. RT2870 Wi=
reless Adapter

everything works fine, *but* in comparison to 3.9.6 the LED on the
device is not working/blinking during traffic.

Do I miss a Kconfig option or is this a regression?


Thanks,

Paul

--=-FZrhWJyg9LXDbjnQNiuO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlHCM5IACgkQPX1aK2wOHViLhwCdEdNcHzN9+WwnzOrwLLN2XYYi
x98An1rDPk/52rMuiRhdMPrxLGbsimXo
=FJZg
-----END PGP SIGNATURE-----

--=-FZrhWJyg9LXDbjnQNiuO--

