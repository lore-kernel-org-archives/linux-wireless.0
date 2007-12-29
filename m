Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35732 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbXL2MBT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2007 07:01:19 -0500
Subject: Re: Warning emited by 2.6.24-rc6-git5
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: chris2553@googlemail.com, linux-wireless@vger.kernel.org
In-Reply-To: <1198929568.4172.37.camel@johannes.berg> (sfid-20071229_115956_865583_DD21EB42)
References: <200712290942.37396.chris2553@googlemail.com>
	 <200712291121.31120.IvDoorn@gmail.com>
	 <1198924603.4172.34.camel@johannes.berg>
	 <200712291247.54258.IvDoorn@gmail.com>
	 (sfid-20071229_114741_608186_9052827A)  <1198929568.4172.37.camel@johannes.berg>
	 (sfid-20071229_115956_865583_DD21EB42)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9K+BOQr2hT+5B+7H13sY"
Date: Sat, 29 Dec 2007 13:01:07 +0100
Message-Id: <1198929667.4172.39.camel@johannes.berg> (sfid-20071229_120125_097403_869EC8EE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9K+BOQr2hT+5B+7H13sY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2007-12-29 at 12:59 +0100, Johannes Berg wrote:
> > but since the payload should be aligned to a 4 byte boundrary anyway
>=20
> That's not true. The "payload" in terms of "802.11 frame" shouldn't be
> aligned on a four-byte boundary for QoS or 4-addr frames.

Eh, sorry. The start of the 802.11 header must be aligned on a four-byte
boundary for non-QoS/non-WDS/QoS+WDS frames and on +2 mod 4 for QoS/WDS
frames.

johannes

--=-9K+BOQr2hT+5B+7H13sY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3Y3AqVg1VMiehFYAQJSkQ/+NoyqawH46q53ApZ7dlal+jI6NViv2LIo
kXzBJi996U3i8HW9VXuqzxIBmYcLDLE0Gr6NZzzfrru0AVW0nGMp1u3n7BLKQHnW
NHO/f8dgF+UoTfppy3nI1Hd9LW/wLFD9kPgq5JUCSe/tbApxtjIUSw9cAWT2bEH/
2YjJo1J/jBWrICoWC9boi60zOWYz5SutwDV+AP1hUWiEDwIbSalqWbju53b7y+Pb
6LNi5UYtooc1OEHDO/U8LbNNW2elzlCmSOFQz1GhOsBf9OviNz+6kCbusrfuJYxS
1wyEqnlI5KQj2dshxQKx/5RYwSXpzItbizTlCBOobC4oL+Evpybdr8b8KTzy8xUs
CurXOxq0iyvNkH08NJ4ravorBhk0Dueujzboxc0uQPSCkJn8cqO1dLMAwAhDjiQe
r0KjrhPDU6QHL2p1Yzn2kJl54LQ121P6/m2iTNit8quYuG89KTAsDDxuzqnbKyCs
aVYU1LhoCNShxrk/OBXg4uQ6PQmR1xfvJGLSpm/775v8YLjMPlQWr8weymvGCsgA
iezfUGaH22T6webw8fXS7TL/5SWq3RWRtIE2r9VHgUAameWOoFVFT1eFMK5idM/b
moOBqbtW5LmC7mT0dr+Z1atKtEOh5e5/VdTtC6ck4Vynfg5/CzZzwUHc8ON2lBi/
qbCCRbZl3xE=
=6/wz
-----END PGP SIGNATURE-----

--=-9K+BOQr2hT+5B+7H13sY--

