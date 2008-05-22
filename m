Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39464 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbYEVLMk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 07:12:40 -0400
Subject: Re: [RFA] iwl4965: support mesh networking
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1ba2fa240805220409u470bd5b2o83ab02be05d05850@mail.gmail.com> (sfid-20080522_130942_958281_9F6DBEA3)
References: <1211447482.3698.50.camel@johannes.berg>
	 <1ba2fa240805220409u470bd5b2o83ab02be05d05850@mail.gmail.com>
	 (sfid-20080522_130942_958281_9F6DBEA3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-u7A0ztk+1MGf/SACZilX"
Date: Thu, 22 May 2008 13:11:41 +0200
Message-Id: <1211454701.3698.54.camel@johannes.berg> (sfid-20080522_131243_131252_EAE09EE6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-u7A0ztk+1MGf/SACZilX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> It does beaconing in general (we have working IBSS and AP)  the
> dev_type must be  RXON_DEV_TYPE_IBSS or AP depends I'm just not
> familiar with the MESH stuff.

Yeah, that analysis might have been wrong anyway since my zd1211 was
beaconing all the time and both thought they had a zero-bssid mesh
going. Not sure. If you have a b43 or zd1211 you should be able to test
it, mesh just wants to be able to beacon and send action and wds frames.

johannes

--=-u7A0ztk+1MGf/SACZilX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDVU66Vg1VMiehFYAQKYGxAAnwfcMCfbmfwF8I/D/o8rXwnYJZ1F4Ful
PNXmUjVxUnCY0hIIPu9R13ga70qaBW1wJj10MIRUi0bJEGn4zwEkrsndZQnroV/8
+WAWlF2fR2iURJkHD0KzEYTr5qAIEt1x253/RMd674MVmCEGq3VD7Xcy9/rZvnZU
iOEnG/kILqkWgLkH0msLgddtnB25X4BLeQ4FD5T/3KkCbbhdNoKWfZXTT0vhu0vy
JzG4ulksYjzhnsPyH5JdiZK+1Gm6BL4NipXVR1I7jklWJa3w9CBwHs+BIgVc+Ulw
UgnKisF7dXvlZaVCp3WQrzilYZjwI9r2cBpVyu1SXbMWd3u0YT3SceaclMfMEmtR
iXIMu8kU0bnS5uKIIbX3F5Iz3JkD3IRm+ci7OVxiLtGs4SU0vSQEO2qzOGBTD+IP
CZAvcATfrOwK53JL5nd7JliHTq6QuGfoliiZ1mSw3wdSTqUJ9sDghthVxiAF9tAf
P3s7z4oN0O7flk+FOV5A73ICbGWfy4WiluXygiDIZcDLzHyfI/P1byNvUvTG7vVu
OekXMByRmKTSIElZ83NZX0TFxYwEXXbRtpsNzhYE1wuJb7ct4KARdq1TNegpaLFg
11YlTP59jm6GTS3DuV3PLGo68wAn9OSdfNthgtmCkBozuoA8VHoFHkLjY/iwdRWu
AO6R+KnFzDo=
=u3uJ
-----END PGP SIGNATURE-----

--=-u7A0ztk+1MGf/SACZilX--

