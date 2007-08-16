Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:28207 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750837AbXHPFAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 01:00:09 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Volker Braun <volker.braun@physik.hu-berlin.de>
Subject: Re: [PATCHv3] mac80211: dynamic wep
Date: Wed, 15 Aug 2007 21:58:11 -0700
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
References: <1187151162.3253.18.camel@thinkpad> <200708142355.27708.flamingice@sourmilk.net> <1187191455.6462.14.camel@carrot.hep.upenn.edu>
In-Reply-To: <1187191455.6462.14.camel@carrot.hep.upenn.edu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart131919214.fcBQaWvTTv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708152158.11677.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart131919214.fcBQaWvTTv
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 15 August 2007 08:24, Volker Braun wrote:
> I've wondered for a long time why Cisco chose to use keyidx>0 for WEP
> unicast keys, but I think I finally understand that this is a weird
> feature (8.5.1): In a mixed WEP and TKIP network a WEP key[0] would
> conflict with the TKIP key (which must have keyidx =3D=3D 0), forcing a d=
umb
> TKIP STA to downgrade to WEP. (A good TKIP STA would just rely on
> per-STA keys and not have this problem)
>
Hm.. I'm not really convinced that this is the main reason. Can you check a=
nd=20
see if the keyidx that wpa_supplicant configures and the keyidx used in=20
unicast frames are the same?

=2DMichael Wu

--nextPart131919214.fcBQaWvTTv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGw9ljT3Oqt9AH4aERAiHfAJ9H4y9ZfaVFc7tFXIU5MSNlbeoPiQCgiay9
MtgKbsVliw+npDMff+BFN5c=
=g4V/
-----END PGP SIGNATURE-----

--nextPart131919214.fcBQaWvTTv--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
