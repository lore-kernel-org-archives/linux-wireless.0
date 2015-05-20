Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:24418 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbbETORv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 10:17:51 -0400
Message-ID: <555C9789.9010709@broadcom.com> (sfid-20150520_161755_253022_0D2FDD60)
Date: Wed, 20 May 2015 16:17:45 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH RESEND] mips: bcm47xx: allow retrieval of complete nvram
 contents
References: <1432122655-3224-1-git-send-email-arend@broadcom.com>	<CACna6rxeU0FUiTRNXFgK-xxSDY8WA82h7MLmcPc=7eM5sqMdBw@mail.gmail.com>	<555C83FC.7010701@broadcom.com> <CACna6rw3ZgJSLrR=kNKDNgcLHz7-bZjaObv2zuTgmWWeUtLSUw@mail.gmail.com>
In-Reply-To: <CACna6rw3ZgJSLrR=kNKDNgcLHz7-bZjaObv2zuTgmWWeUtLSUw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/20/15 15:48, Rafał Miłecki wrote:
> On 20 May 2015 at 14:54, Arend van Spriel<arend@broadcom.com>  wrote:
>> On 05/20/15 14:31, Rafał Miłecki wrote:
>>>
>>> On 20 May 2015 at 13:50, Arend van Spriel<arend@broadcom.com>   wrote:
>>>>
>>>> From: Hante Meuleman<meuleman@broadcom.com>
>>>>
>>>> Host platforms such as routers supported by OpenWRT can
>>>> support NVRAM reading directly from internal NVRAM store.
>>>> The brcmfmac for one requires the complete nvram contents
>>>> to select what needs to be sent to wireless device.
>>>
>>>
>>> First of all, I have to ask you to rebase this patch on top of
>>> upstream-sfr. Mostly because of
>>> MIPS: BCM47XX: Make sure NVRAM buffer ends with \0
>>
>>
>> No idea what upstream-sfr is. I applied the patch on top of the master
>> branch of linux-mips repo [1]. What am I missing here?
>>
>> [1] http://git.linux-mips.org/cgit/ralf/linux.git
>
> Just go a dir higher and you'll find it :)
> http://git.linux-mips.org/cgit/
>
> Its a repo with mips-for-linux-next branch you're looking for.

Thanks. Found it.

Regards,
Arend
