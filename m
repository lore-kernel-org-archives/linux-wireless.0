Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu004-omc2s19.hotmail.com ([65.55.111.94]:56358 "EHLO
	BLU004-OMC2S19.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbaJMTex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 15:34:53 -0400
Message-ID: <BLU437-SMTP3548C40225183D5FB08040C3AC0@phx.gbl> (sfid-20141013_213459_509577_3E38FD64)
Date: Mon, 13 Oct 2014 21:26:49 +0200
From: Sir l33tname <l33tname@outlook.com>
MIME-Version: 1.0
To: Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net
CC: linux-wireless@vger.kernel.org
Subject: r8723au module
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hey,


Since r8723au is out I have tried it with every kernel version.
But every time the connection is flaky, it works fine in the beginning
but after ~2 - 5 minutes it stops routing packages get slow, but
it shows all the time connected (on my wlan widget). With 8723au build
from github, none of this problems exist. (Probably because I build
with out Bluetooth?)


Output of modinfo
https://gist.github.com/fliiiix/f32d8be6c7759e318088

Since I have no idea what you need to debug this, please just
ask for what I should try or what output do you like to see.

sincerely yours
l33tname
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUPCd5AAoJEEC9MWTNKh1CixMQAJRAnqOvaV7OL2asK3j98l70
p5siv2AyTarFTJxPt4tlbOFMS8i4Nku0ugFLnVu8oDSqXjFJSMlfZxgxilpqdGAq
84e6z3zckjrhzE0LBQ0TlOgW54fD+Thkmf8t1/K6XqkwbF+B6Ixf56/nUJJpiqI2
zqE+DxaIJSJXJ9VKTqse2iZlWKCp7cGCCo1JUj1xo4yZeGTpo4YY7Mdh+LSfcbzz
X9ycv0kfZ8cvYl/L9oJPVx7f5uxcgd+P1247rZLXjOomq+ShTkaVFxeY8Te+kNP0
KhnMZ08RpFMv2Rt9FNcBHa7GALuvQdNPMQmxyC+mx2PyijrP4jJv8QbRcmgIgxEd
sON8ADc0sewe2ENlW58IGx1RcULYahgL+aaai/ybsqXtvs09qMay1+a1i/HS2HL1
DXN3WgJBQoRcutojxGwwzATQ1T65ySQyZxTdZOqcKm3bKVvuvBG7B8SHwqDwbDSF
qSM0qkgzUd7T6051gX7mmEL97uMFf4l5XpZFjOp+GpLhsS7MXcwCi0Zy6Su1YD2u
tu9NZvtlMORV7ZwQts8wrO/0n/maQ/h9oM9s2awp6Hr85N6BNlu7in0iGg+GjfPA
070bCNadHLn0FfrXd1oMcPIlWACu3NENC3RAUWEdZTs4PUviMEbe51eCUCWqhzc0
2lxkyx9iu4y59OCQ8E5O
=DtYX
-----END PGP SIGNATURE-----
