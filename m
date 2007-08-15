Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:17217 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752921AbXHOG50 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 02:57:26 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Volker Braun <volker.braun@physik.hu-berlin.de>
Subject: Re: [PATCHv3] mac80211: dynamic wep
Date: Tue, 14 Aug 2007 23:55:23 -0700
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
References: <1187151162.3253.18.camel@thinkpad>
In-Reply-To: <1187151162.3253.18.camel@thinkpad>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9065924.CAlDRaNPUT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708142355.27708.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart9065924.CAlDRaNPUT
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 14 August 2007 21:12, Volker Braun wrote:
> 2) Don't make assumptions about keyidx=3D=3D0 on unicast keys.
>
I'm curious.. does decryption still work if unicast keys with keyidx > 0 ar=
e=20
turned into regular keys? I suspect keyidx > 0 is done to allow hardware=20
without individual WEP key support to continue using hardware WEP.

=2DMichael Wu

--nextPart9065924.CAlDRaNPUT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGwqNfT3Oqt9AH4aERAuldAKCMBXIBhQ6apdrzu6naMz1CJjD9tgCeNtkz
5BlOycSDdwIAN3cej4M6tIA=
=6+bQ
-----END PGP SIGNATURE-----

--nextPart9065924.CAlDRaNPUT--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
