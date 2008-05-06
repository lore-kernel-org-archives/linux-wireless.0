Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57233 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbYEFKiO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 06:38:14 -0400
Subject: Re: [PATCH 25/25] iwlwifi: map A-MPDU HW queue to mac80211 A-MPDU
	SW queue
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240805060334y2add302aua2e4461451a3f95b@mail.gmail.com> (sfid-20080506_123327_973250_8DEE9791)
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-22-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-23-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-24-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-25-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-26-git-send-email-yi.zhu@intel.com>
	 <1ba2fa240805060209x3765abf6lf5ece51055b0d60@mail.gmail.com>
	 <1ba2fa240805060211j3730f29w30313dcb3fd34c44@mail.gmail.com>
	 <1210066688.8012.75.camel@johannes.berg>
	 <1ba2fa240805060334y2add302aua2e4461451a3f95b@mail.gmail.com>
	 (sfid-20080506_123327_973250_8DEE9791)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cDamgpavcSS/p0yfXxzc"
Date: Tue, 06 May 2008 12:37:31 +0200
Message-Id: <1210070251.13316.4.camel@johannes.berg> (sfid-20080506_123725_661254_42CC966B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cDamgpavcSS/p0yfXxzc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  > >  Is this going to make it to 2.6.26?
> >  > >  Without this it will be hard to run 5000 under 2.6.26 as is.
> >  >
> >  > I meant 'QoS related cleanups'
> >
> >  Oh. No, I don't think so, unless you can somehow sell it to Linus as a
> >  bugfix ;)
> >
> I will think of a bug :)

And John and Davem too of course ;)

> >  Disable the 5000 in that kernel and make people use compat?
>=20
> Huh, why disabling?

Well if it's not going to work then wouldn't disabling it be better so
people realise it won't work?

Anyway, for all I care that patch can go into .26 but it's fairly large
and probably depends on the other two too. Also, it's broken as-is, I
sent a fix recently.

johannes

--=-cDamgpavcSS/p0yfXxzc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCA06qVg1VMiehFYAQIZ3Q/9HvmriZJbKBVGbNvWk7K47ONAHrVFUp5h
AZF9iRxPc/Q+0djjd/wVvtkRXrELR/RD8eJihm6xvAO2Kl8lvEZTWHUR85tbk2UN
oE7Wg8vbnX+D1wrfJGKKHr0xGMwYhmcRdj7mn9kM+XWeMI0wXDFkkKkO26ShbBX+
CwsOxHWjhRsxKxwHE6R0IldK2Wou3CImj/HIQxbKJHOb+tvxAYqOTaoeVHHJzODz
B/Kv6BmB6rchlA7pieVWBEJlOmVgbKT1d6fAPZODKYNek4T7Uvr/ZCHZF/TkYQkC
CqZWnZaPgir4DvSDMdS0nkuvPP97ZdHynTBaGBEc82892dL+Wv27B9Oxloe2xz6m
8oo7Ju7iynzFsDRF7zEjPa9y/NqXTKwKm2KgLYJYnRHAvQ8wMsqElG8ZN6eVYQMX
4rc7UbetcRLg87gIRjqamIZNqvZ2uH04vlulB2e61HG6kz8DaMfMDoc74EYwpwz1
+rTeZuSiOlycVpMxADPWxRyr/q8uAWneOumUSks7f0SjIgGQW5xa8eN2qI27C7qY
UjDIf1uH3KnlEQX0dfZu78gBYqu3ZV8Z4WU3z5SIC89DZO3NQysMrqSnwhvRf8W8
A5uDsBsocQl2hq6/eOPvNzFElaQ6+v5Qj3xgYjV60bc1h8Qg7qEpbw605Z+GzJbU
/fzyE3Uk/7k=
=GUus
-----END PGP SIGNATURE-----

--=-cDamgpavcSS/p0yfXxzc--

