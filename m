Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51233 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbXLROAE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 09:00:04 -0500
Subject: Re: [PATCH 2/8] mac80211: A-MPDU Rx add MLME structures
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470712180541l3427454ek94c66b14bb26cb4f@mail.gmail.com> (sfid-20071218_134145_320212_A4A350F5)
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782201-git-send-email-ron.rindjunsky@intel.com>
	 <1197914893.4885.76.camel@johannes.berg>
	 <c85cb4470712180541l3427454ek94c66b14bb26cb4f@mail.gmail.com>
	 (sfid-20071218_134145_320212_A4A350F5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SB6uR+OUNLIJxHDB5TBY"
Date: Tue, 18 Dec 2007 14:59:54 +0100
Message-Id: <1197986394.4885.152.camel@johannes.berg> (sfid-20071218_140026_276863_211D8319)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SB6uR+OUNLIJxHDB5TBY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> yes... that was quite an irritating issue, had to use this kind of
> mechanism here.
> i will check changing type to u8 (need to exmine if it will cause any
> addresses problems)

Hmm, you may be right, some things internally use the lowest two bits of
an address. Not sure if timers do though. It'd still be interesting
since we can potentially have many sta_info structures.

johannes

--=-SB6uR+OUNLIJxHDB5TBY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2fSWaVg1VMiehFYAQK7AhAAsmJSO4LJp1sa3nmFelkz54AaSqiSOhVW
U/+v8s0ZRgIroOtqxSNzAizH0+5UMvz6fJtpHJPquor6KF4Qe27dbo/NbpDu7Tj9
ClUAIcf8g+6XNZBaBCROpd+OemqdsjOa4ZHC6Lpzomw4g1NNofQERKD1hicfPSEc
RkL0ZXiDZ3dtruj2lLZLjZAEWB7MYxBOtF6OV9zG7WxeORsfNpznNpexOacstWFK
OLOt6gN2I3QSA13hAL4KXqBPwu4bFCdSFjvM9q1bPH9RHH2e5L8kgmpzNR/wfyu/
rctcRCFgu6AwNfxL99F7n0wLeK6FwSxxveqdFeLNm/U3HCoJXkvkQEy6gEEOVrrZ
nZwk2nrQFr+MC0htYdVeCBeiiqpNw62drhE6N6Dz6L6tgBdjdbVNYxnsaoj9uzl2
z+B+gboy7FwS7DA6jyJdLZ8OIJuMa5v2tx0wxqDQ40a62rUAR/o97FLmOyqM7NJ8
zSp5vBdQOMT+EHgAtkPw1bNHQo5dkA7bjZnvyEtbBKRrp2ZSkUUPo+Vt2Ef+b9RJ
ZUwo8wZaffL7ClC55ZjgBT/iymZHvIrHMWOjMYPZvqMlqCeazh7cOVY2Buwvw7Rm
vtwfknKGppVW3OMy+Mt4gn+uMcH7SVBs4Zq6ZPhB3aIhA6CVay7X1TMgccBw0cDV
iw0TExptcK4=
=I+Wq
-----END PGP SIGNATURE-----

--=-SB6uR+OUNLIJxHDB5TBY--

