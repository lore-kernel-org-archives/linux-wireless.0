Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34251 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803AbYIRShO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 14:37:14 -0400
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200809182034.00801.mb@bu3sch.de> (sfid-20080918_203449_107036_C7A426D0)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net>
	 <200809182017.12685.mb@bu3sch.de> <200809182023.21751.IvDoorn@gmail.com>
	 <200809182034.00801.mb@bu3sch.de> (sfid-20080918_203449_107036_C7A426D0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ePFL/xUGXrKUZC1jU69P"
Date: Thu, 18 Sep 2008 20:36:35 +0200
Message-Id: <1221762995.20772.9.camel@johannes.berg> (sfid-20080918_203718_621140_45CD8B43)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ePFL/xUGXrKUZC1jU69P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-18 at 20:34 +0200, Michael Buesch wrote:

> So you say that rfkill should only be notified about changes in the first=
 read-only
> hardware intication bit? If that's the case, it would be possible to turn=
 the radio off
> through mac80211 calls (using the read-write register), but still have rf=
kill think it's
> unblocked.

This is why I'm saying it needs to be integrated with mac80211. Anything
else is stupid because it would force drivers to keep track of all three
states.

johannes

--=-ePFL/xUGXrKUZC1jU69P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0p+wAAoJEKVg1VMiehFYU5wQAK8rKYhULurx5s14DhPPdnCa
o4VpsEu4ebqi6kllpwz7Oso3ZHs3GxoqP2kIzf1Gy5pDqCc8V3lR1loAl9Aix9z4
BLZKxQjWJbQ99bFmPEsLhRAxKuRk3FnhwigrKams20nRZ8if7TEyYjwertT/X5UE
jWvTJsUkMVpEHx+XkyLuknUYds+qB8PvJjabXU72CpZIAUk2LII8QtLyAOXmTIql
njfzOhE3CC6h+aeiF6JitQHsMGs7+p84Qj24C0n44LVUyUGJnDBV7Jl2klNBF/12
w4n6Mq0tFL52TE0siMlZPIevminZkv57LH+4JP8TT9MTObEssPGjB1f7llmSniWw
bKgO5cCCLnhCcdQufyNfDo+IUHlNrfp6avwszz1BVMy8C6EvB3UjRojcUslyPFn4
TnL5WrDOPNsu4PUDpRMraiqJODUsiP35HlrOlRNQxESTfr7RsJ/yk44LtMZEv4rn
lmblRtBWAaMjdCglEZ1W5/XHAzgdvn1NO+bfycB3RYNkrWcRqufqADqq5ozkEerA
X9V7dGqrdQQQlhyBMgZZj4bdXJpa3xwMVWfsNKoElz5aoGWEm83D3d1znjGyuGcC
aWsDoChMog8fjcvhj72JUmFaGBVQE3yP8HN9I9owjE2AmGrofT/Dvg5G8FJXWtPG
bi5rxmPKOrQ7bpQd35AA
=p+UY
-----END PGP SIGNATURE-----

--=-ePFL/xUGXrKUZC1jU69P--

