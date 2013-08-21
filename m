Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from daemonizer.de ([178.77.74.210]:57257 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab3HUQ2R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 12:28:17 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT 00/13] brcmsmac: bcm4313 iPA related patches
Date: Wed, 21 Aug 2013 18:17:30 +0200
Message-ID: <7288564.kdgq91zD8T@eisbaer> (sfid-20130821_182819_717244_585C7B8E)
In-Reply-To: <1376424220-10765-1-git-send-email-arend@broadcom.com>
References: <1376424220-10765-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5740235.tP17FrA7JS"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart5740235.tP17FrA7JS
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday 13 August 2013 22:03:27 Arend van Spriel wrote:
> This series replaces the patch "[PATCH 12/12] brcmsmac: support 4313iPA"
> with Message-ID: <1376130450-29746-13-git-send-email-arend@broadcom.com>.
> 
> It has been split up into individual patches. Please test this series
> especially if you had issues with the original commit b6fc28a that was
> reverted.
> 
> Cc: Jonas Gorski <jogo@openwrt.org>
> Cc: David Herrmann <dh.herrmann@gmail.com>
> Cc: Maximilian Engelhardt <maxi@daemonizer.de>
> Cc: David Costa <david@zarel.net>
> 
> Arend van Spriel (13):
>   brcmsmac: cosmetic change in phy_lcn.c
>   brcmsmac: change pa_gain for bcm4313 iPA
>   brcmsmac: use ARRAY_SIZE in phytbl_lcn.c
>   brcmsmac: add switch control table for BCM4313 iPA BT-combo cards
>   brcmsmac: add debug info message providing phy and radio info
>   brcmsmac: update transmit gain table for lcn phy
>   brcmsmac: change lcnphy receive i/q calibration routine
>   brcmsmac: fix TSSI idle estimation
>   brcmsmac: avoid calling set_txpwr_by_index() twice
>   brcmsmac: rework switch control table init including iPA BT-combo
>   brcmsmac: correct phy registers for TSSI-based power control
>   brcmsmac: reinitialize TSSI power control upon channel switch
>   brcmsmac: add support for BCM4313 iPA variant
> 
>  drivers/net/wireless/brcm80211/brcmsmac/main.c     |    4 +-
>  .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |  397
> +++++++++++-------- .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c   | 
> 405 +++++++++++--------- .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h  
> |    1 +
>  4 files changed, 475 insertions(+), 332 deletions(-)

Hello Arend,

I finally had some time to test your patches.

On my hardware I couldn't find any regressions with these patches. I also 
verified that the reception problems I had with my card are fixed by these 
patches.

I did test the patches on top of 3.10.5 as they did apply without any 
problems.

Greetings,
Maxi
--nextPart5740235.tP17FrA7JS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAABCgAGBQJSFOgcAAoJEIHqZH0kK9IVMwgP/1tUYPaNgLmKcXic7pp3hUmH
kau9mL15AUCUZzLsIak+mLAM05RHEFv/mMGUSEYlhtJ+i1nMC9Bp86/UhLRa25SW
Nsog+0VV+a1W6mqzcUlkanfriog2s7nTZQIbzRIKMbYju3FE6sKibYCRNfG1lT8t
f1NLbg2ve8Yq+Ww/Mq3BsAOJOZtRjt8p0UtUxNbAQvfkNMyJ5d2qOSDqJp303pCK
H+kKrJYalzFWRIq1FAlb2M9R7ZTJYZULmycCxkPvNKd8iLYoXR5OQ9mvo+H2ysju
XAl7XVkuRGibhxhZJZS/Xc6YtN9V3BIhUqMe5fxgESQifG4R1COwzurac8BaRpOL
WgWQ0MwznZYlaapbTmr/GPekD282dkodsPHibXEPCWP4dsVRC5jubyZ8UpH7YHpl
sXUyYKZkwrzNMGawGOrF8uT5Vc0ochBTgONkTFNRWe233Tjbhq/bSTdmeXvg5VAr
2mcTfMk8QeK7aKjUir83IoKTmoLx3XK8GDPAQv7ZcKy2gbpKWCM8LowEOrbv82xp
0I7NMB9LZPZGre3+nsM3cj3Czy3CHH4/vxVHr4e2yJiyj6eJiU0qwO3yzAm9YLpq
A691lbdPn6L4nbH0CnHUAt61lHV0m1+BxhjbV23ozzCQxcyzvtbIO/1o2282Dkkk
FZy3yZC0/WRYRNbl6ymI
=z5j+
-----END PGP SIGNATURE-----

--nextPart5740235.tP17FrA7JS--

