Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014AbXJJRnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 13:43:18 -0400
Subject: Re: rt2500pci 2.0.9 not working
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcus Better <marcus@better.se>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <feig3h$urf$1@sea.gmane.org> (sfid-20071010_132127_504922_08284881)
References: <fdqhn4$qab$1@sea.gmane.org> <fei4sd$mm0$1@sea.gmane.org>
	 <1192008384.12541.8.camel@johannes.berg> <fei71k$tu7$1@sea.gmane.org>
	 <1192009901.12541.15.camel@johannes.berg> <feibbk$de1$1@sea.gmane.org>
	 <1192015848.12541.20.camel@johannes.berg>   <feig3h$urf$1@sea.gmane.org>
	 (sfid-20071010_132127_504922_08284881)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0pDIbJDXqneSXzFH/Dim"
Date: Wed, 10 Oct 2007 19:43:22 +0200
Message-Id: <1192038202.4770.3.camel@johannes.berg> (sfid-20071010_184320_619733_2318CF93)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0pDIbJDXqneSXzFH/Dim
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

First a note: could you please send me copies of mail using
reply-to-all? I frequently simply skim over mailing lists and just
almost missed your mail. I don't do that with my inbox...

> Precisely. I'm quite sure it did recompile ieee80211_ioctl.c after I appl=
ied
> your patch, and I've double-checked that I installed the correct kernel..=
.

:)


> > That's weird because if you select a G mode we do=20
> > advertise short slot/short preamble.
>=20
> Can I select the mode from the command line?

No, but you can comment out the B mode registration in rt2500pci and see
if that helps.

johannes

--=-0pDIbJDXqneSXzFH/Dim
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARw0POaVg1VMiehFYAQIpjQ//Znx0ANQMdt9EKXLcxfbns6uV2u6Ooq8p
cHThKHqiTNF4ZhdgWHJpa7Mx+OZUJzCp0tDuXyun4G9AnUJq+CXotmWTc139ykhx
ZVuSzJ7BwnedmvIqyy9VA5Ui0nRO4jGlmuevyfn70pND5pO4J5CI01IuBR4SyKf7
A/2nbsaAxNSjU5WqW+jHpjzU6tCRuxKdnMMkw2djPfvYJvz1P84oSUmFt5Nx0QrV
qTbLdgUFHnxAFzKs82f+7hAx8Q2RfU1zuhKTyMDH/MWbOeXY/JrTOpv80BwtGFGn
W3QFGm6M7Z89jK4XbChV1wdHXIWpk9OgRbrs178fMwl7E1M7FDILXrw8E9SYoAz/
ouISOP7xD5UjRCpKsVPTUhqcqF6dBIPbHMnmnKJ6q/R6KNqku7dSh10/bzwOgrIX
Hci0Un1KDDVLH3fQLg5v2K0d3xStWgeeEJ5fWuh4F9t6AGr1cnQgtuqTVfDwcb27
6rgqk5J87iZtCBGlTszyc+TfvUl7aCWMYB2mxsKVZfi9LJ8Q/eT7x+Dkom8rjGDO
8YpHMokO54O+mTLsFXYc+S7bVvEJNUucKBmBD9UnEzZ2vBG72K5WmeiuZM4ksnHj
dj5Wmvn27NIxwBn7eKfjebv+FW8fwrEvLM2OLwvLyEAmNYiuTAavkUbaB2eEVNYl
X44sbbxl9h8=
=ckDF
-----END PGP SIGNATURE-----

--=-0pDIbJDXqneSXzFH/Dim--

