Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49428 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1GZTMv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 15:12:51 -0400
Received: by iyb12 with SMTP id 12so816124iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 12:12:50 -0700 (PDT)
Message-ID: <4E2F11AE.1030608@lwfinger.net> (sfid-20110726_211256_115737_78D8C7F6)
Date: Tue, 26 Jul 2011 14:12:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] b43legacy: remove 64-bit DMA support
References: <20110725213832.32510.3753.stgit@mj.roinet.com> <4E2EFDCC.3060604@lwfinger.net> <4E2F0F44.3060105@gnu.org>
In-Reply-To: <4E2F0F44.3060105@gnu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/26/2011 02:02 PM, Pavel Roskin wrote:
> On 07/26/2011 01:47 PM, Larry Finger wrote:
>> On 07/25/2011 04:40 PM, Pavel Roskin wrote:
>>> Devices supported by b43legacy don't support 64-bit DMA.
>>>
>>> Signed-off-by: Pavel Roskin<proski@gnu.org>
>>> ---
>>> The patch was tested on Broadcom 4306.
>>>
>>> drivers/net/wireless/b43legacy/dma.c | 374
>>> ++++++----------------------------
>>> drivers/net/wireless/b43legacy/dma.h | 107 ----------
>>> 2 files changed, 71 insertions(+), 410 deletions(-)
>>
>> Tested on BCM4303.
>
> Appreciated!
>
>>> + value&= B43legacy_DMA32_RXSTATE;
>>
>> I am surprised that checkpatch doesn't see the spacing around the &= as
>> an error.
>
> It's a Mozilla Thunderbird bug. What you are seeing is not what I sent.
>
> checkpatch would catch that in the real code.

Ahh. The BCM4303 is in a different machine than I the one used to do Email. 
Saving the message from Thunderbird to an NFS-mounted device and copying to the 
test machine came out right. When I saw it in the mail, I ran checkpatch, saw 
that it was clean, and failed to check the actual patch that I had applied. 
Interesting.

Larry

