Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39978 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab1D1Afa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 20:35:30 -0400
Received: by eyx24 with SMTP id 24so675349eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 17:35:29 -0700 (PDT)
From: Maciej Mrozowski <reavertm@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] Wrt TP-Link TL-WN821N V3 (confusing/missing info on wiki)
Date: Thu, 28 Apr 2011 02:35:20 +0200
References: <201104221852.41733.reavertm@gmail.com> <19891.57900.438639.178988@gargle.gargle.HOWL>
In-Reply-To: <19891.57900.438639.178988@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2988352.JPacJv5W5z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201104280235.20751.reavertm@gmail.com> (sfid-20110428_023534_172690_A599910D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2988352.JPacJv5W5z
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 24 of April 2011 10:41:16 Sujith wrote:

Hello

> > (it stopped working completely recently in wireless-testing though:
> > ieee80211 phy0: device no longer idle - working
> > wlan0: direct probe to 68:7f:74:77:36:bc (try 1/3)
> > wlan0: direct probe to 68:7f:74:77:36:bc (try 2/3)
> > wlan0: direct probe to 68:7f:74:77:36:bc (try 3/3)
> > wlan0: direct probe to 68:7f:74:77:36:bc timed out
> > ieee80211 phy0: device now idle
> > but that's different a story)
>=20
> How recent is your wireless-testing tree ?
>=20
> Can you post the debug log ?
> See: http://wireless.kernel.org/en/users/Drivers/ath9k/debug

It was some wireless-testing master from around a week ago.
Now I've re-cloned it again (since git pull resulted in conflicts for some=
=20
reason), I'm at 903e9c0102cb9b4b3b1560df31f9b46650cdea88 and using htc_7010=
=2Efw=20
from http://wireless.kernel.org/download/htc_fw/1.1/ - and so far so good :)

I'll testfield it for a while and see whether it drops connection after som=
e=20
time or after "some bandwidth is exceeded" like it appeared to in a past (b=
ut=20
if was at times when the most recent firmware was still sitting in linux-
firmware repo, I think I experienced the same results with stock kernel 2.6=
=2E37=20
ath9k_htc driver and corresponding wireless-testing, many things has change=
s=20
since then and I'm optimistic)

regards
MM

(that's not exactly full debug, just I quick look, if there are to be any=20
issues, I'll provide full debug respectively)

usb 1-2: new high speed USB device number 5 using ehci_hcd
usb 1-2: ath9k_htc: Transferred FW: htc_7010.fw, size: 72996
ath9k_htc 1-2:1.0: ath9k_htc: HTC initialized with 45 credits
ath9k_htc 1-2:1.0: ath9k_htc: FW Version: 1.1
ath: EEPROM regdomain: 0x809c
ath: EEPROM indicates we should expect a country code
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x52
ath: Country alpha2 being used: CN
ath: Regpair used: 0x52
cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
cfg80211: Disabling freq 2467 MHz as custom regd has no rule that fits a 20=
=20
MHz wide channel
cfg80211: Disabling freq 2472 MHz as custom regd has no rule that fits a 20=
=20
MHz wide channel
cfg80211: Disabling freq 2484 MHz as custom regd has no rule that fits a 20=
=20
MHz wide channel
cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (600 mBi, 2000 mBm)
cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (600 mBi, 2000 mBm)
cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (600 mBi, 2000 mBm)
cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width=20
channel with regulatory rule:
cfg80211: 2474000 KHz - 2494000 KHz @  KHz), (600 mBi, 2000 mBm)
cfg80211: Pending regulatory request, waiting for it to be processed...
ieee80211 phy2: Atheros AR9287 Rev:2
Registered led device: ath9k-phy2::radio
Registered led device: ath9k-phy2::assoc
Registered led device: ath9k-phy2::tx
Registered led device: ath9k-phy2::rx
usb 1-2: ath9k_htc: USB layer initialized
ieee80211 phy2: device now idle
cfg80211: Pending regulatory request, waiting for it to be processed...
ieee80211 phy2: device no longer idle - scanning
ieee80211 phy2: device now idle
ieee80211 phy2: device no longer idle - working
wlan0: authenticate with 68:7f:74:77:36:bc (try 1)
wlan0: authenticated
wlan0: associate with 68:7f:74:77:36:bc (try 1)
wlan0: RX AssocResp from 68:7f:74:77:36:bc (capab=3D0x531 status=3D0 aid=3D=
1)
wlan0: associated
ieee80211 phy2: Allocated STA 68:7f:74:77:36:bc
ieee80211 phy2: Inserted STA 68:7f:74:77:36:bc
ieee80211 phy2: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D3 cWmin=3D15 cWmax=3D1=
023 txop=3D0=20
uapsd=3D0
ieee80211 phy2: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 cWmax=3D1=
023 txop=3D0=20
uapsd=3D0
ieee80211 phy2: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D15=
 txop=3D94=20
uapsd=3D0
ieee80211 phy2: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 cWmax=3D7 =
txop=3D47 uapsd=3D0
cfg80211: Pending regulatory request, waiting for it to be processed...
Rx A-MPDU request on tid 7 result 0
Open BA session requested for 68:7f:74:77:36:bc tid 0
activated addBA response timer on tid 0
switched off addBA timer for tid 0
Aggregation is on for tid 0
Rx A-MPDU request on tid 0 result 0

=2D-=20
regards
MM

--nextPart2988352.JPacJv5W5z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEABECAAYFAk24tkgACgkQFuHa/bHpVdsmNwCfYBAi3Mm8teX7K50Gxy0A+F5i
T6sAnivQchKYlBTBPGfJHZFZAaTHQZMH
=V3rD
-----END PGP SIGNATURE-----

--nextPart2988352.JPacJv5W5z--
