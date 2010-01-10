Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46913 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab0AJNqC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 08:46:02 -0500
Subject: Re: [PATCH] mac80211: flush workqueue before calling driver
 ->stop() method
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <201001101443.38872.mb@bu3sch.de>
References: <20100110130752.GG1735@mail.wantstofly.org>
	 <201001101435.26235.mb@bu3sch.de> <1263130839.7773.16.camel@johannes.local>
	 <201001101443.38872.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-RdS7zBJnH2YVqAHY1xM4"
Date: Sun, 10 Jan 2010 14:45:58 +0100
Message-ID: <1263131158.7773.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RdS7zBJnH2YVqAHY1xM4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-01-10 at 14:43 +0100, Michael Buesch wrote:
> On Sunday 10 January 2010 14:40:39 Johannes Berg wrote:
> > See, it's not strictly forbidden to queue work, there's just no
>=20
> Ok, well. Lennert's mail sounded different to me.

Ok. But would you agree with my assertion? I don't see what flushing it
again would buy us since after stop, it doesn't seem to matter when it
gets executed.

johannes

--=-RdS7zBJnH2YVqAHY1xM4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLSdoTAAoJEODzc/N7+QmaN0EQALSjOKtyYwldUczOzREg86yd
TS50ARDyIl+RSCNs5sYuR8/ZiaguYeaMYBqZMhZgEsCkDgi5OMb3IIZ8yO8NqwYz
lMZyHBtrv8KpjS5jg76eNzg86evvLNcHfqskeCYusIvtrANCtTnBLSQBMTBbmlGS
FBOSJ4JkPTJPtx9eLyK34jAIo93WDLbYXQbnhxkXfyAIAhT4yrSa/Itdg0H3E/pg
GUHirwJK5NERdB8l8haU5bkX1uyfYLjBDPci6Cu+fMaM62ZcFjFY+RcEbq+xInsH
aYnYzlexuIgjaCW7zLFEoO/J1Me/SFV43MHNCPbxazdUNqoZVh2X6XpWqUIJurKG
KFW0j4Dh37/2V/DCXuKRcTECu4ECU5a/+Vx+lRFbgZcQMZyAKbQLXx9k1eRJee5m
Ovs2pfkjtWcusjHrGQtLt0/MUglS3bNY++LnMTXbt4vEYYkZEavzy/B5kMbkraag
lI2nYZNp8RxsbTD/he5A9r+gPcKX+noIleNPwu6Qwvam1aViZ/KU793dlnZvA8C9
KGaALfyNscnySZM/AAKqPOJ8B8k0XJiSQFlUfUfcPiKHnH0/iWbllPL/5/JnoZiW
OXsfxR/9BrKhT0T5hzWojyiHUKOUsqklPmIhTlr33LRrnUBjKKmofw3USza7srwj
oGHiPounk6wXHgeHzzQG
=Xpi4
-----END PGP SIGNATURE-----

--=-RdS7zBJnH2YVqAHY1xM4--

