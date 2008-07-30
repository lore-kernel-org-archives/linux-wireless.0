Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39802 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYG3NvA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 09:51:00 -0400
Subject: Re: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Friedrich.Beckmann@infineon.com, linux-wireless@vger.kernel.org,
	j@w1.fi
In-Reply-To: <1ba2fa240807300645j654a82b4rb813b71681dfab71@mail.gmail.com> (sfid-20080730_154505_046031_C61B9B55)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217337819.10489.57.camel@johannes.berg>
	 <1ba2fa240807290643l4192ca62ia4db9966501caf0b@mail.gmail.com>
	 <1217339170.10489.62.camel@johannes.berg>
	 <1ba2fa240807290706h70f89f68xf8fe7e672c0275ad@mail.gmail.com>
	 <1217341293.10489.73.camel@johannes.berg>
	 <1ba2fa240807290855p191eebesb1ecf2314031f688@mail.gmail.com>
	 <1217411631.10489.103.camel@johannes.berg>
	 <8469FC7DDCBE054D9653D8506E1FF0F001F1E7B606@mucse406.eu.infineon.com>
	 <1217423948.10489.121.camel@johannes.berg>
	 <1ba2fa240807300645j654a82b4rb813b71681dfab71@mail.gmail.com>
	 (sfid-20080730_154505_046031_C61B9B55)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KD1ri/3eM52L9JNiMxUt"
Date: Wed, 30 Jul 2008 15:50:54 +0200
Message-Id: <1217425854.10489.125.camel@johannes.berg> (sfid-20080730_155112_441238_C9293CBE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KD1ri/3eM52L9JNiMxUt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-30 at 16:45 +0300, Tomas Winkler wrote:
> > Do you not agree that giving an aggregation flow
> > a separate qdisc is unfair within that AC?
>=20
> I'm think your miss understanding is that HW FIFO !=3D HW QUEUE.
> HW FIFO takes gives fairness in level of AC.. HW QUEUE just piles up
> packets for HW scheduler.

I know, but I cannot make out how the hw queue is pulled into the hw
fifo fairly. I'm not talking about fair media access, I'm talking about
fair number of frames in congestion.

> qdisc should be just provide simple buffering

Well qdiscs don't just do that, depending on the configuration, so we
shouldn't rely on them doing just that.

johannes

--=-KD1ri/3eM52L9JNiMxUt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIkHG7AAoJEKVg1VMiehFYiqMP/0vFxBE7Alf+zGbUBSI1S+HL
veRuLRVWNVsLi5Ape6ZyOJSkyW25fOGlanJQh33Ho5ius4BZOvNnAFmfmVvtOffR
UZgHm3V1qVa4Rn1EHGP5AJaWFle908jtNyFwfsrv2hce+zlw+mMo6/h83wb2inlB
LJ3mfMOIgzDHFyBgDXmB2d2+EBOGRd9kvw+gflQBo7nSqu2wZhD1SDqG/hqI3fKb
z+9qzR3+YajXRjwgoVfty7yyh9lBZ84ihPVFf8FYE4saMfWhC/Kn0To5Lnku4gzu
jyWZK2oLTEcV6Oue0tT9EOz4XFv6MjeDGmTsIAUCk4OdT18vmIxwJlvIu0uIGpjd
Dl8nOk/bWTpxTi3hHlBE1w1jP7SroJG8Vxm7dtxfy8ae5ka33R2SMSh4f9Gk5hZV
CuwzVWuF7qw1cOQnXo/zJPn8KGzmVsugFEikUszakDagUut1aU9uXVXGWq/M65zr
IpNJsT8S/huMnShijfZW9fSLvbdR4Q+Ry6WxmF2AfvEvTcEacmWbWNiuVmjf2WDa
7q2tz6lNfe1+lvNlPT7ag+KMLJ5LvL6GamXxlm8K6n+whf6qVntOTCiMkNk//MWt
jNjbcD846tamEosFxcwHem2iAruPBzjNgqO0j6eJ+QwqqEyCHp2npV+RaSq45oAJ
6B7wtQa61l8rHT4YIDff
=LGdD
-----END PGP SIGNATURE-----

--=-KD1ri/3eM52L9JNiMxUt--

