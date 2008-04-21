Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbYDUIaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 04:30:12 -0400
Subject: Re: Does mac80211 support ap mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Bas Hulsken <bhulsken@zonnet.nl>
Cc: Dan Williams <dcbw@redhat.com>, cao jing <caojing.china@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1208627675.27478.7.camel@Bas>
References: <9f33c5230804141218j5778195ajc1a7bae011eb9528@mail.gmail.com>
	 <1208202280.12139.23.camel@localhost.localdomain>
	 (sfid-20080414_204742_445593_54A5FE8E)  <1208257427.3502.28.camel@johannes.berg>
	 <1208627675.27478.7.camel@Bas>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AsE6jjYRuG3kSMUwQejl"
Date: Mon, 21 Apr 2008 10:29:16 +0200
Message-Id: <1208766556.26186.42.camel@johannes.berg> (sfid-20080421_093016_664238_57C39FCD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AsE6jjYRuG3kSMUwQejl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Bas,

Thanks for the note.

> rtl8187 does not come very far at all, hostapd can't switch it to master
> mode apparently.. haven't investigated very much why this happens
> though.. so it might be something trivial.

That would probably be the driver not being prepared to handle beaconing
etc. and thus rejecting AP mode interfaces in its add_interface()
callback.

johannes

--=-AsE6jjYRuG3kSMUwQejl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAxQW6Vg1VMiehFYAQKLShAAhRq9QsVIxCZ6/XkPVtmW/0/4yQFPkeBL
0QupA6MhkZmLm+0npRDs7jnWNg+zahdr+gYelbT3yxKNNRoWKUw7QFUwmtuTBeAR
kHUWAatsNMs0lb08Kx4zXuUn+OLp+3JYLXMbfIANm4nMKzxm8Sz5gMPsPGECfadW
DN79HY8I3F39Cb0kpKx+JcIz21A7Xi8LYd4qNIp2/ni6jBmHgEN/0Q2M6gBYta/w
8SwkrG8UUIbqQwbv2exrQREt+tvjf5QwAlueaR030wxslgK+/qxzdJ9uegHqH+TX
p6n02o1Thk4BVHy54LVhHDD4gtFr79um/0nBhIIIWg3GBZkHcbJY/R4OLrqvl4uY
wnrEBkiWp7hzIaZemngAfLKBlH8mM9SjBAd6qJg4B19mQuAMsiagEliU7GKZN4W5
WO0Tqyeh2nJSsdiVvDUTpNvACtix7nd8kPqgRranbLnO0kI+r5606jP5fpTXod9Z
rRF68Cf05RFCmjSDQujfrweLCt3f6Ip2FgNZKqRGQ+pOoioN33SWKzwl5Ca0eO41
7xgG1OC9SyIMPDgCB71LOMhwe+AsB+mJjw+LAx+f5OaoHQxz376G+NNW9D8/LrUN
XZPyRfIe7kNm3PZ0OQu6kn6QH4KeNbC5OsYpX7ehgvRlZ8WdgRxXVDb+y7TC0UL8
gnY2NFymKik=
=+4hz
-----END PGP SIGNATURE-----

--=-AsE6jjYRuG3kSMUwQejl--

