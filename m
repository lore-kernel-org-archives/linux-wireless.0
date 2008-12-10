Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:39909 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbYLJGyD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 01:54:03 -0500
From: Henning Rogge <rogge@fgan.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] Add signal strength and bandwith to nl80211station info
Date: Wed, 10 Dec 2008 07:53:50 +0100
Cc: Henning Rogge <hrogge@googlemail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <200812092050.29545.hrogge@googlemail.com> <1228857372.1029.25.camel@johannes.berg>
In-Reply-To: <1228857372.1029.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2775973.zFxvxpJi0C";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812100753.58590.rogge@fgan.de> (sfid-20081210_075407_745035_10B82D27)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2775973.zFxvxpJi0C
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Tuesday 09 December 2008 22:16:12 schrieb Johannes Berg:
> No, that's the thing, for 32 through 76 the calculated values are
> totally wrong, that isn't a logical extension of the scheme, MCS 73 for
> 20 MHz for example is:
>
> four streams, using 64-qam, 64-qam, 16-qam, qpsk with a coding rate of
> 3/4 for a net bitrate of 195.0 MBits

Maybe you can just post the whole mcs 32-76 table, so I can look at it. I c=
an=20
only work with the values in the wiki, and at the moment the calculation=20
matchs them very well.

Henning

*************************************************
Diplom Informatiker Henning Rogge
=46orschungsgesellschaft f=FCr
Angewandte Naturwissenschaften e. V. (FGAN)=20
Neuenahrer Str. 20, 53343 Wachtberg, Germany
Tel.: 0049 (0)228 9435-961
=46ax: 0049 (0)228 9435-685
E-Mail: rogge@fgan.de
Web: www.fgan.de
************************************************
Sitz der Gesellschaft: Bonn
Registergericht: Amtsgericht Bonn VR 2530
Vorstand: Dr. rer. nat. Ralf Dornhaus (Vors.), Prof. Dr. Joachim Ender=20
(Stellv.)


--nextPart2775973.zFxvxpJi0C
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk/Z34ACgkQRIfGfFXsz+BI1wCfeg6iIwmhiqC13zKIA14LGwiv
8D4An2RpPgeAqmv+WVlmck+j+YII9HE2
=pbwN
-----END PGP SIGNATURE-----

--nextPart2775973.zFxvxpJi0C--
