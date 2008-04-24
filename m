Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49658 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbYDZPvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 11:51:46 -0400
Subject: HT info in probe requests?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-M3WU3fUIqsgLbDjLiBjA"
Date: Thu, 24 Apr 2008 17:09:28 +0200
Message-Id: <1209049768.10943.3.camel@johannes.berg> (sfid-20080426_175203_820938_9FEFE60B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-M3WU3fUIqsgLbDjLiBjA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I just found code in iwl4965 to add HT info to probe requests, shouldn't
that also be in mac80211?

Since the probe request building code in =EF=BB=BFieee80211_send_probe_req =
and
iwl4965_fill_probe_req are pretty much equivalent, shouldn't we refactor
=EF=BB=BFieee80211_send_probe_req, export it the probe request building fun=
ction
and make iwlwifi use it?

johannes

--=-M3WU3fUIqsgLbDjLiBjA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBCip6Vg1VMiehFYAQLnEA/+Md1a6IY/WfGUHwtqQC/5RLdsdNLQWCB/
l9oglggqptk3xeqhvVmOuHlAJwGOQ/ivCjBa9SkfBM0k4HbONsC4PxQAqiB3Ec+c
84RnEZLhpEiAkWVICfEIxSz9FE+X3DkA6vQxLhpv8Wfs+bhPfuGUcvBHpa/41F2o
yvyHbHJcGggWr+6BeyMiyZG/xazSa0qZiHX2mPN1lyDWFMHOR+oSo1qpx39hrsLM
mXnowY8SfFV6S6jts8LY9cHQ1duim/k/TzDWQETL19mcJzmOW8DddL9Uy/3S39za
bCJ4sy3IqldD/dJFL3X8dDLR7qpBISg8MJ4/s4yE9K/F5FlpZjqDpLy7EgrYG0xK
ZX/J42/ODKvvA+qDw0LLvOcifK5kdBz9kPqZvBH+K9NI0R5icnBt6pgb925Pc4VQ
x2/Q6VPsWnyMwhr3DjSY6jWyTDan828dRhIWDXFsZb40j4nqsCqSUqAWGBsPsHco
JFxRRDtEzAJwh9S9SsYJgCF4zChRC/yK1lu2E41gJCCgTlJ7JyYTNnGmuJZs10qt
K2emEHKB46VRqN+xprZahKY/OTAChNXw8KV/NTvTkz1n1jLH6ao8/idREfwrcfOT
njH3jGe5tz58Cq/Ab3vCXqlpk0BeGpymoltmBKuAfibe48UGTio6KdvTJMgnnysO
HHyNfxwih0o=
=qmD0
-----END PGP SIGNATURE-----

--=-M3WU3fUIqsgLbDjLiBjA--

