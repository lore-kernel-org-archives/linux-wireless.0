Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33200 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbZHYKiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 06:38:01 -0400
Subject: Re: Linux Kernel Wireless stack presentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <eb3ff54b0908250329s3e1a4715u27c82512fff520d5@mail.gmail.com>
References: <eb3ff54b0908200002s4dc0dbf7kc28dda3fa7afaeb9@mail.gmail.com>
	 <1250760130.4100.23.camel@johannes.local>
	 <eb3ff54b0908250329s3e1a4715u27c82512fff520d5@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UxWEHWgnNcASJ+iAV3VE"
Date: Tue, 25 Aug 2009 12:37:23 +0200
Message-Id: <1251196643.10667.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UxWEHWgnNcASJ+iAV3VE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> > iwconfig wlan0 power timeout 0 =3D=3D PS-poll,
>=20
> I am not sure I fully understand what you mean here by
> "iwconfig wlan0 power timeout 0 =3D=3D PS-poll". As far as I understand,
> "iwconfig wlan0 power timeout 0" invokes ieee80211_change_ps(); this meth=
od
> notifies the driver about disabling PS (by
> ieee80211_hw_config(...IEEE80211_CONF_CHANGE_PS))
> and sets the flags to have ~IEEE80211_CONF_PS; It also cancells the
> dynamic_ps_enable_work work_queue thread. But what PS-POLL has to do with=
 it ?
> I am not sure I understand how PSPOLL is relevant here.

No,

	iwconfig wlan0 power off

goes into the disable PS case.

	iwconfig wlan0 power timeout 0

sets the timeout to zero and power management on. And when the timeout
is 0 we use ps-poll.

johannes

--=-UxWEHWgnNcASJ+iAV3VE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKk77YAAoJEODzc/N7+QmaFfYQAKw13H948NbqU44Q2kG89Q/+
SiV6Nq+SzXCzOahPA1PjSAZmcHqHE7hOpzc/R5WjDJOe1jroEuKo20SgcJqcycxP
uvMVbnuRfKavYf6BgGkUUKLgXnl/K5oebWbBmcxc6gfP7vcw942PJG3GUTR19jb5
Dhk7IwfcwLWpfMRdIfZl29LGdv5K8RZSWKzwh3xQ52Dq+/vo8nKgTx2nT+7nuElt
pEiugr6wMFzY9CGCKBA4py8jVgAy58SKPcrbzFpwuHf9jaouAs7b9iD1F6EZ+tn3
7GHBbd/lUmcrmBum/WuQditDwJ5ZUpE2Lrq1RLyjuJHC6zRDYRVMBMCC/7KwcSWy
Jdj/Dbej76SbG85/yiBC5nAsuNMeEATG7A6n7icv1qcEl1rCygiXSMH7z69v0vB/
T3KM6HKGw5SQnFFC+s7Uhc/cNihxAmxCupWrwOAJKRXoZW8AVFHmlDh1pGH1K63m
Bw/3ccH5w6V97RzEH1W6oa8RDYwqtJFPV92P1Fow524O+MBQQ94wYtWa4oxtzZvi
QqU7vpGNMLKJ4jAmokQ5COMlz5tDReTs7tuV/BxQqrs4Q2Xod5/ZeE/rGAS76u7e
EonlPAV8sC71mttiHUYVJHyPntmTFUDJjTFylBgcPoaRWJ0pO1OkD++jAdXNOW9T
y8cHAmE6ciiqeTd6457l
=+KoQ
-----END PGP SIGNATURE-----

--=-UxWEHWgnNcASJ+iAV3VE--

