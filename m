Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40261 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760337AbXIYQWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 12:22:30 -0400
Subject: Re: API to regulatory control (1)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <43e72e890709250913x5c137ee3k8d68b4ad755cadfe@mail.gmail.com>
References: <1190456574.18521.220.camel@johannes.berg>
	 <43e72e890709221416o25bf3287v5d8d7bb5c2fe15ab@mail.gmail.com>
	 <1190624554.18521.261.camel@johannes.berg>
	 <43e72e890709241255v1f044f9dh4af1e00fcaba03b0@mail.gmail.com>
	 <1190669783.18521.301.camel@johannes.berg>
	 <43e72e890709241518h1cc694d9of8f8a8d216a7906b@mail.gmail.com>
	 <1190727624.18521.310.camel@johannes.berg>
	 <43e72e890709250913x5c137ee3k8d68b4ad755cadfe@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TItTaE6Xb1S0Kb3JBE8T"
Date: Tue, 25 Sep 2007 18:23:46 +0200
Message-Id: <1190737426.18521.316.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TItTaE6Xb1S0Kb3JBE8T
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-25 at 12:13 -0400, Luis R. Rodriguez wrote:

> Hm, the drivers will still call a cfg80211 helper anyway to update its
> channel flags/power limits, why not let cfg80211 just do it then in a
> loop for all wiphys upon reg change? At the end of the loop for each
> wiphy we can call a driver-specific ops->verify_reg().

Oh ok, yeah, sure, we can do that instead of a notifier chain.

johannes

--=-TItTaE6Xb1S0Kb3JBE8T
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG+TYS/ETPhpq3jKURAuqRAKCYZXGShHxlGOwThVlsqbMqEvlukgCgmYWh
8MOit9PC9YMHs7wydZN5Msg=
=dWeV
-----END PGP SIGNATURE-----

--=-TItTaE6Xb1S0Kb3JBE8T--

