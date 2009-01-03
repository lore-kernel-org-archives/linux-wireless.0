Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49056 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbZACW4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 17:56:40 -0500
Subject: Re: Invalid BSSID handling?
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090103000028.302750@gmx.net> (sfid-20090103_010037_599013_5390FD9B)
References: <20090103000028.302750@gmx.net>
	 (sfid-20090103_010037_599013_5390FD9B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BLzp51GvVK9pqEV5z0/P"
Date: Sat, 03 Jan 2009 23:57:17 +0100
Message-Id: <1231023437.4629.1.camel@johannes> (sfid-20090103_235643_733661_82FF421F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BLzp51GvVK9pqEV5z0/P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-03 at 01:00 +0100, Alina Friedrichsen wrote:

> The madwifi accepts all BSSIDs except 00:00:00:00:00:00 and
> ff:ff:ff:ff:ff:ff. Should mac80211 allow all BSSIDs like madwifi, or
> should it better treat multicast MAC addresses as 00:00:00:00:00:00,
> or an other handling?

Even though the standard asks you to use locally administered addresses
for IBSS, I don't see this as a requirement since they just want to
guarantee uniqueness and if you're assigning manually you rely on
different methods for uniqueness.

Cf. 7.1.3.3.3 in 802.11-2007 (which you can download for free)

johannes

--=-BLzp51GvVK9pqEV5z0/P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJX+1KAAoJEKVg1VMiehFYZ14P/39814cZvd9jyQdoQ47s6cYj
1xCWxfsMSfNaQeXRsGjamdK8Rbt/S5LLc+1iJwwS7toy4LzrlaLFVB+cG3Mu9bew
s29gxRJndGR7OIReUU+c8uoXSr3bVN7BlL/jzTv/7dzq7xgmW+OS3aiHXzqHZZWx
Gd/ZoGM464rJtzlkAZ5G4NYXjc2KVitjTCUHRM0LZRbqG8LVt/59f7QVCwnIo3QJ
1UYDGqPHtzcMQmr3TBC5pJ1w/Iu5JYdI8YV5gVl52UVni5quQWWz45qlOktvdh/c
SqdDGV/sl6fGr4ZjUythvK8+3ElSSHj2Psx55Ri5pG1iKUmy3n2E0QPlL2IYtGe4
Wxdb09MdIzQEUK0Y4ocMOOEyq6aVZPlEA1VBw1oTQuBX/0y0MVrEHpT4lt7t6dvN
kUXsr+1z+HBqgk050qEGxBZs8SvXW7b3l0E+DnYalv6A3wVjfsG5LoKmpiZNoUyY
VL4A5BNUmuiVQU66o4drTUqVKAy3SwYueMk0Yecntm2Y+LlFJByQpYiB1r1ysIFx
xgPVt6FwmsG5SqQ9/w5TwzLyGZWEjxDOSnhx3aJ7CfLEebhOi26ykBwjcehgGC/h
OgYFu83hGu0bvwvHSYNKlzXIMZitykEdZplpANJ2PwhVU0rCIT1uQRQKmb8/gh4v
Q23Budm+efYChuhqUfSz
=iOeW
-----END PGP SIGNATURE-----

--=-BLzp51GvVK9pqEV5z0/P--

