Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbZEKSxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 14:53:30 -0400
Subject: Re: [RFC 3/5] mac80211: fix idle trigger upon resume
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890905111134u61f1600fie1950b6e12681e13@mail.gmail.com>
References: <1242033904-25694-1-git-send-email-lrodriguez@atheros.com>
	 <1242033904-25694-4-git-send-email-lrodriguez@atheros.com>
	 <1242036115.3284.15.camel@johannes.local>
	 <43e72e890905111134u61f1600fie1950b6e12681e13@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VvbHHHGsgd39oS8pLA/P"
Date: Mon, 11 May 2009 20:53:30 +0200
Message-Id: <1242068010.3873.46.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VvbHHHGsgd39oS8pLA/P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-11 at 11:34 -0700, Luis R. Rodriguez wrote:

> > Also, __ieee80211_queues_stopped_by_reason is misnamed since it checks
> > only a single queue. I also think that we can do this much better by
> > keeping track of the suspend state in a new variable rather than lookin=
g
> > at all the queues; even just checking queue 0 would be sufficient, but =
I
> > think a new variable is warranted.
>=20
> A global variable for going to suspend? Hm, do we have a system wide
> thing for this instead?

No, and even then we couldn't use it I think since you can have
per-device suspend. I was just thinking of a local->variable.

johannes

--=-VvbHHHGsgd39oS8pLA/P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCHQmAAoJEODzc/N7+QmaGaMP/iKprbeGqBX6FYv8zzo0j3Lh
vrDKRXEQwroOHAX2SYYnWYr4hP3o8EagocmKdVJVQHYGxGvzIsuW4GiyltNs7O6Q
qU0NQhb5JU3X4cPi79azHkBCHM3DUIAV7RrKQNzTMbqsoylFzSQr/JtpFmOGUpMo
eswGnxxZ3suWnxSJNwCFLDVppcZZfExOSrLHNMBaIRQm0BzFUuECPBmU1U/SalaW
S1DbfA6Gu/KgoSOT1OWi356EeXOUB8A4ayh9b3Psth2RRS5vqVMwsxUjwh8Wwnd/
HIU9K11EOJkJo0xdjQKLvTwiR8/RboIDJrojvEwWEk27I9ykh2kTazMv/XtdN7ig
AetRPBlnH1qm8nUp9Utq3cuuQQnqeVXHNNM+kJM0LyLM2xtO4FEwbPmahWeXLDcz
4PjgZSCmUTgJeGbaDL/bGr6PnA52kBuAW11iSJHGDvTByoMqbK4UfEvSuCzcuu7y
mVg3w+RkyQCz+aZS4PLGRMkwqYWCKPdQnFxlXAQfw7Vl1hHiRrPLQh1JxQtR9qSj
7YIj5IPWtsj/SeCL2xUwFotUNax+lzNk5PBlQT545NdQ+A5qpuDOUgDtTzrmRPFY
st4LFnGe2o9HFeSxUBf9aikZDVXHsjX5CFCz1536mY2zFuDCYyik4D7hsW5ilcyS
mnSuDJPPpMEYseNAkIDY
=z2QX
-----END PGP SIGNATURE-----

--=-VvbHHHGsgd39oS8pLA/P--

