Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56904 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbXLMRgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 12:36:20 -0500
Subject: Re: [FYI] hostapd with mac80211 progress
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	hostap <hostap@shmoo.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240712130635n44838ac4s5bb606e5dc27fdeb@mail.gmail.com> (sfid-20071213_143532_407063_3AB777D4)
References: <1197512614.6558.224.camel@johannes.berg>
	 <1ba2fa240712130635n44838ac4s5bb606e5dc27fdeb@mail.gmail.com>
	 (sfid-20071213_143532_407063_3AB777D4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SQ3eEqiUlbXAsblX3Svu"
Date: Thu, 13 Dec 2007 18:36:03 +0100
Message-Id: <1197567363.8313.31.camel@johannes.berg> (sfid-20071213_173625_341845_D345822F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SQ3eEqiUlbXAsblX3Svu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> We have mostly configuration patches - (enhanced hostap_ioctls.h)  and
> some minor changes in hostapd flows that we would like to rebase over
> your changes to nl80211/mac80211 and hostap respectively. We can start
> with 11n Association flows patches.

Sounds good.

> It would be great if you can setup git repository. Unfortunately it's
> rather complicated to export one from Intel.

Not sure if I really want to, maybe we can convince Jouni to take
patches early if they don't break anything else?

johannes

--=-SQ3eEqiUlbXAsblX3Svu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2FtgqVg1VMiehFYAQKlixAAlb6a5vT8LVhTlJEtaUHPST1gvZD7CPIb
/+9XvmlfZaK/cr+IymEG7JfJx14mC1LfyEVfn4gDZ4A1kHIL7zCfsd97hxBNiAym
CKmNSS5nMmhjGYxhb8YLN/YdicutqJZ9vUzoTD4UCuMOqV4OnlAKHFJmDCENOhHz
3OWVPLOaFm23p8gqzMJv/lDwsU7CfrwmyubYYptwuynFz0vSzUkrsXsV3FROTYQx
M/p2j83Oa86ymLy721eklcAwWZ6aSypy5AY3eGQmwKIAhd1WlItSpUgXpspAKNRp
8/9ibfC7yO5rK8nN4SuQCh5LyP6ImBInYa3oP5Y7zBTgI7DcWLPEMN80NkuUztj7
OTbcK6MbN3Py847fmWZHER+xWHaqlMKYypkj4hRpMF33lL/J3P2hRsrKWwkkuthD
0qpkU82uwoAg3g//NLBNITq0+7pdo24iwefRG3NUldnpYghJ3yB4d7/HYqpqlZ4c
gdaiO3TM75C0syCVmfnALcAEZVHDwbs+ejQXOJWmEFdkpy4EMDyrAY3W02VJNweI
acAIokDLamQpU+2cAwJH02m8Zu7Rd9aHdOWCIdSedRXAUxpJOwPscnhD8Q1r1Bve
JzSSYHdtq6QP323TwilHBRgVnl8zvFL8pC0iUqJ0jGPGuciFdyQgr+MDWQEoguMd
EdWqlM5bMpU=
=E84S
-----END PGP SIGNATURE-----

--=-SQ3eEqiUlbXAsblX3Svu--

