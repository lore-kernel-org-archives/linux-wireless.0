Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:61891 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042AbYLLPcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 10:32:02 -0500
Received: by ewy10 with SMTP id 10so1812526ewy.13
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 07:32:00 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH 3/3] mac80211: Add HT rates into radiotap
Date: Fri, 12 Dec 2008 16:31:51 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Stefanik =?iso-8859-1?q?G=E1bor?= <netrolller.3d@gmail.com>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Thomas d'Otreppe" <tdotreppe@aircrack-ng.org>
References: <20081212123832.506588839@atheros.com> <1229093327.3600.12.camel@johannes.berg> <20081212151619.GA16981@jm.kir.nu>
In-Reply-To: <20081212151619.GA16981@jm.kir.nu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2413768.vEn8WGKNu2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812121631.56952.hrogge@googlemail.com> (sfid-20081212_163209_244586_E3843DE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2413768.vEn8WGKNu2
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 12 December 2008 16:16:19 Jouni Malinen wrote:
> While I'm not against defining something more officially for radiotap,
> I do not agree with the part about this format being that brain-dead.
> Both 40 MHz and short GI are indicated (IEEE80211_CHAN_TURBO and
> IEEE80211_RADIOTAP_F_SHORTGI) and shown in the current wireshark
> release.
Changing the meaning of the old "txrate" field (by putting an index inside)=
 is=20
a great way to break the userspace interface to any existing program. :(

Just get a new field for the mcs index.

Henning

--nextPart2413768.vEn8WGKNu2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAklCg+wACgkQcenvcwAcHWd4iQCfVbNOV0ehiP6UM6G1AdwlEuLN
xeQAn3Osou84rax1VJP704viXGVtku8t
=t+H7
-----END PGP SIGNATURE-----

--nextPart2413768.vEn8WGKNu2--
