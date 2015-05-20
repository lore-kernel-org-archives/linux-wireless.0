Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34373 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbbETNsW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 09:48:22 -0400
Received: by ieczm2 with SMTP id zm2so39421710iec.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2015 06:48:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <555C83FC.7010701@broadcom.com>
References: <1432122655-3224-1-git-send-email-arend@broadcom.com>
	<CACna6rxeU0FUiTRNXFgK-xxSDY8WA82h7MLmcPc=7eM5sqMdBw@mail.gmail.com>
	<555C83FC.7010701@broadcom.com>
Date: Wed, 20 May 2015 15:48:21 +0200
Message-ID: <CACna6rw3ZgJSLrR=kNKDNgcLHz7-bZjaObv2zuTgmWWeUtLSUw@mail.gmail.com> (sfid-20150520_154826_501663_A3A40536)
Subject: Re: [PATCH RESEND] mips: bcm47xx: allow retrieval of complete nvram contents
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 May 2015 at 14:54, Arend van Spriel <arend@broadcom.com> wrote:
> On 05/20/15 14:31, Rafał Miłecki wrote:
>>
>> On 20 May 2015 at 13:50, Arend van Spriel<arend@broadcom.com>  wrote:
>>>
>>> From: Hante Meuleman<meuleman@broadcom.com>
>>>
>>> Host platforms such as routers supported by OpenWRT can
>>> support NVRAM reading directly from internal NVRAM store.
>>> The brcmfmac for one requires the complete nvram contents
>>> to select what needs to be sent to wireless device.
>>
>>
>> First of all, I have to ask you to rebase this patch on top of
>> upstream-sfr. Mostly because of
>> MIPS: BCM47XX: Make sure NVRAM buffer ends with \0
>
>
> No idea what upstream-sfr is. I applied the patch on top of the master
> branch of linux-mips repo [1]. What am I missing here?
>
> [1] http://git.linux-mips.org/cgit/ralf/linux.git

Just go a dir higher and you'll find it :)
http://git.linux-mips.org/cgit/

Its a repo with mips-for-linux-next branch you're looking for.
