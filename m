Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39187 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYJaKBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 06:01:18 -0400
Subject: Re: Guidelines regarding separate directory
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Dave <kilroyd@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <20081030231054.ehd21qipcow4kg88-cebfxv@webmail.spamcop.net>
References: <4909EA78.3060700@lwfinger.net>
	 (sfid-20081030_181107_189082_5740895D) <1225387309.3690.73.camel@johannes.berg>
	 <490A17F3.5050802@gmail.com> <1225399481.7931.5.camel@dv>
	 <1225399682.3690.82.camel@johannes.berg>
	 <20081030231054.ehd21qipcow4kg88-cebfxv@webmail.spamcop.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VmPDFU4+jLpkxF7ou59o"
Date: Fri, 31 Oct 2008 11:01:09 +0100
Message-Id: <1225447269.3535.4.camel@johannes.berg> (sfid-20081031_110123_713085_F65C588F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VmPDFU4+jLpkxF7ou59o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 23:10 -0400, Pavel Roskin wrote:
> Quoting Johannes Berg <johannes@sipsolutions.net>:

> The WPA support in orinoco is limited to Agere firmware.  Maybe Symbol =20
> firmware will be supported at some point.  But adding WPA support for =20
> Intersil firmware would duplicate efforts.

Yes, I know, but wouldn't adding that based on the hostap stuff be
fairly simple? I know nobody has time to...

> The only thing I would like to change in hostap is that it should =20
> default to managed mode, like other drivers do.

No, that's not true, just see
http://bugzilla.kernel.org/show_bug.cgi?id=3D11802 for example. The AP
part also duplicates a lot of mac80211 functionality.

johannes

--=-VmPDFU4+jLpkxF7ou59o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCtdhAAoJEKVg1VMiehFYCLQQAIqwXQDwMD38EoGJzgKnyGSe
ABeMEum7KBv8+BYR22mvlwMxXBSk3xrtyDor9ktzyWErbwSl1FvFH3HkHvS5G/LI
uN10BtgdBPDjAxsFZMmUaYaN3af3V/kGi4UrvQd8xZyb7DxWriDpuq8Na6qEM35W
T5+QPw9LAK92/LQcHzCrOgg7Ml7ba4/FU8jamMHpauG3QnhmuJCuSJoFrI8WI2uz
Tb1aw0Cpgh0oOqFQInS858FhQ3QgMuHYgAxKQpvP8QYfpICHl2NtVJk0SsPxFu2h
LXqewbeJZhw8ORoYC6noEk3p3E6lYEHuZLBXRgp2OYXpj1zfsQYY4fQInwgMEN6B
/GxZIlbl9wJ+J0sozvHRyQtZu+DzplRQL4pFaYP6zw1AgSWL83aBG8CBsGDX8Tny
PUpK5e2hGq9q6cX2rACQGdQAf+YpACNiLRQXFm8Osj9aqy6ZMNSJ5/JQzLYceZvM
E9xXks1t5m0hHj2Ty7oRAgi/3pJdMXk3zlRatSZDCUvax4B8zLKTBKg+YXPubh4T
sjYi/WtcEmBejQ1fOUvJvwS6lVzoYuTCwrLnz5xd7h7g0C8/rBL7kL8jtI0U7l2K
X9QmxBLRSNsdyyvznio5L6v9nir+tneZ45XHb+Yp8xnhHNetHZ02kVn+6vLXKI7K
7sHFN6jk6OVGGOsiXueB
=8sW1
-----END PGP SIGNATURE-----

--=-VmPDFU4+jLpkxF7ou59o--

