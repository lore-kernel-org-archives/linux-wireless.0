Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60363 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbXLROBc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 09:01:32 -0500
Subject: Re: [PATCH 1/8] mac80211: A-MPDU Rx add low level driver API
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470712180541t1c469c88y9574ece5d4e4573@mail.gmail.com> (sfid-20071218_134107_240449_79C7F5D1)
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <1197907078132-git-send-email-ron.rindjunsky@intel.com>
	 <1197914053.4885.62.camel@johannes.berg>
	 <c85cb4470712180541t1c469c88y9574ece5d4e4573@mail.gmail.com>
	 (sfid-20071218_134107_240449_79C7F5D1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QSs8KZzyFlkW1BMmyJ0d"
Date: Tue, 18 Dec 2007 15:01:22 +0100
Message-Id: <1197986482.4885.154.camel@johannes.berg> (sfid-20071218_140145_076072_114F0EF7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QSs8KZzyFlkW1BMmyJ0d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > @ssn will highlight the variable name afaik. I need to get my docbook
> > stuff up to be mergeable.
> >
>=20
> didn't get this one. i didn't do @ssn as no other comment in
> ieee80211_ops does it, it was just my extra info for drivers writers.

Sorry, that really was a bit confusing. What I meant was that I think
you should write

+ * @ampdu_action: Ask low-level driver to perform a certain A-MPDU action
+ *     The RA/TID combination determines the destination and TID we want
+ *     the ampdu action to be perfoemed for. The action is defined through
+ *     ieee80211_ampdu_mlme_flags. starting sequence number (@ssn)
                                                              ^^^^
+ *     is the first frame we expect to perform the action on.

so that the "ssn" text will be printed in bold in the generated
documentation.

johannes

--=-QSs8KZzyFlkW1BMmyJ0d
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2fSsaVg1VMiehFYAQLxuRAAgV0ztSqc+ZtChLkmoNAcAURY5UpKxZRH
1vi+Iwelt8LRCMo/vvdc0BEHp2MnExkmeysBp1YsRvuW0PKfaMt7LFRigUj4g66J
tSH74f9tOC4stY5npM5wC4Xj4H3XzdHUkDUAj3G5sJrazb5HPLdco+ctM3kI47X0
Ct8Br+5jLkZuxa7/+x7e1L63jo2GGp2VKSZ/Myvzw1NtdfRwHTm1jla/k7KSfxKw
BqEXLSZp003/yndRQDZlkrtaOQEAOjaoCOF57KB7WbCB7LrRPbyilchR78J8uzSg
S1EPRMX1TFd9BKOFX612k97FBNvkDdhvVxUeg8QwmafWIfh9yhFtny6ZMfSa+5Pq
Sm0MjR5f32B6uDA8LukFYX91AolHDPdVqTIlyKi4T7FUBlNEt2DEtlgObN91m9vw
/V/tR1GXB0hBplwU9dAhB3SsvMz4GvT4nBixdEgUMXmXVGuVG+LdR60xZQil4ocQ
AFQw5l/hrO99LKuuUUVEPsXA2V+/Qp1MwT6PAcm/D/HcFy1zwmNzDhHoXWKQK4rv
dFXRHvyIMHeVAnZfKIk8kHTm0OKqdZoeoPhcczaw1SRmfmK/r/zTC3IziDnFIwJt
eLuD3Vshhcnl8r5anH6jIlnPLQ0Uyq1CyPy9y0cAduZ9PAPHD2lSINt75CvJ0543
k68z7qCJMvc=
=WoBe
-----END PGP SIGNATURE-----

--=-QSs8KZzyFlkW1BMmyJ0d--

