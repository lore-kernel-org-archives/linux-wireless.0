Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35512 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbYHGQ5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 12:57:15 -0400
Subject: Re: [PATCH] mac80211: fill start-sequence-number for BA session
	start
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240808070945u961bdb5tb19eefe27a144729@mail.gmail.com> (sfid-20080807_184549_341338_B6E66100)
References: <1218051926.23048.65.camel@johannes.berg>
	 <1ba2fa240808061542k7fd3e0dat61df0ee77710e463@mail.gmail.com>
	 <1218090814.23048.86.camel@johannes.berg>
	 <1ba2fa240808070945u961bdb5tb19eefe27a144729@mail.gmail.com>
	 (sfid-20080807_184549_341338_B6E66100)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-T4AChzwuDxwyPCp1ZfVB"
Date: Thu, 07 Aug 2008 18:56:36 +0200
Message-Id: <1218128196.3630.13.camel@johannes.berg> (sfid-20080807_185718_370066_8A1F31DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-T4AChzwuDxwyPCp1ZfVB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 19:45 +0300, Tomas Winkler wrote:

> I'm not referring to this patch but to expected behavior that was broken.

Ok.

> Second I'm not sure mac should keep track of sequence numbers. In
> theory driver can drop packets in processing
> and this may confuse sequence progress. I've already wrote about it...

Yeah, and that's why I've taken care to not change anything that would
affect iwlwifi although I'd like to :) But this would make it possible
to have ath9k not use its own sequence numbers if it doesn't drop frames
(and iwlwifi doesn't really drop frames any more anyway, so here's to
hoping you can at some point use the mac80211 provided sequence numbers
too)

johannes

--=-T4AChzwuDxwyPCp1ZfVB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImylBAAoJEKVg1VMiehFY5O4P/iE9DZXgOTP4EPD1baIqrpGq
Zq8ES2EH36YcWX7XlCAEAiOn29w46T0WW124upXBPsS1MjnGE1wJNNTOzf7g2Gsd
QhYK4mH/vN+dwFTQ1sgG/7Iih5O5zmNpAqoNXtm1/2kYTVlV3T8XzAW2JX8nB/uG
vqhtytQdAVBo5PLi1zLK8r2izIcZVvJZSNPVP+s/cya5btWq2AHNFECJFijK1srX
RuEEcOYkDCYcPr+jmZ044d363CHg5aEbTsR2FCeTO8MqCsAg8nfWV8vPOTRLxeoh
YHoWa57sbx+QfiQMP6lzgdNSkfXRUdEp30iIFFfBCeK1+MoeEeDn/6C5mX/jsHTO
wU45ECi/wm1z0FCB/CCKysk3ayBMJKcCFe6PkalabWFeshfVuzXrkeelneRtTt02
aznNMP2idH6SXoKXW0vpCEfuuy3g0BUgQeltlHBFeMtPtQkBknxVbjCH/Y0QtHZg
4Ix0535xU0F7nPsyJL7oOgz5GXbtSs1qP3unal3rEqJWMTiYJJOj7qt7N/cOUQcJ
L7mAmBs9QEXqXFU22MDqMjxg0TYOzmOXJnh+/YB+4C775VBTCXJJnzDgzJlQegm3
Cby09//oO9GHcojz1sOT/EYhvj3kZmU456cmIqB4K3dp9ayMDhyR4IT90MOmve9m
vJO8ceCjw4jDaLnFTf4/
=msQJ
-----END PGP SIGNATURE-----

--=-T4AChzwuDxwyPCp1ZfVB--

