Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760160AbYCEJXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 04:23:14 -0500
Subject: Re: [PATCH] mac80211: fix hardware scan completion
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bill Moss <bmoss@CLEMSON.EDU>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1204649676.25502.12.camel@johannes.berg> (sfid-20080304_165549_783589_88DE95F7)
References: <1204649676.25502.12.camel@johannes.berg>
	 (sfid-20080304_165549_783589_88DE95F7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4xI11eKFqE7+1GlM4voL"
Date: Wed, 05 Mar 2008 10:22:49 +0100
Message-Id: <1204708969.25502.35.camel@johannes.berg> (sfid-20080305_092407_574459_9F149C7B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4xI11eKFqE7+1GlM4voL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-03-04 at 17:54 +0100, Johannes Berg wrote:
> The mac80211 MLME requires restarting timers after a scan
> completes but this wasn't done when hardware scan offload
> was added, so add it now.

hold off on this, I just realized it has a locking error.

johannes

--=-4xI11eKFqE7+1GlM4voL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR85maKVg1VMiehFYAQLJqA/7BnAwQZZ40+5cCYH+pSIzqJFv1jx9kc7O
Tzd/z8j7RCPNUesimWQrDYw6qfyfAA6qkNRlecHHOPxciwuvglJHKCoe7inrNq3d
puMRlrhS7NH9w0t31pSZZcZAVBVcxKjZ98Ym1YtB+JmcUcVpWujJm1ZqQfRD5uEP
ual8R+vfpJZ33dwe9Z8KR1dy1HPNQmHy8lyEZAEXtcieI3XLP5Y+kncPdMfd2NfY
dJ2peLU6yp43ejWp6rkOrtKWEekEmx2AeEQMUqaVg7NLpVB/0UsN7bFpHGvPhcSl
7C0aDyJodQYjGN9Q5IuBJ6KG+/AGsAk/GEkdywk9F+f+KojmFwhk2ajXK1wE+pt3
bnjeXPo1rnmbq1YcKxmN+eILDD0/BgXe+JYJshy9glTOvS+dcRdtDI5u1eVHbtcP
vpS0+oiXBOW9qubc9Rl7Qh96Cp+q/H9nTp11nTVbgdmlJbI0ah1MV+4J1d5ht+p8
izcRgy6o6D2iFSeHQMz4j5qwzusV/rBQv/IWI+a6tkQPfWLtp5Eusajt6P3vQKeW
HpC0kM4+VyP7Bs4dMogTsEOQdqKMuaNPTo1eRe/7/WizTAQT5RxeV9B4ue6V5RCA
IjASGjItGoAUV1zxJDbaGPUGudYJaB1fprJWxjHz1Jw3ibMvgTzP7LLiQZP/eVzO
VhrEA9AL5Jg=
=DAv5
-----END PGP SIGNATURE-----

--=-4xI11eKFqE7+1GlM4voL--

