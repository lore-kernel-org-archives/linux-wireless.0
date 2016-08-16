Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:60976 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682AbcHPMIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2016 08:08:10 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: Mike Mu <mikemu@google.com>, linux-wireless@vger.kernel.org,
	Stanley Mui <stanleymui@google.com>,
	Thomas =?ISO-8859-1?Q?H=FChn?= <Thomas.Huehn@dai-labor.de>
Subject: Re: Configuring Minstrel-Blues
Date: Tue, 16 Aug 2016 14:08:03 +0200
Message-ID: <15996481.7X86eO74tG@bentobox> (sfid-20160816_140825_317460_C95990C3)
In-Reply-To: <f32852ed-0fee-1711-e26d-5a41f831267a@dd-wrt.com>
References: <CAGTDyhHOxwTiXtsWuy1cLq+eraikTs9McS0kUBXS2W6B09CwgQ@mail.gmail.com> <f32852ed-0fee-1711-e26d-5a41f831267a@dd-wrt.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2013595.6mZgYOhit1"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2013595.6mZgYOhit1
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, August 15, 2016 11:48:35 PM CEST Sebastian Gottschall wrote:
[...]
> > To test, I ran iperf from the AP to a station very close by. I
> > captured the packets to look at the RSSI with and without the
> > Minstrel-Blues patches applied, but did not see any difference in
> > RSSI.
> 
> why do you think that a rate control algorithm will change the rssi?

https://www.linuxplumbersconf.org/2014/ocw/system/presentations/2439/original/Minstrel-Blues%20@LinuxPlumbers%202014.pdf

Kind regards,
	Sven
--nextPart2013595.6mZgYOhit1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXswIjAAoJEF2HCgfBJntGtFUQAIT9sUpxQexnf19tI7y7pzno
X0w3rQUoAMsOozFXxsmulM3bq1u7datn4sXuC9Q+MSIaGt97UKI3UbNVRLjyZMv9
G5XrT1/zDcg3l5kt0wiVMjHLSwCwbAlzdNierBzevq+0tCDHrp5MEhGf4trpvjcW
OLON64E3HVlPzcYnhz8L1T8Q6YsCutyMFzf5y9BDX/XJ9YSaHMwOSf8yXmeaT0J9
Hre9RocG/eWmdfnTU34aP/KExnYx3f1Zq9RuurkCcIEg3+C4koh8K57CaMrr1NP3
HHMAzujWjDpS1T2tg+DQXymMLflHqUwHOX0eH+jdQ8/Am+/RdE4d3n2yBtcin3On
BPEnxg07CzeYCdpsNY963Y9qTWDn20r1wOptd0pQbtp8WUpLnQB8gTeYUoEdXN3o
+hbA3UO9qHix6MlPVWZJdX17qIPKsl/NzvzJJMUwNxfHihrIwmlDGD51iZ/1wAby
sO6/cWChYXInzPo8yLSCgRXL6RlIbClatDoNwdIy5PVlQRR9DM+o/x0/BYSpYjM+
1SiUurfD2GpPG4yHEt3nD0bOFvL1KEzHUcqqql0zWj3Jf5CDxyjM2qVypvNHrbmO
y5WSgwv1q/TKm4PFMVsR3g+1+E8TTMQM9r2gfbL+1OZlxFav6kdz46CTrOIrNXI0
dYmLzm6jLImOvxphxCdN
=j6lh
-----END PGP SIGNATURE-----

--nextPart2013595.6mZgYOhit1--
