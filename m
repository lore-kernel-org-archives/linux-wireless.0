Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38198 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459AbZAPJNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:13:40 -0500
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Artur Skawina <art.08.09@gmail.com>,
	Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <496FFC9F.1000907@lwfinger.net> (sfid-20090116_041915_786732_D1E4D0C4)
References: <494698AF.4020204@gmail.com>
	 <200901152042.42372.chunkeey@web.de> <496F9740.5010109@gmail.com>
	 <200901152341.02130.chunkeey@web.de> <496FCDDD.7090203@gmail.com>
	 <496FFC9F.1000907@lwfinger.net> (sfid-20090116_041915_786732_D1E4D0C4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Zvrh8VOno1Tq67Ng9wAF"
Date: Fri, 16 Jan 2009 10:13:07 +0100
Message-Id: <1232097187.3854.9.camel@johannes> (sfid-20090116_101348_944450_133EF42D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Zvrh8VOno1Tq67Ng9wAF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 21:18 -0600, Larry Finger wrote:

> >>   Object 0xddec18d0:  >69< 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b ikkkkkkkkkkkkkkk

> I too have seen real single bit changes - in my case 6b went to 6a,
> and my memory is fine. I wouldn't necessarily blame your hardware.

6b to 6a is often the result of a refcounting bug that happens to unref
a value _after_ it has been freed. But that doesn't explain 6b to 69,
unless you happen to have _two_ refcounting bugs. Not that I necessarily
think that memory is bad

johannes

--=-Zvrh8VOno1Tq67Ng9wAF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcE+gAAoJEKVg1VMiehFYkmQP/2hNG5nSoumYYzre2OTDyDjl
Vf7ZqwhFar8vewcGtWm5uGTBoloSAZSQSgekmU2ecsSYtmHDBqdsTCwpfhDWMH6q
7oJVbfwW7KsvqTPao+rDUyly2YIuGqr6tdCEz/NacTEwITdwwFCh+ozkbLB0au1y
uJPMkJrvnTWj7qj+nfneexn6IMmQ4ScaQRh3aN6wJovqUimjfqY24vqFy2RTXB8q
W5DfjZAOuVhkmERfwh7A/DQqwiPBdBcQRR2Jg1ActFdE+kJ+ezkxz/Q3KSFZc6cX
LAGTdWbQHsHNMg4/6ynO1HUCxaB6p4mCLMLS6uLsl6CQmuCdSb4DfSX2DVMF0Znn
B1vkVJ7VIwH6GOzgrOwfGnWuPr+tLh5Iah0tXCC1iIHiKD9SBmn+k6es/Sro1eyi
SANYlTDFGdef35sS7+UuR6fYHu7F4IFKb+RHDfGUEsbACmc+dZKS7s0ETb/rHwTT
Hbb87JI5iPR3q24oNLY2QQi8/id5GLPoUQAGZoWRdXh281WgmjV+xcoVwgTenGvS
8yH4ST1tISHo4VFZrDVSe88htY/shTUTYPxT7KkSKjmDEQV73OLkprTcJQiGCdSL
HQ756FOMDJR5B/zRqmZAvcvVtlQ914GZRsnmLre9gp89F+YjM0jw5jTyEPu32e0i
Z6RNHEHnaGYM+N7Q6Icn
=nDVp
-----END PGP SIGNATURE-----

--=-Zvrh8VOno1Tq67Ng9wAF--

