Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40401 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbZCaQ3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 12:29:05 -0400
Subject: Re: wireless powersaving (in NM?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1237891149.4320.73.camel@johannes.local> (sfid-20090324_133306_274219_3B7517AB)
References: <1237891149.4320.73.camel@johannes.local>
	 (sfid-20090324_133306_274219_3B7517AB)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ovaRWymvDsICFdRZS3dx"
Date: Tue, 31 Mar 2009 18:28:30 +0200
Message-Id: <1238516910.5970.102.camel@johannes.local> (sfid-20090331_182919_194844_9E109657)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ovaRWymvDsICFdRZS3dx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-24 at 11:39 +0100, Johannes Berg wrote:

> However, by putting the burden onto drivers, drivers can choose a
> conservative power saving level when no application has registered its
> pm_qos requirements

Actually, should it? I'm now thinking that defaulting to a high latency
sleep state would sort of be required by the pm_qos API -- after all if
nobody registers a latency requirement then there is no latency
requirement!

I think we need some GUI though to adjust this -- like the "inhibit
screensaver" applet that exists -- so that users of applications that
don't register requirements can still do something useful.

johannes

--=-ovaRWymvDsICFdRZS3dx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0kSqAAoJEKVg1VMiehFYcbsP/RXnBhXlk78vqvx+bIfFCaK+
mTDWZfnYjiYxwrBcThjbEf6BlE2vQ5Z10V7DPK7RxFjXurEdD0nzgOS5v7QmePXB
7+etR74vJewwwd2Uj7AfnvTXyeMgs9ig4q/4ITCLqv3gLSxWSt1N1kNDwAnypc8e
X6JAQvDQ21lzvbWFR4KnSu0aIJqChHEWptNDpn4mMEKhRBN+vhsO1FMUHcJl09IC
oGndi3b8DGb366G9sh6zGba7Z5jdvaIJl8InaNy5/qVDCByj6/mFBOaHXoS2NH73
fE/N/LwpPlKhbl6/QbJW7yOh0apOdwsbCM2NuL2764QJlLcDbxzkhlAmpdovwhFJ
sC+XI3CSt/Ukv/Q2PGcrt4wExde5ibk3Wf97yCJw3bA6P3W625rkilGFe/usGmEL
LYikBM2cWKp3tyVa10eElQa919iq9MRwRkp9Pjo6UocXwVgzYd5V9q1i8OtpAmwY
BtBhKebN8EBg9tVyl53vzaAO9cvr+oaC6r51eB+0mNy3j837kuwG3xJK/QxwqT/n
Wxo7HJt3DclsUQImfQjwGd/KtCalcUYFTKaVl5lT1o/rxDlL2De/+ggoHp/lhgE7
tUoCO30Q3ElrO+xzVkrkhX8tpj004Ki1VJSvTnJqKSlEMCMgtPF4L6TjYADyE4bE
HCGwK4HUXrfJYRfTM+KB
=6s1Z
-----END PGP SIGNATURE-----

--=-ovaRWymvDsICFdRZS3dx--

