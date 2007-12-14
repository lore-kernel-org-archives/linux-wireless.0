Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbXLNOjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 09:39:12 -0500
Subject: Re: [FYI] hostapd with mac80211 progress
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	hostap <hostap@shmoo.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240712140613p59e1d9fsf214310d8d9a66fd@mail.gmail.com> (sfid-20071214_141352_383010_B40A3AB3)
References: <1197512614.6558.224.camel@johannes.berg>
	 <1197631052.16079.26.camel@johannes.berg>
	 <1ba2fa240712140613p59e1d9fsf214310d8d9a66fd@mail.gmail.com>
	 (sfid-20071214_141352_383010_B40A3AB3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5HwTM/qILKa7xXZl8Y86"
Date: Fri, 14 Dec 2007 15:38:57 +0100
Message-Id: <1197643137.16079.55.camel@johannes.berg> (sfid-20071214_143923_154921_575A6933)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5HwTM/qILKa7xXZl8Y86
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This is a bit more complicated then that
>  In HT aggregation we have more then 4 queues. In theory you have TID
> X receiving address queues. Number of TIDs is 16 yet for the
> aggregation on 8 are relevant.Let say your AP supports 32 connected
> stations so you need 256 queues for to keep packets in order. Of
> course in HW you keep smaller number..etc.

Hmm. I'm not too familiar with the 802.11e stuff that is really getting
used now in 802.11n

> Ron will send RX AMSDU aggregation patches at the beginning of the
> next week, then he will work on TX side. I suggest that in that
> context we can open the discussion how to solve the QoS queues and
> Qdisc cleanly.

Sounds good.

johannes

--=-5HwTM/qILKa7xXZl8Y86
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2KVgKVg1VMiehFYAQKWXA//dfnU//PvUNp9ik1MgHFSJ2RcV0Lieqni
PBCPS3ylaxsZULZoyVLk/+qewF6O2Xamp7HEq5z0n45g0/xkWBTcr//8uWOH7aT4
y9eBAjFO4jzLt8OFIPTiXw6GdFJQPRRI2QcWa4jyZB0+GUFvIYDneaMqmqe2a0Ko
UcH77u0UXBiue3+xf5XU7NK1/ik9q96MKWSH4OWNZ8nEvOyDnHMwYzakdYNOlkgX
wm7jdbMnc7ML5MdsKd0wJ3JPUs1qjgp51+gOkycJvlC++qmevSqGFQt3kBzjO121
1EjPONAjifnWO461/r+S9w1XY4GFQCOJwJEXzSuKwwcy25BhAwBpLnvVj2jiawAX
T4xU0s7mYVyjctDR4AvzxfaOMEaCnGaG9smj2ZZKTG6+VFIHPi5w8ts4Kp0zD3t6
G7ddlHVP/CvKRJlXuOIY7jR0If3WR6Rrgv+Wd0FReCwGWdAgS5mOZF5GNE+HLEqy
tBTN1DJe9Dzy9qfNa/UuyLNHYKsuR6ZPdwrT92QDj4JcpEM9lMbsfEFX8NSkhu3r
CMHv8kM29D8ZePsNrPPhLrjnwuWc2rEORNUPym4mclRMMEVvc6e5kKNncTDzMGl/
1WN2kZul/VSc5LNUrSxt3lbxuUWWj67sh5qp5OYNvZk/vn1I6leSfF9eJfkvR7pS
eDAvWk5YPhg=
=V+Je
-----END PGP SIGNATURE-----

--=-5HwTM/qILKa7xXZl8Y86--

