Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32868 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZDUVU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 17:20:26 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1240343775.3327.3.camel@localhost.localdomain>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239875168.9737.10.camel@johannes.local>
	 <1240247636.5260.11.camel@localhost.localdomain>
	 <1240248008.4632.10.camel@johannes.local>
	 <1240248385.5260.15.camel@localhost.localdomain>
	 (sfid-20090420_192718_984250_38AB6869)  <1240248773.4632.13.camel@johannes.local>
	 <1240343775.3327.3.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ULw+AuwIx3vY7z8v2MsS"
Date: Tue, 21 Apr 2009 23:19:52 +0200
Message-Id: <1240348792.17388.46.camel@johannes.local> (sfid-20090421_232030_897368_8033CB57)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ULw+AuwIx3vY7z8v2MsS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Marcel,

> so I have built the latest wireless-testing tree with a new patches sent
> by Reinette fixing the DMA issue. So far I have no problems and I am
> unable to re-produce it. However this is a different AP and I disabled
> the power control feature for now.

Ok.

> I also updated wpa_supplicant and iw to the latest code and assume that
> no fix in there silently fixed it for me.

I wouldn't suspect any significant changes there -- for sure not iw :)

> So we are suspecting that this issue was because of me having 3GB of RAM
> and running on a 64-bit kernel. Does this makes sense and could be the
> problem why it kept failing until I unload the iwlagn driver?

I couldn't say. Nothing here makes much sense to me, unfortunately.

johannes

--=-ULw+AuwIx3vY7z8v2MsS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7jh2AAoJEKVg1VMiehFY04kP/2z67ulGYkQ45dtuGbTTv4IY
oBp8/8Yfs+XLlIbNMceDAH1Ts3/WIc9mvD0IjrnIiyQQFV9XbQee4ebAytHILexS
IaD1pXxysk73JoMPMb4HxFmwNTYlMyJfGhygQvBXgHGfif5U+C0ODe+wfG7lb1JY
OxnpiVgUWeoTgCz0JEM5Al+D+aGAMaXKuLW9ACK6lgZibxO8BSLjQ2COsYf+4GUw
w5g2ntJoO4hKHHVn/1vz5/1j81fVHEepTWn5s7DzFpq/svOwnC562PciWGxUum6Z
J8sBmncdqHDAJqi8XFzXKDV91qfpnckrd4mkbKPYP6rnYrbddJ0O39A0kKLPi6Im
O5Fv7ccAzusqaNNmnssYrdjDTMIL7tJs82/slL4BRRTcgdi70hfe26vyNj3/2p+U
PbDB7/Xy+OXow/vquV1aNvbTEFVk00rJRHxsgk3o5pMagdC1Hon5g6SQQldwZH9I
Wh6XHx/ezsfF/KEKp5aXGOlifVIxp1SlkbgKGiRGH3PGX9EhEb1CF5HC+mPqYQuB
CzByBpVysrMgxuWpLMak/rWQnKKkCiCxA900UH8Nk4rCZuI0Ca4HXTSgtefp+UKC
vyONLmfGKOxqoR81wAvt11pMHV4n05mtDJiV19+0GMeK+nATkpdXpgT4SxzUIdtC
7X1pHfvPRXfxKDe5D0la
=t5MR
-----END PGP SIGNATURE-----

--=-ULw+AuwIx3vY7z8v2MsS--

