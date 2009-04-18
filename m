Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53569 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbZDRNin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 09:38:43 -0400
Subject: Re: [PATCH] MAC80211: Remove unused
 MAC80211_VERBOSE_SPECT_MGMT_DEBUG.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <alpine.LFD.2.00.0904180930530.3509@localhost.localdomain>
References: <alpine.LFD.2.00.0904180930530.3509@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZY1fLjunQk1d6rKdEo3t"
Date: Sat, 18 Apr 2009 15:38:38 +0200
Message-Id: <1240061918.4755.42.camel@johannes.local> (sfid-20090418_153846_532521_DAD36E7C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZY1fLjunQk1d6rKdEo3t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-18 at 09:33 -0400, Robert P. J. Day wrote:
> Remove this unused Kconfig variable, which Intel apparently once
> promised to make use of but never did.
>=20
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

FWIW, this is the exact revert of the commit introducing the option:

commit 7b1e78d5052a92e95d851fbb0236a712264fe7e8
Author: Yi Zhu <yi.zhu@intel.com>
Date:   Wed Jun 18 17:53:43 2008 +0300

    mac80211: add MAC80211_VERBOSE_SPECT_MGMT_DEBUG Kconfig option
   =20
    The patch introduces MAC80211_VERBOSE_SPECT_MGMT_DEBUG Kconfig option t=
o
    suppress Spectrum Management 802.11h related debug logs.
   =20
    Signed-off-by: Zhu Yi <yi.zhu@intel.com>
    Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>


So it's been there for over half a year. I guess we learn from that to
not take Kconfig symbols that are unused in the first place ;)

johannes

--=-ZY1fLjunQk1d6rKdEo3t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6dfZAAoJEKVg1VMiehFYTe8QAJgAoZPyt8xT9y48TIZgzI/i
b0ZnrwO20fAX11LY0H6OAoYAUDZQb8ixaZjTdpMA1LVH7AbXcJW49cbPC0yWKmlf
frF9XRxXLes0imGAhaQu8Obk3ugRe8Uxpws2zl86koH6oAEN/6t74xXRfsmO8GpB
b2V03wcydbA0NU+BkBe5CxlLJbYvpJk7xy+q0IUY257EDXmCD+F0+SBhifWsF9/K
4b6TcUO7f1QHB+OB38sjFtbvPE4qR1RQuX/y5gMSRu0BTEdooedEDwLt9wv63qt/
wyILYYhGzlQ0dyLglV82K9RAYnxdJRevD1gGqMJj3bKZfWQGPfon6vP9HPOD44Jn
bNPTzf9EYOdJnwcSroaajGNPZmqwVnMFN8SjWnkdXvKMslf4vw+Cb1YCyoiVUkOa
slYpr+bQk5Ys1DGBSNI1C8Kvv54KdOqAJhenb3Z8gE6J/IpROEVNqpeCCrT7uHqd
wTn1wpsobVarHNdTltW2KE7d3Wg7jTg7/MHzqNIq94hQmrELofRpoDvB9uV+fAP7
GC7vpYIFzuPPAG2GYTAYrob4fAee0+BdCZMHuguFge36hanfXprQUseAL+uIGx+P
hs9JjNU0teXgRq5FZ1jvvhUyX2smyFhF5w09uf8VhQ3SlLQsd+9bSnzxaJvEdLQK
h9Ivvc5d5RWBfo0RvbiA
=Jlce
-----END PGP SIGNATURE-----

--=-ZY1fLjunQk1d6rKdEo3t--

