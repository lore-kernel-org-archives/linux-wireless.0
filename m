Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbXIGTPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 15:15:38 -0400
Subject: Re: [PATCH] mac80211: remove turbo modes
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Zhu Yi <yi.zhu@intel.com>, Jiri Slaby <jirislaby@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <43e72e890709071014w1f37b4acjac3c98c306a965de@mail.gmail.com>
References: <1188485253.3978.22.camel@johannes.berg>
	 <43e72e890709071014w1f37b4acjac3c98c306a965de@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DoAR9f4H8jIrN09supQh"
Date: Fri, 07 Sep 2007 21:16:45 +0200
Message-Id: <1189192606.28781.189.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DoAR9f4H8jIrN09supQh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-07 at 13:14 -0400, Luis R. Rodriguez wrote:

> Can you elaborate a bit on what places (one would suffice) we should
> be checking for them that would prevent failure so that we know where
> to correct this later when we want to add support for these modes in
> ath5k?

There's the monitor stuff which certainly wasn't correct, turbo A surely
uses OFDM/5GHz. Also, ISTR that there was something with turbo G not
handled properly, but it's been a while, sorry.

I'm not sure what we should do, I'm undecided about adding a whole bunch
of proprietary rates back since these are basically only supported by
one hardware. Let's discuss good ways to do this when you get around to
it.

johannes

--=-DoAR9f4H8jIrN09supQh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4aOd/ETPhpq3jKURAnRQAKC4yJbiYyszE8LTQguQTu47wqcXlACeOVRw
APCVK1H2Ok7nwTUN9JiFq3I=
=lfmC
-----END PGP SIGNATURE-----

--=-DoAR9f4H8jIrN09supQh--

