Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60317 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZCMKvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 06:51:18 -0400
Subject: Re: [PATCH v2] mac80211: resume properly, add suspend/resume test
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <1236941339.5235.14.camel@johannes.local> (sfid-20090313_114936_050438_5FF0B5AA)
References: <1236939917.5235.7.camel@johannes.local>
	 (sfid-20090313_112555_620577_8A85228F)  <1236941058.5235.12.camel@johannes.local>
	 (sfid-20090313_114453_238290_13C307AD)  <1236941339.5235.14.camel@johannes.local>
	 (sfid-20090313_114936_050438_5FF0B5AA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S5WIGGC7nAyVXBPNGxU2"
Date: Fri, 13 Mar 2009 11:50:44 +0100
Message-Id: <1236941444.5235.16.camel@johannes.local> (sfid-20090313_115121_028006_EDA2006A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S5WIGGC7nAyVXBPNGxU2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-13 at 11:48 +0100, Johannes Berg wrote:
> On Fri, 2009-03-13 at 11:44 +0100, Johannes Berg wrote:
> > When mac80211 resumes, it currently doesn't reconfigure the interfaces
> > entirely and also doesn't reconfigure BSS information -- fix this.
> >=20
> > Also, to be able to test this, add a debugfs file that just calls
> > the suspend/resume code to see what happens when we go through that,
> > without needing the time-consuming suspend/resume cycle.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > v2: rebased on top of "stop queues across suspend/resume"
> >=20
> > zd1211rw currently doesn't survive this properly, I'm not sure why,
> > but it keeps saying
> > 	zd1211rw 1-1:1.0: error ioread32(CR_REG1): -11
> >=20
> > Please test with other hardware, we need to figure out whether or
> > not something is missing in mac80211.
>=20
> ath9k survives ping -f without even blinking.

So does iwlwifi.

johannes

--=-S5WIGGC7nAyVXBPNGxU2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJujqBAAoJEKVg1VMiehFYMmgP/jN0ZKhpmDkNmiuos8HM0ZWq
i++wfg1VCAckm4nHgOV7q/pJOyQa9wQI0QyHgV/vLTm67LaUQ0RgUJRzghI0Rkfn
rVSLN9mIzqjV9XSemZcL++q3z82pYIPNcycLYxnjtDG3MVrS8Zv7xZT3lsrehMrD
0HYL5oSiT1QMVEbj9GwgSFCrgjd4ntOdtGV3sdBUTJfLmN4U1KHtGJeojW6mBfJ/
PO+crSE1Vm+D4JDi0+qENAkdTqsMrZ00FWWX6HvDslokTkdS1T/ISphguRPRhm45
IWaQDAsznYOGjT048oE+J6WaGgukSse0fmusZJ4cRE/tQf4tGfn+DQ1APPXZsAOS
i/mMmaD0aE7vnAMX0zs6Xn5LAxnd3iP2q2UKIrVn8lEu062JoLLihX1rO7871JTq
w+x+YlU0BKkXzaGrgyZcSgSFvyOO+w3QEHLDafASHS0cLgcM/UpxQx7FCLQTuitP
mfCv6w0iavGmqKSgfeOIjavnU/mgP0x/77sk1vNvv892l3CYt4j8xO94emXxdpFR
3Z5VZxMjKHa8KYnRN0ikerB6vJqVvy1x8jKWOi8IE7SZcW3IdXkfV41fdania59p
OYSGuyXk8mKmRNpUGs6N6oaywiZl1ygN0z70WC3Sj8F+8EnB+c1Ts57CcwsHDzTT
Ogm6OmOXZ609+a0QOS7m
=je8F
-----END PGP SIGNATURE-----

--=-S5WIGGC7nAyVXBPNGxU2--

