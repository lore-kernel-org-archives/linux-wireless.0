Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45203 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab1GZTCa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 15:02:30 -0400
Message-ID: <4E2F0F44.3060105@gnu.org> (sfid-20110726_210234_053964_DC4817E7)
Date: Tue, 26 Jul 2011 15:02:28 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] b43legacy: remove 64-bit DMA support
References: <20110725213832.32510.3753.stgit@mj.roinet.com> <4E2EFDCC.3060604@lwfinger.net>
In-Reply-To: <4E2EFDCC.3060604@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/26/2011 01:47 PM, Larry Finger wrote:
> On 07/25/2011 04:40 PM, Pavel Roskin wrote:
>> Devices supported by b43legacy don't support 64-bit DMA.
>>
>> Signed-off-by: Pavel Roskin<proski@gnu.org>
>> ---
>> The patch was tested on Broadcom 4306.
>>
>> drivers/net/wireless/b43legacy/dma.c | 374
>> ++++++----------------------------
>> drivers/net/wireless/b43legacy/dma.h | 107 ----------
>> 2 files changed, 71 insertions(+), 410 deletions(-)
>
> Tested on BCM4303.

Appreciated!

>> + value&= B43legacy_DMA32_RXSTATE;
>
> I am surprised that checkpatch doesn't see the spacing around the &= as
> an error.

It's a Mozilla Thunderbird bug.  What you are seeing is not what I sent.

checkpatch would catch that in the real code.

-- 
Regards,
Pavel Roskin
