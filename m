Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:51671 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2L0OHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 09:07:35 -0500
Date: Thu, 27 Dec 2012 09:07:31 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Kalle Valo <kvalo@adurom.com>
Cc: Bartosz Markowski <markowski.bartosz@gmail.com>,
	linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: Re: [PATCH 06/17] cw1200: Mini-AP implementation
Message-ID: <20121227140730.GA31475@shaftnet.org> (sfid-20121227_150739_696610_1A3E4613)
References: <1356191120-5280-1-git-send-email-pizza@shaftnet.org>
 <1356191120-5280-7-git-send-email-pizza@shaftnet.org>
 <50D61117.8020009@gmail.com>
 <CAM8CFPgJu5CR9tU_mMw1_0yDUEj-dLk2G+6W91W1-H4LMa+BUw@mail.gmail.com>
 <20121223124734.GB29607@shaftnet.org>
 <CAM8CFPj==UdTjCe0=hPRtT_BC1E4TvRFDjqBZUD4=c+PbkncVA@mail.gmail.com>
 <20121223164408.GA3624@shaftnet.org>
 <87r4mbubhj.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
In-Reply-To: <87r4mbubhj.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 27, 2012 at 10:48:24AM +0200, Kalle Valo wrote:
> > away entirely, so I suspect what's happening is that the LMAC is=20
> > consistently waking up a little too late (or going back to sleep too=20
> > early) to hear the beacons.
> >
> > My guess is that the LMAC is pushing its powersaving margins too close.
>=20
> Or synchronisation to TBTT is busted for some reason, like not
> receiving a beacon before enabling power save etc. (just guessing here).

Unlikely; the "join" command to the LMAC is blocking and won't return=20
until it hears a beacon.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQ3FYiPuLgii2759ARAofTAKDbAkk2Jtirsph/DS8bzC5kdwolngCeO9yx
1n2873i6FutCISEH8ptWSV0=
=Wjzo
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
