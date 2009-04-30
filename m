Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39200 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbZD3KFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 06:05:44 -0400
Subject: Re: rt73usb Access point status
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Correia <luis.f.correia@gmail.com>
Cc: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>,
	linux-wireless@vger.kernel.org
In-Reply-To: <efe7343f0904300258u7d29ff3cu9ca8ea3b3038ebab@mail.gmail.com> (sfid-20090430_115816_491036_20248F26)
References: <wfbpqkvlm0.fsf@calligramme.charmers>
	 <wfzldytr8l.fsf@calligramme.charmers>
	 <efe7343f0904300251q4650d17nb062cc28b011580d@mail.gmail.com>
	 <efe7343f0904300258u7d29ff3cu9ca8ea3b3038ebab@mail.gmail.com>
	 (sfid-20090430_115816_491036_20248F26)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2XbiM7vx+Lk3JxH9BPUG"
Date: Thu, 30 Apr 2009 12:05:10 +0200
Message-Id: <1241085910.27613.16.camel@johannes.local> (sfid-20090430_120548_435169_4CA54321)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2XbiM7vx+Lk3JxH9BPUG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The solution they have found is not optimal, b ut works in their scenario=
.
>=20
> You will need to modify hostapd, according to this blog post:
> http://eznemegy.blog.hu/2008/12/14/using_rt2x00_wireless_driver_with_host=
apd

Based on that information, I have removed the "Yes (under development)"
note from the driver page since it doesn't really support it... In fact,
I'm surprised it works even with that hack since hostapd usually polls
the station with nullfunc frames and waits for an ack.

johannes

--=-2XbiM7vx+Lk3JxH9BPUG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+XfSAAoJEKVg1VMiehFYxWoQAMTUbUMMwbbo7w7XurJAD7OH
Sh4mqqowde2e4etA5VPWmRkjpJSbKFyUgDSKtjunSKGwyeq8bNYQNapNrCdzDB+E
/QyNHte9trfY3uXqH2/g+5o7yqm6MJKN2U4ZgTqD/MfP+6hPwuU6l1HlS0kkWI0W
mE2Ym5eNseNpB655NVQbWQtqKL9fVqzjQSbfYenDHRww/IKUCVY0TM7yAup9kUpz
QgyJ308NYhePU/Qu5YPo/DEWOuJLGEh2wuatxzS/BnzZg/JS7rNvKDWKdOtiAXi8
tPPsNn9BV0SVeqOUlow+C51XKkqEyZ0NUQTzvdHyqgHt9opiDbfeD740fAUOfvyu
29oFlq77Aa4sJfbuX3zvKCLfWMSFnUhLE3zZ023GcUHqcKpbL3WmkCM4pgZVnoAA
SjZ85LGelvN4AvO8l6KNmVAM+SkfrNgzQ4CVCHjLOj0iASclVeY5o6n/j/Q5VCQX
jH3qox0LWSIijENX+3e6QwcDCPuabZ6oEZg0R6YhGq2Oj3LDIjcOVmAW+gUog2bN
R1FcU85EQZlY2pf9GWADSodu1OZgttbYkZPJF40cd/iJuVce/ClXY1LIkLg4mZ0l
9uy2Bl/PoxVW4jAiz9Jpnb43awjIrXC+2LZ2wLIwebwzwmq4Ui+Eq8Gd+KD/JdJA
Bfcq3w9Lfte7/8O4bs7O
=F4kT
-----END PGP SIGNATURE-----

--=-2XbiM7vx+Lk3JxH9BPUG--

