Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63906 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1GZU4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 16:56:20 -0400
Received: by gxk21 with SMTP id 21so583581gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 13:56:19 -0700 (PDT)
Message-ID: <4E2F29F0.8040506@lwfinger.net> (sfid-20110726_225634_167900_6B718EE0)
Date: Tue, 26 Jul 2011 15:56:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43legacy: remove 64-bit DMA support
References: <20110725213832.32510.3753.stgit@mj.roinet.com>	<4E2EFDCC.3060604@lwfinger.net> <CACna6ryV7ffeuC_6cZdAB_WG4+fOHSbnxiCAV2-Mmkp58o_4=A@mail.gmail.com>
In-Reply-To: <CACna6ryV7ffeuC_6cZdAB_WG4+fOHSbnxiCAV2-Mmkp58o_4=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/26/2011 03:05 PM, Rafał Miłecki wrote:
> 2011/7/26 Larry Finger<Larry.Finger@lwfinger.net>:
>> On 07/25/2011 04:40 PM, Pavel Roskin wrote:
>>>
>>> Devices supported by b43legacy don't support 64-bit DMA.
>>>
>>> Signed-off-by: Pavel Roskin<proski@gnu.org>
>>> ---
>>> The patch was tested on Broadcom 4306.
>>>
>>>   drivers/net/wireless/b43legacy/dma.c |  374
>>> ++++++----------------------------
>>>   drivers/net/wireless/b43legacy/dma.h |  107 ----------
>>>   2 files changed, 71 insertions(+), 410 deletions(-)
>>
>> Tested on BCM4303.
>
> Err, BCM4303? What card is that exactly?

It is a 14e4:4301 802.11b card in a PCI format. The lspci command also calls it 
a Linksys WMP11 v2.7 802.11b Wireless-B PCI Adapter.

Larry
