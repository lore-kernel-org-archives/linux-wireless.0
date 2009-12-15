Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:54115 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933675AbZLOVHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 16:07:34 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] [PATCH 1/5] nl80211: Add new WIPHY attribute COVERAGE_CLASS
Date: Tue, 15 Dec 2009 22:07:32 +0100
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
References: <1260899813-17585-1-git-send-email-8an@praha12.net> <20091215190051.GC2123@tux> <20091215190248.GE2123@tux>
In-Reply-To: <20091215190248.GE2123@tux>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart42040953.p68eGmbDD9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912152207.33024.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart42040953.p68eGmbDD9
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 15.12.2009 20:02 you wrote:
> And if your IBSS and the AP already sent the coverage class through the
> country IE I am not sure if we should allow overriding it.
Overriding the coverage class is harmless, it won't allow you to break any=
=20
laws like overriding regulatory domain does.

Lukas Turek

--nextPart42040953.p68eGmbDD9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLJ/qUAAoJEEBjvk/UOfYwON0P/2q+GNcXsyXlqhgUyodgWFuj
523TArSQJXQi05aqnYGiG22fLNVOKKurBTqJNcivBTfCFyz9g8SE3jD9Eg3Eb+up
7xfCDuZ+H37a00kR/SoDyEWWxRgR2RRe07/DE+hsbNtixMrX5jDDdSG8Mz+MV1th
TLnbc8jgYN9x9TDi3UNlalU+YzlCw4X4XVhRN/OWYecPvcjlyLGh5IY87SMzt08j
ltlkCK2YxCsLP79vJIF8dQrpDN97KerCP6L2Bpq84WHkePuYDymVr0DhSw4nWt3v
hPBs7UDUJtUFgczEp/SUXnrhQtR8tLI+sUoC9Lgy+1OoxP4rEJUlJzz7Y99IFC1V
uysRVuqhSAj26J2mJWwcF+0x7TjSB/RTzTwtAi/TKA2zsQE4tTu2+rDp/3P/o4oi
qU14WgEkXuRvetQlXQJ2bFQ07UsTxT3LG3klvcpiYjoY903VwIdCJB+54VIdHRSG
2PSgIzOoykYWNI9O+E5L4z3f2i6HnBUQgjCaEX9hirrBLbH5S76DCKUqvBr066Jk
l9z9umVomZnCyopKKqMeReSd88ZmQ0BUP0BFtgiiw9GFHc2W1C9HTvKHj5TGbnRy
xGk1z9eMk0h8mwkxTB4Onk58h8SOThpJmaJA8WjIkRgKNgqWlXUv89O2z9m+VpYW
mFKWm/TEJu/PCBEv1BX3
=e7ql
-----END PGP SIGNATURE-----

--nextPart42040953.p68eGmbDD9--
