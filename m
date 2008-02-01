Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbYBAMRe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:17:34 -0500
Subject: Re: IEEE80211_TXCTL_SEND_AFTER_DTIM
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200801312304.58587.IvDoorn@gmail.com> (sfid-20080131_220524_058867_0B78C95A)
References: <200801312304.58587.IvDoorn@gmail.com>
	 (sfid-20080131_220524_058867_0B78C95A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CegAVO1nU1rvIRYxu2kX"
Date: Fri, 01 Feb 2008 13:17:29 +0100
Message-Id: <1201868249.4188.9.camel@johannes.berg> (sfid-20080201_121746_595242_3AA81586)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CegAVO1nU1rvIRYxu2kX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-01-31 at 23:04 +0100, Ivo van Doorn wrote:
> Hi Johannes,
>=20
> I have overlooked the following patch when you submitted it to this list:
> 	mac80211: allow easier multicast/broadcast buffering in hardware
>=20
> But I have a question about it, the flag IEEE80211_TXCTL_SEND_AFTER_DTIM
> indicates that the frame should be send after the beacon because of PS bu=
ffering,
> but doesn't that mean the same thing as using the queue id:
> 	IEEE80211_TX_QUEUE_AFTER_BEACON

Well, that queue isn't used in mac80211... I am not familiar enough with
the qos code yet to say for sure what the problem is.

johannes

--=-CegAVO1nU1rvIRYxu2kX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6MN2KVg1VMiehFYAQIJHA//SSbjIRe64Nhu3BVJgYd9vDRTMyaAUzin
4ZgwziU8CmU1sifx4f7i7rznl1zIzysclJ9+xfDWn9j4ur9s2RjmJ94Uu4IBYEG7
oaZ/cKI+0jqft91aNt5L1wo3FN2xefKmCG/fTeLGfftfQgDdKdv3UPG6bmTxtEYN
MMAkMWEzKbwnnt03CiVGW8gQhLTOUTmQJMuoXiIA1wjw5rgTCr7QChRkP00I/ItE
6EYvXmUvvRzigJph2XBnuU4ggslvVg87hoBARdiYw7bzF/PESMJyp9kZhHG3iB0/
wCEGIiPk6q8ojVpTRvE8TlSJ1+unpXWVXPVKH6Y+lEDZwfXMaJlhz3D0EB92pyAn
bqtITarJkHxmeqXXuGp6pe8eoQixsHKcbcm0xoFmQoH2hUiU54CdUonfU6jU7bBs
7YGywCXhcYlhgb82zjBnEAvnTQ+n0nHMFByFaS9YTHewB++UtCcaL8ySfNujwwi0
EghQhZwPhrNzsOSW3qI37ZznJq1kJQRH84OzBSauwvrg+S+bGkIgxyv8Bt5/W756
NCaQ0hLxIPk7YGKnWT3e45Bo6XprKTNLxQcYBqYJ+2yWmQBujpzs1sjqwHR16TKy
REKq1zvli+UO/wISAZ1TmBlJvspZo4VWooDokUVjOFIIBX7BHRnc3W8bqKIyeJNE
DSdzBjgGuoU=
=ZOsl
-----END PGP SIGNATURE-----

--=-CegAVO1nU1rvIRYxu2kX--

