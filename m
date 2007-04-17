Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:32239 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030869AbXDQTPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2007 15:15:48 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Stefan Puch <stefan.puch@mail.uni-oldenburg.de>
Subject: Re: prism54: WPA/RSN support for fullmac cards
Date: Tue, 17 Apr 2007 15:12:22 -0400
Cc: linux-wireless@vger.kernel.org
References: <462336B1.4090006@mail.uni-oldenburg.de> <1176732546.27418.9.camel@localhost.localdomain> <4625130F.4090104@mail.uni-oldenburg.de>
In-Reply-To: <4625130F.4090104@mail.uni-oldenburg.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4691893.qk1xEKdcZg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704171512.32564.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4691893.qk1xEKdcZg
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 17 April 2007 14:33, Stefan Puch wrote:
> I thought that at least chunkeey got a working connection.... obviously
> not.
>
> Is there anything else I can do if I'm no Kernel Programmer (perhaps
> provide more infos, do some other beta testings)?
>
> When I looked on the prism54.org homepage or their svn-repository it seems
> that the driver is not developed any longer.
> What is about Christian Lamparter (chunkee) or Luis R. Rodriguez (mcgrof)
> are they still working on it?
>
Christian Lamparter now works on the mac80211 softmac driver (p54 in=20
wireless-dev) and Luis gave up on getting WPA to work on fullmac IIRC.=20
Easiest way to get WPA working right now is to run a softmac driver.

=2DMichael Wu

--nextPart4691893.qk1xEKdcZg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGJRwgT3Oqt9AH4aERAhkAAJ9ugmOXYESXNMSJiX+iKB4ylF3w9wCgp9N2
ToxgepUvuS8c/pClEhlO9WA=
=wpku
-----END PGP SIGNATURE-----

--nextPart4691893.qk1xEKdcZg--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
