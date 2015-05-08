Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33590 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbbEHMW3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 08:22:29 -0400
Received: by igbpi8 with SMTP id pi8so29733044igb.0
        for <linux-wireless@vger.kernel.org>; Fri, 08 May 2015 05:22:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <554C8D96.9030205@broadcom.com>
References: <1431030535-11083-1-git-send-email-zajec5@gmail.com>
	<554C81D2.8080602@broadcom.com>
	<CACna6rxV_sR1WhrHRwtM8cjengsCbm_iUWzy0n_+fLYmxypmMw@mail.gmail.com>
	<554C8D96.9030205@broadcom.com>
Date: Fri, 8 May 2015 14:22:29 +0200
Message-ID: <CACna6rzR4r_dKjAT+EMNMU7fPuHxNa=VTdkNQ41uy5mKy4XgMw@mail.gmail.com> (sfid-20150508_142232_895776_736AAA40)
Subject: Re: [PATCH RFC:rxctl wait timed out] brcmfmac: add BCM43526 USB support
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 May 2015 at 12:19, Arend van Spriel <arend@broadcom.com> wrote:
> On 05/08/15 11:53, Rafał Miłecki wrote:
>> Do you have any idea about BCM43526 rev 3+? The chipsets using 43526b
>> instead of 43526a. Any chance BCM43526 rev 3+ is normal FullMAC device
>> just like BCM43236 rev 3+?
>
>
> I don't know. Main thing needed for that is more on-chip memory, which makes
> it a bit more expensive. This may be a deal breaker for existing 43526
> customers unless they like the fullmac advantages they get for their money.

Could you ask someone at Broadcom about this 43526 rev 3+?

I've checked Asus's firmware for AC53U and it contains wl.ko and
wl_high.ko. Their wl_high.ko was compiled with 43236b-bmac-usbap,
43526b-bmac-usbap and 4360b-bmac-usbap built-in. But I still have no
idea if this wl_high.ko with 43526b support is for FullMAC hardware or
not.

-- 
Rafał
