Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:45630 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbYLEJv4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 04:51:56 -0500
From: Henning Rogge <rogge@fgan.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Date: Fri, 5 Dec 2008 10:51:44 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Henning Rogge <hrogge@googlemail.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <200812050934.07182.rogge@fgan.de> <1228470310.3970.13.camel@johannes.berg>
In-Reply-To: <1228470310.3970.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart15169086.TSk5oo8A7g";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812051051.52908.rogge@fgan.de> (sfid-20081205_105208_413487_B668EB7E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart15169086.TSk5oo8A7g
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Friday 05 December 2008 10:45:10 schrieb Johannes Berg:
> > Ath9k has it's ***_ratetable which contains a line of data for each
> > transmission range. 20/40Mhz and guard interval is already contained in
> > this table (encoded in "phy" variable). Just the MCS number is missing.
>
> Well, yes, but it's not done uniformly across drivers.
>
> > And I think the intel driver has the necessary data too. If I understand
> > the iwl5000 driver, it pushes the rate index (even for 802.11n) through
> > ieee80211_rx_status into mac80211.
>
> Sort of, yes, but again, in a much different way. We really have to
> rename struct ieee80211_tx_rate to struct ieee80211_txrx_rate and embed
> it into struct ieee80211_rx_status for doing this properly.
How many 802.11n capable drivers exist in mac80211 at the moment ?

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


--nextPart15169086.TSk5oo8A7g
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk4+bAACgkQRIfGfFXsz+DXhQCeMfeix/lUMfhSvWZDfLeC8/Kq
dsIAn13cpZk0r7iNvqkGoXGlKb7kZYsg
=zUzi
-----END PGP SIGNATURE-----

--nextPart15169086.TSk5oo8A7g--
