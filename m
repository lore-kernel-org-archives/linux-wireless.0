Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:56490 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945Ab3IMNeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 09:34:17 -0400
To: Prabhunath G <gprabhunath@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	kernelnewbies <kernelnewbies@kernelnewbies.org>
Subject: Re: WEP/WPA/WPA2 implementation in software
In-Reply-To: Your message of "Fri, 13 Sep 2013 17:23:22 +0530."
             <CACPKTAM-mtTS7QVSq817TQ11dS-cLA+nKgXF6yDGYvxw9rhucw@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CACPKTAM-mtTS7QVSq817TQ11dS-cLA+nKgXF6yDGYvxw9rhucw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1379079132_1704P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Date: Fri, 13 Sep 2013 09:32:12 -0400
Message-ID: <119646.1379079132@turing-police.cc.vt.edu> (sfid-20130913_153423_710112_DF3BE198)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--==_Exmh_1379079132_1704P
Content-Type: text/plain; charset=us-ascii

On Fri, 13 Sep 2013 17:23:22 +0530, Prabhunath G said:

>          Suppose there is no hardware support for
> encryption/decryption for Wi-Fi devices

1) Do not use WEP.  It's busted. It's *known* busted.  You transmit
packets for more than a minute or so using WEP, you may as well not
bother with crypto at all.  Yes, it's really that busted.

2) You're much better off spending the $15 to get a wireless card
that actually has hardware WPA2 support on it.  The devices are
cheap, there's no reason to inflict pain on yourself.

I'd not be at all surprised if a card that doesn't have crypto
support isn't *also* lacking other hardware support for WPA/WPA2
So while it may well be *possible* to do it in software, I'd have
to rank it as one of the more masochistic ideas I've heard in a
long time.

--==_Exmh_1379079132_1704P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUjMT3AdmEQWDXROgAQJNVg//S52NXny5ysNI2ZtcZ8/OgBYWGssDO1Vi
33LpAlArd8Y3WzVV23wtphYQQ8hLzDnQtv/WFEKLphxA18UqWaBxH47zGr9ZKfes
UuuG62Z5fbdorRM6yFXZhMJE4mZeUEUwjmDRsCaeCQZ8EWyk/dC93T56iTTC/FVQ
57vj4NRhM47aCnSbnr3XxwhfhPkKrP01CxNBboAlu1ljvLK4Rkz0wZ2k7GFpFyzr
gzXhjd2UiaVRApTZvkc3F8zeIipDufMVb4z2OKWTFmVRI/2erYEkioMNFb4yFnme
0LoxsjafXUghM1Kpuon5UWzpJ0DLRMS1ZnWHlBQjo0B4d2RpIHAxfzsD2way0M93
Q4uymaAPcONP7uRwKQTM7c6rRSYsxX/JhaedioZ72ftlRNXayhc52R1NWw/2WHyG
YgiIkE1S86N1ZWldWRq6J4n+nCXYxGAMHe/H6/DVKhqLE0TC9a2p5EuZXr+Sv/7b
8ErPAG6IlxKfdPlhJnO1GNkyVPrfne5dwKQ9iGDfte4m8a5l0TVkfSNVmM7kTewK
5czum4xfZ2z4xMar/GLnBNYWzh6M6G/hLmUn+l/S/vT7GWgeJHzvnRN1zoa8NmK0
Cb+vZYLXCkGtyl1nVL1nTiO/shuYbrb4cfImYuqXGDmQIjbgC8XgGtlAmb1Zv1B2
1d4z4FyfXM8=
=ywzV
-----END PGP SIGNATURE-----

--==_Exmh_1379079132_1704P--
