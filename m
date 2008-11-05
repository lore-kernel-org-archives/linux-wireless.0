Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33704 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150AbYKET6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 14:58:13 -0500
Subject: Re: [PATCH 6/7] cfg80211: initialize last_request
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890811051153x555cb21fib1f227fb616ad8a5@mail.gmail.com> (sfid-20081105_205325_710681_80EC0FB0)
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-7-git-send-email-lrodriguez@atheros.com>
	 <1225886536.3619.86.camel@johannes.berg>
	 <43e72e890811051153x555cb21fib1f227fb616ad8a5@mail.gmail.com>
	 (sfid-20081105_205325_710681_80EC0FB0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mEHnxe5FJlhWJm3P82yN"
Date: Wed, 05 Nov 2008 20:58:12 +0100
Message-Id: <1225915092.3619.158.camel@johannes.berg> (sfid-20081105_205820_090400_DA374F9A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mEHnxe5FJlhWJm3P82yN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-05 at 11:53 -0800, Luis R. Rodriguez wrote:
> On Wed, Nov 5, 2008 at 4:02 AM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > On Tue, 2008-11-04 at 18:50 -0800, Luis R. Rodriguez wrote:
> >> last_request was not being initialized. By initializing it
> >> we don't fix a bug as we are not checking for it before prior
> >> to a regulatory hint however we may do so at a later time.
> >
> > It's a static variable, it always starts out as NULL, this isn't
> > necessary.
>=20
> You're right but this is not true in userspace, why is this different BTW=
?

TBH, I'm not entirely sure. Must be something about the kernel
initialising memory all around, and userspace not doing that.

johannes

--=-mEHnxe5FJlhWJm3P82yN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEfrRAAoJEKVg1VMiehFYSysQAJgYOVO+9I6rK9XyiQv/PJK4
uMgxnonNbxyU85ciYaZiwcF4JWxKOftF8KUQl3vBdX80vhMTV1HDzCqGpNmg9KOy
aqQUldZy5d71oj08o8uwQG1PTlupE8R89Glr4ZawFbfzVEKoIzEkTV2crut8+IOq
Ck/979ynPWQWrWOOJuc4A/uDoeiKabcMacZun4VAypWfFiKaHcCEzQuHOV8vpg3l
byBcyohV2SrNWDujxpysty1iB4RNhsiWYBgfXC0D9iXVvoXYs+6q0ofuv81q34FV
rhuh6hE1SXFPZInwH7EVOfQ0lfJ6ckzHcbH6PEpgHq64Onqx3BqTUy5IqmQYXrQe
DXr4/SYC6aQBi5EYySE7xSYT+hRcEuKaJcQ1+rM2d+HA1+5hnAvcRRW7QD/Ir0/e
2HwC//CcrzI1UuUYBr5RfCyebich6LshtdVRP6AIdlxgOHV/lZv3m7rrHnrNtQ5f
BPLEwTNBGHR+5IjNiWSBGBAm3g9pHieh2qI3SxKw0K9D0HzQ0Nta+vy9irPzY+mI
89/m1/IkoQxRicPWODDL7l9wUm6SRI7ZQ1rnQkjkBH9PjYmUUYUg77H3ej5cbkWQ
UM9+3h9oUQutvKg0HpVBSEs6DscbJ5pXDpOiR1SknO8OulmBTYx8fS4bN/PHW8t/
5nTV4daWcmP0aRs5ZrOv
=3UBB
-----END PGP SIGNATURE-----

--=-mEHnxe5FJlhWJm3P82yN--

