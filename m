Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56227 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1GUWbE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 18:31:04 -0400
Received: by gyh3 with SMTP id 3so890176gyh.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 15:31:03 -0700 (PDT)
Message-ID: <4E28A8A4.3080509@lwfinger.net> (sfid-20110722_003114_144298_6D005D0B)
Date: Thu, 21 Jul 2011 17:31:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43legacy: dma: cache translation (routing bits)
References: <1311287100-3888-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1311287100-3888-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/21/2011 05:25 PM, Rafał Miłecki wrote:
>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
> Ideally this should have been applied before:
> ssb: return correct translation bit for 64-bit DMA
>
> This is because mentioned patch added TMSHIGH register read on every
> ssb_dma_translation call which affected performance.
>
> If we can live with affected performance between that 2 commits, please
> just apply this ASAP.
>
> It affected performance (however I don't expect anything like making it
> 90% slower) is not acceptable, please revert mentioned patch, apply this
> one and then re-apply reverted patches.

I will be testing this patch ASAP. Unfortunately, my test box with a b43legacy 
device crashes on boot with wireless-testing with a fresh pull this afternoon. 
It does boot with commit d36a160 with only 70 commits between. It shouldn't take 
too long to sort out.

Larry
