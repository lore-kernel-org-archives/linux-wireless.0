Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:63608 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdH0Q32 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Aug 2017 12:29:28 -0400
Date: Sun, 27 Aug 2017 18:29:22 +0200 (CEST)
From: Stefan Wahren <stefan.wahren@i2se.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, linux-firmware@kernel.org
Message-ID: <8895990.50878.1503851362513@email.1und1.de> (sfid-20170827_183107_717357_BB51999C)
In-Reply-To: <1503846841.3688.92.camel@decadent.org.uk>
References: <1503846841.3688.92.camel@decadent.org.uk>
Subject: Re: CVE-2017-9417 and brcmfmac
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

> Ben Hutchings <ben@decadent.org.uk> hat am 27. August 2017 um 17:14 geschrieben:
> 
> 
> The CVE-2017-9417 aka "Broadpwn" vulnerability is said to affect the
> firmware for various Broadcom BCM43xx wifi chips, some of which are
> supported by the in-tree brcmfmac driver and firmware in linux-
> firmware.git.
> 
> The bcmdhd driver for Android was patched to improve validation of
> events from the firmware:
> https://android.googlesource.com/kernel/msm.git/+/android-6.0.1_r0.92%5E!/
> But the event handling code in
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c still seems to
> lack most of those checks.  Should it be patched?
> 
> I also haven't seen any related updates for BCM43xx firmware in linux-
> firmware.git.  Is any of this firmware vulnerable?

according to this comment [1] at least 43438 is affected.

[1] - https://github.com/raspberrypi/linux/issues/1342#issuecomment-321221748

> 
> Ben.
> 
> -- 
> Ben Hutchings
> Teamwork is essential - it allows you to blame someone else.
