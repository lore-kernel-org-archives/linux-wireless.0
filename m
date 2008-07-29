Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51119 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbYG2J3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 05:29:22 -0400
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
	rtl8187
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807290226n19ab0944u8e27f40cb688cfcc@mail.gmail.com> (sfid-20080729_112701_171733_66AFF6A4)
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <48874F09.7060400@lwfinger.net>
	 <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	 <200807290021.45400.herton@mandriva.com.br>
	 <1217314430.15381.11.camel@johannes.berg>
	 <1ba2fa240807290123n7673dbb9m7121c1e76fe57e94@mail.gmail.com>
	 <1217320089.15381.25.camel@johannes.berg>
	 <1ba2fa240807290138h7deced1cob0836ae3e3c1e71a@mail.gmail.com>
	 <1217322974.10489.0.camel@johannes.berg>
	 <1ba2fa240807290226n19ab0944u8e27f40cb688cfcc@mail.gmail.com>
	 (sfid-20080729_112701_171733_66AFF6A4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fkK+W2tFd30i3p30583g"
Date: Tue, 29 Jul 2008 11:29:09 +0200
Message-Id: <1217323749.10489.7.camel@johannes.berg> (sfid-20080729_112925_744936_66A51068)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fkK+W2tFd30i3p30583g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> PS setting is rather global NIC state and should be set as user
> preference rather then per application ... socket. If I understand
> correctly what you mean by application.
> What user actually selects is performance/power consumption trade off.

yes, but what we also pointed out was that the user isn't able to make a
good trade-off, and PS isn't necessarily linear anyway. Therefore,
making the default be based on letting applications set what sort of
latency/quality guarantees they set makes sense for a good user
experience with maximum power saving that doesn't affect applications,
if the user wants to go higher maybe we can later allow that in some
way, but the default should be based on what performance apps expect.

johannes

--=-fkK+W2tFd30i3p30583g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjuLhAAoJEKVg1VMiehFYeTIP/2dn9ImB5m2fJADzwRf0SSOh
lzKsmvpuJdzuNCdij+OKG6gnw8iOsljv7dNfjjQvTMabyY/GD9f6umFUjEJDzqMw
XaJpyHTYwgu0o7963XE0L9KaDlpxhdy5GwDzkhmMARSsdGUaLG2E44MoTjobPF+f
Q5gz3fazY4f5C2NvT9Nzooy8D+IBxzXvNXoDATkRcB85W55Qfv16jTz4L2WcxtqZ
emc0tlVNdxWw4NlM90vxfMdn3qu+SYObTIIRtl+Rml1nR4ZT3U9fIg/96I9BPE+6
YdpqgpR9UtyGH4UKlVSwrFskJS1tpUdaQftIw3PoKDZqE6i9dM/KHZuxvY3i/LG4
TrFYFC2Hl8mo+FZjf5UyPceVzKHvtkASx75QerZlUbIofKoyTnphsJ9KU3/wM6Cy
ccZqJWuM5XMjFOufGIr7yX2gL9WqWOtnRSzBPtfPuoketj3G+ms8iEmTb2xB4kYT
tKUTXyUxmplrvbGcSudaECO8ltRKH+x1P3spNrh5ZxcrZqub5doApahuoeg7lhNN
x49oIzBtzilx3/SkkVQprT4oUCBpGKLpmQKa0m5+a/Q5Pib3nyCyRgGOlWYt17od
hh8wyAkKan2OrmWQKYp9MUPWKMvaOoLWXm7nZEhslvjhhk2irylrea/jImfDf9Ki
oyllGPx+BjPwROJnL7fV
=OxbR
-----END PGP SIGNATURE-----

--=-fkK+W2tFd30i3p30583g--

