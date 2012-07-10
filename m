Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:34989 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab2GJFFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 01:05:19 -0400
Received: by weyx8 with SMTP id x8so1796835wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 22:05:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FFB4E8F.4020900@hauke-m.de>
References: <1341864848-9707-1-git-send-email-zajec5@gmail.com>
	<4FFB4E8F.4020900@hauke-m.de>
Date: Tue, 10 Jul 2012 07:05:17 +0200
Message-ID: <CACna6ryNGZJdC3WnNoAXfO8fPUdhOYESTJu-QJJ7yfxQh1Tftg@mail.gmail.com> (sfid-20120710_070523_126804_56AC02DD)
Subject: Re: [RFC][PATCH] bcma: support alternative (BCM4706) ChipCommon core id
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/9 Hauke Mehrtens <hauke@hauke-m.de>:
> Hi Rafał,
>
> Could you add some info why you haven't replaced all places where
> BCMA_CORE_CHIPCOMMON was used with this functions in the commit message.

I see you mean "bcma_bus_resume". I should have replaced it anyway, to
avoid confusion.


> By the way, why is bcma_find_core() beeing called in bcma_bus_resume()?
> The code should better check for bus->drv_cc.core and not for core.

Sounds sane.

-- 
Rafał
