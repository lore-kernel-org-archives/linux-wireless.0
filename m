Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbYJOQCJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 12:02:09 -0400
Subject: Re: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224085845.4764.23.camel@californication>
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 (sfid-20081010_052512_883760_F373F92C)  <1223975972.10113.20.camel@johannes.berg>
	 <1224034856.24677.9.camel@debian.sh.intel.com>
	 <1224085845.4764.23.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DB2Ftozfe2xaAMlBRCJA"
Date: Wed, 15 Oct 2008 18:01:30 +0200
Message-Id: <1224086490.735.8.camel@johannes.berg> (sfid-20081015_180214_512282_5123761F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DB2Ftozfe2xaAMlBRCJA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-15 at 17:50 +0200, Marcel Holtmann wrote:

> > Let's use the solution at this time. Just a notion that the regdomain i=
n
> > kernel doesn't sort out very well in some circumstance without user
> > intervention.
>=20
> that is what Johannes and I agreed on. We do have to make this work when
> no userspace is present or is limited due to the design of the embedded
> system in question. In that case the first regulatory hint wins.

Yeah, we have to let one of them win, unless we want to add the
complexity with per-band hints as discussed in the other part of the
thread.

> Johannes, we could just add a kernel warning if we have mismatched
> regulatory hints and userspace was not involved until now. So at least
> it shows up in dmesg and can be debugged easily if needed.

We can probably do that, yeah, though we'd have to get the conditions
right to avoid showing that whenever you plug in a USB device to a
laptop that already has wireless built-in.

johannes

--=-DB2Ftozfe2xaAMlBRCJA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9hPXAAoJEKVg1VMiehFYUnsP/iARopiOCEIvVcSPymWIHSt9
2lC+lk2EWEO6u3Coj1ZOaEeNAx1FisijAKGWvcXLx/bZdppBmfwQecaDKHWjoqEh
PIqnL7AP0+bPagaR0Ohv4MWpF397hNsf9i6Ri4TnOZVyb3OdTStv5X4leqkFEsc6
Eu3lp6qmK7etX8VDAGdzybHm1F+r6viNRvzViX8KO2h8SwHnuC031dwQ2OnJIn06
rX3ZICllH4xORLTSRulPxrholN1JloZhReA+W84SfwO6VoHD9877POC6vMo2fXIP
CkPULY1a8cjTcxdm4VZeJPOKawe6/vz3+2EP9xle2B3pRS0LJxndG7AwycHwsgmB
CaazAIq/ezA4Od2hWJpaqphNlj3F4bWlD5HuUh7QMw2uh9DvuaNb3SJRl3Mg3TJu
edVXYPoyJcY3e/u1f90EbS+BjS58qGklSRXWIDP5Ux2/jxuwG5FZtMaWKQvoky1e
vNz13swWGYEt5K33vuS+ITHI2jFo4W/TvhKurhlx1PC3TZhGxP2gkECYk9yeellf
dAkNeJTiHOiWWRE0JPMjf6kQxN+K/bKGOYMc7rtIExDA/DQcpzhkvm/t3prLcm1j
PRWzFxCy2kVbK9/6NUqj51uzfz1yH7n2qQNPE4D7F0PI8mnBJ63yzQkMwTbZURVs
vSBV+Ru8CXmMkq7RN+wY
=cMqW
-----END PGP SIGNATURE-----

--=-DB2Ftozfe2xaAMlBRCJA--

