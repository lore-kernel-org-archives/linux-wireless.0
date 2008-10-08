Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52497 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbYJHH7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 03:59:32 -0400
Subject: Re: [PATCH 2/8] mac80211: remove aggregation status write support
	from debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240810071424s23bdbbb7kbaadf3678cd61a26@mail.gmail.com> (sfid-20081007_232443_514679_922A10B6)
References: <20081007100428.868688000@sipsolutions.net>
	 <20081007100438.773792000@sipsolutions.net>
	 <1ba2fa240810071424s23bdbbb7kbaadf3678cd61a26@mail.gmail.com>
	 (sfid-20081007_232443_514679_922A10B6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eGf06B1E6/4T4UCpdqaT"
Date: Wed, 08 Oct 2008 09:59:32 +0200
Message-Id: <1223452772.3618.20.camel@johannes.berg> (sfid-20081008_095934_628096_E3628EFF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eGf06B1E6/4T4UCpdqaT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-07 at 23:24 +0200, Tomas Winkler wrote:
> On Tue, Oct 7, 2008 at 12:04 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > This code uses static variables and thus cannot be kept.
> NACK
> Need something to debug this stuff

Tough luck. Go write proper support in nl80211 then.

johannes

--=-eGf06B1E6/4T4UCpdqaT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7GhgAAoJEKVg1VMiehFYi8AQALdIQN9Ssf8CBmkavoPCVcJn
+LQVbPH5HAzldyij4AsiPd/WSECjQxXSD9tDbhC95qbqsyA428YISbyTVz0b3ZLF
JbpNHgX1FrJYY4UuoUMm05cT95BiNmQ6FkhWQMLm01hJqvptNFt+yJz++QzUqPdO
AdMCGUXk2dHKeuxaIpig8gLPV+tKz/Y8659UbjBedyBqJNoI/iMBtAri6q4Mtq43
uQdFXKthzCoB1puXrb0Woej4oAMbueIKNUT+fwOn/nG91N7HoF1Xx+mK2MbkyHOa
JmHr5olJjl5+AezgQ8lL4nLPqZqT/Dgbo/yuACcTGs5MssN65BYNUGXuXnXhRDOJ
kHvKMf6JmU/mCzUhuKl9kX9UKT1PGQA90YBXvhTcCctHlxxnHczE3bBsyvWha7zi
RPG9mGXISl5/RBrYp9ELQJ5mTjG7vPqYVAvyHXPu5SL7W8Ts/My+HftOE4FTol2Z
5JUtiGL7kUC43jMGIT3gznbM51H1TxD0ZiIwramPJNF4vslRRo4jdc6vaOZ0sTKB
c272OZQN/VLzW+nNKz6aIuBPJZq2PlolvRUNtlb9s2WQJgL+bCZlOe2ygvpgjooD
L0mITsNDAj4bj7Z/j3uPRv3gyBKyGx6C5dib3vSK91l+Dr1dEydGOkfLmCNjgagO
w4KEWUrKHP0qxP1nVR8I
=HqVO
-----END PGP SIGNATURE-----

--=-eGf06B1E6/4T4UCpdqaT--

