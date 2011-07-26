Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54832 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab1GZUFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 16:05:05 -0400
Received: by pzk37 with SMTP id 37so1382542pzk.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 13:05:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E2EFDCC.3060604@lwfinger.net>
References: <20110725213832.32510.3753.stgit@mj.roinet.com>
	<4E2EFDCC.3060604@lwfinger.net>
Date: Tue, 26 Jul 2011 22:05:04 +0200
Message-ID: <CACna6ryV7ffeuC_6cZdAB_WG4+fOHSbnxiCAV2-Mmkp58o_4=A@mail.gmail.com> (sfid-20110726_220511_273458_73B76312)
Subject: Re: [PATCH] b43legacy: remove 64-bit DMA support
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/26 Larry Finger <Larry.Finger@lwfinger.net>:
> On 07/25/2011 04:40 PM, Pavel Roskin wrote:
>>
>> Devices supported by b43legacy don't support 64-bit DMA.
>>
>> Signed-off-by: Pavel Roskin<proski@gnu.org>
>> ---
>> The patch was tested on Broadcom 4306.
>>
>>  drivers/net/wireless/b43legacy/dma.c |  374
>> ++++++----------------------------
>>  drivers/net/wireless/b43legacy/dma.h |  107 ----------
>>  2 files changed, 71 insertions(+), 410 deletions(-)
>
> Tested on BCM4303.

Err, BCM4303? What card is that exactly?

-- 
Rafał
