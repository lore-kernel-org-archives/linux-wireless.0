Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43572 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbYBGKmG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 05:42:06 -0500
Subject: Re: [RFC v2] mac80211: add general rate information to Tx status
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240802061004u5f4bc2f8q2fbfbb7778121873@mail.gmail.com> (sfid-20080206_180405_626334_B22C87A3)
References: <12022263282085-git-send-email-tomas.winkler@intel.com>
	 <1202307331.4395.41.camel@johannes.berg>
	 <1ba2fa240802060644k3f0b5e7cgb48380a2b3181f41@mail.gmail.com>
	 <1202309885.9965.3.camel@johannes.berg>
	 <1ba2fa240802060818t5945ff67jb64ccee0a407c604@mail.gmail.com>
	 <1202315330.9965.16.camel@johannes.berg>
	 <1ba2fa240802061004u5f4bc2f8q2fbfbb7778121873@mail.gmail.com>
	 (sfid-20080206_180405_626334_B22C87A3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Hk3fLkn01jpUCpvFWvN0"
Date: Thu, 07 Feb 2008 11:41:54 +0100
Message-Id: <1202380914.5718.0.camel@johannes.berg> (sfid-20080207_104212_057756_CD1B4B96)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Hk3fLkn01jpUCpvFWvN0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Mind you, I'm just writing whatever comes to my head ;) Better ideas
> > welcome, especially since this makes tx_status_irqsafe() and tx_status(=
)
> > behave completely differently.
>=20
> I prefer to start to converge to something since iwlwifi driver is
> broken for week on the tip of everything.

Yeah let's fix that and then do the larger redesign later.

>  Incidentally, why does iwlwifi use both
> > depending on in_interrupt(), or rather, why isn't the content staticall=
y
> > known?
>=20
> Actually in spite of the IF there I don't think  it  ever happens that
> iwlwifi uses tx_status() directly only irqsafe. Does any driver uses
> tx_status directly anyway?

ath5k does, but I have no idea why.

johannes

--=-Hk3fLkn01jpUCpvFWvN0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6rgcaVg1VMiehFYAQJKnQ/+OWAE2bZ7mYKTVV0vG4EirLjUcx68oqZ8
CQYfUikFXbxv0BCO8BlbYhlEjv1uw6yRWNQHoJ+iFv3XGtYHXAUNr5n89cv9LQlj
mnmni5Q164mj09u/xSUVKcGZ/SsMnP+h1enKISMtfOZylBjkDO8S/ZuJvQXwwYW0
h4v82HXdxjZdxqFul3oe/X7lhY9hf95b3h4VT6UaKbfUQFpE/6gmeXkC3DRt1fqa
6VOswC+cOW9JDTpozplNp9QQf21YQnNTD2vsiS8Smv0VsNvT0Ex/0I0SCkUuKDPQ
sW1RdIdseJm43lswQTs82oHeVXnDTJ85CH4xzyUA7Rwmb3hz/o38N5QZTOiq3Rlr
+xZGpkH9/k9i+RNOzWsAbcJGOLBcAZ7vYzdrbgefaSOu39nXubCsLzKhGY2SppBx
l/TOWlGvMo5F6ZZ+hR3I3ajZCs+tZ/9TOgehvjAIcVp+ouEwFZXbxqX3WqcAre9b
INnt/fLIzcKKAxyH5J1txnTajTPXKbHK5AboAJopyLxm70qxBeSg05FKAVn/8NQs
Xve9Rjc0rmEOSCC7KvutOy5FyG3AulAsmDwDT3c4QhAoUjrAPVf5XLFazcQ9Z2F7
W2bZ5QEMeH54guisi210Qkb9in0l7NKePWhIhicLlPKliAI9/XuNdEKxUWn235fe
7jqryRjWg2s=
=dN62
-----END PGP SIGNATURE-----

--=-Hk3fLkn01jpUCpvFWvN0--

