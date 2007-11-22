Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56424 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbXKVO43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 09:56:29 -0500
Subject: Re: [PATCH 1/1] mac80211: restructuring data Rx handlers
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <rindjon@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <1195743268.4149.11.camel@johannes.berg> (sfid-20071122_145444_120393_E4B13536)
References: <11956348193070-git-send-email-ron.rindjunsky@intel.com>
	 <1195732107.6323.84.camel@johannes.berg>
	 <c85cb4470711220649vd83b72lf0e6ae537b359c93@mail.gmail.com>
	 (sfid-20071122_144914_479017_8BEBD1D8)  <1195743268.4149.11.camel@johannes.berg>
	 (sfid-20071122_145444_120393_E4B13536)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TKu9pKfcdKzqCx3A5Mga"
Date: Thu, 22 Nov 2007 15:56:24 +0100
Message-Id: <1195743384.4149.12.camel@johannes.berg> (sfid-20071122_145632_064288_F2A111EA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TKu9pKfcdKzqCx3A5Mga
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Yes, that would work too. I'm not entirely sure about the effect on
> eapol handling but I'll sort that out with that patch then. At worst I
> get to restructure the code instead of you :)

Actually, what I did in that patch is move the eapol decision out of the
port control function which is probably better. Anyway, if you can do
the restructuring and make it work as it is now, I'll do the rest.

johannes

--=-TKu9pKfcdKzqCx3A5Mga
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0WYlqVg1VMiehFYAQJNVg//eUcwXUd0e2ya46ol5N5k9rt/bRIJxbOa
VMaQmPkH/rOqYiBUE1XmrCFiHJfW4HCYBEwJgM5qQep1I9Nnphrisx4bxOf1jhTA
P65UXgE6i9R/sSQDGej1vOcJB0vnOZjJB72GSsiht6BUGhxtCvKCfXka65HUExMV
fKWW2AoN5draX2Lu4Rg0HSQpQO6CXDAMhJizRSmESnVizLVHale7ptl/f7dbP2my
fH3Siptj/X4JypyX08wMAxm2NHm+kLHl8UI/8hmp9In0sLCW/3QQpPyP4o2IOe8A
eoxi4jiYPh6BsvqY4LhJorzEhiCO3bufB1zbr11FAGpvfnPV0t2WOUAW4CbYgD3z
LR2WsOOOig/N7eKRBi0C9OKVvWBO5+/nTH6w15CQOTQxwOGFebQirOrh+Ey0tfGM
vf4qJM9GEclGg3Fyc1fBewDJN5h/jYz3Bv9xhcDJ8Z2uiRXkjFHKqGiQV+fw4UB0
bRSYpueexDKPD4ltMmPZaEF/PaflFO9eLSgHClyGiSBTxQsq0dgeNUr8D8lcm4Oh
9mMt2uRj1Y8Hgtasi5Sn/gUBvznxGZVk0CwjD6kyQ9LsoySXEeQMJy08K1u+TxZX
gATmA/bmmskD3JGkWz2XNBpX2ggPrc64gUvtDtPuFViXCB1xvu/4tLQ4Qvsum/hj
WHfAXm6ob1o=
=iH/D
-----END PGP SIGNATURE-----

--=-TKu9pKfcdKzqCx3A5Mga--

