Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbYJ3RTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 13:19:05 -0400
Subject: Re: [PATCH 6/6] cfg80211: enable 5 GHz band for world regulatory
	domain
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890810300909if0e2db1qf5ff8512ab760275@mail.gmail.com> (sfid-20081030_170949_463670_B51F02CC)
References: <1225329594-21704-1-git-send-email-lrodriguez@atheros.com>
	 <1225329594-21704-2-git-send-email-lrodriguez@atheros.com>
	 <1225329594-21704-3-git-send-email-lrodriguez@atheros.com>
	 <1225329594-21704-4-git-send-email-lrodriguez@atheros.com>
	 <1225329594-21704-5-git-send-email-lrodriguez@atheros.com>
	 <1225329594-21704-6-git-send-email-lrodriguez@atheros.com>
	 <1225329594-21704-7-git-send-email-lrodriguez@atheros.com>
	 <53ad401862d734b26836f0706a394525.squirrel@secure.sipsolutions.net>
	 <43e72e890810300909if0e2db1qf5ff8512ab760275@mail.gmail.com>
	 (sfid-20081030_170949_463670_B51F02CC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IapxjKL8w7J/xzfMS1Ds"
Date: Thu, 30 Oct 2008 18:18:57 +0100
Message-Id: <1225387137.3690.70.camel@johannes.berg> (sfid-20081030_181926_441550_C2C6A2EE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IapxjKL8w7J/xzfMS1Ds
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 09:09 -0700, Luis R. Rodriguez wrote:
> On Thu, Oct 30, 2008 at 2:24 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Luis R. Rodriguez wrote:
> >> Technically speaking since some countries do not support
> >> some channels in 5 GHz the world regulatory domain should not
> >> use them however APs should *not* be shipped in those countries
> >> which don't allow 5 GHz operation. Because of this we can
> >> safely assume we operate correctly in STA mode by forcing
> >> passive scan and disabling ad-hoc in 5 GHz. We leave out
> >> all DFS channels as we don't support DFS yet.
> >
> > No,  this is incorrect. The linux kernel can well act as an AP.
>=20
> An AP would/should not want to use the world regulatory domain though :)

Yeah but if a user just starts hostapd without crda then we shouldn't
allow it to operate in 5GHz

johannes

--=-IapxjKL8w7J/xzfMS1Ds
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCex9AAoJEKVg1VMiehFYtRcQAI70FPngHx8e6CgWgNamU9uk
Ajlp6kzpOgjLCtZu+DYflKbWD4HSJB0V4Ed+3PjcmQCK9b2xoxBvKEurm7KpiWSf
1wVjdjIHujI2n3OHWxY2M0mSEWWJZSaKGfLK8aV2k0QAJ2w0/B6jvQeVQblFx2FR
P8vsnwzCKa0HLosthyQ0wtemg3YLLUDxyt5dJBCCboIoIP3LBkcrOKfBxRwAFx5S
xj3hlUtpC8Awd/G5R2TF9vOFO2Eszes6VMzrupSckmCc9djCrTtgtEdagCwtsWCy
+zkvUEuwaNUD0bNg2lPJw3MxQWDRSRh+n1BllnHoW1heKpE2jLoYcZa2CJBtAh3S
uOHKuYn0ybiQLGs7yta7tWXZDvT2ULIitZFcIVXUl7/dF9nB6ZJaCH4+3IeXMTZC
eO3rtGdSuvxTmsKyPGY6xcA9MTioXobH/CA5RGMrtsQsx7yYnoLFn4irjge+R0Ar
LHGQR73ezPgwGv3yuK3umayn6Ogc091U9ws9YiREmMLe0pBMxUcnMXDAVmr+9Z4w
dECVAG1+Hpz9q92CbdgOPMt6mn1LxxzBGR5DH79vOqxz/rlR01pigIFN34TObcz3
DTl5MFLE/oNkqjfraDpW8lIaYJbL5HkW4SIDuiZQXgH+YAS52AGdGsbceHmve7Qt
tZzBhan2IRKuNaN6apoT
=yS3o
-----END PGP SIGNATURE-----

--=-IapxjKL8w7J/xzfMS1Ds--

