Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2649 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab1FFK6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 06:58:14 -0400
Message-ID: <4DECB232.70308@broadcom.com> (sfid-20110606_125817_570588_82A77461)
Date: Mon, 6 Jun 2011 12:55:46 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "George Kashperko" <george@znau.edu.ua>,
	"Hauke Mehrtens" <hauke@hauke-m.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"mb@bu3sch.de" <mb@bu3sch.de>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"bernhardloos@googlemail.com" <bernhardloos@googlemail.com>
Subject: Re: [RFC][PATCH 03/10] bcma: add embedded bus
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
 <1307311658-15853-4-git-send-email-hauke@hauke-m.de>
 <BANLkTi=T6xO9q+vOCk5Fu+2J_nUTwX3dcg@mail.gmail.com>
 <1307356322.28734.11.camel@dev.znau.edu.ua>
 <BANLkTimkKFAEfbKaWo81=uyuDS=gjESHAw@mail.gmail.com>
In-Reply-To: <BANLkTimkKFAEfbKaWo81=uyuDS=gjESHAw@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2011 12:51 PM, Rafał Miłecki wrote:
> W dniu 6 czerwca 2011 12:32 użytkownik George Kashperko
> <george@znau.edu.ua>  napisał:
>> Hi,
>>
>>> Hauke,
>>>
>>> My idea for naming schema was to use:
>>> bcma_host_TYPE_*
>>>
>>> Like:
>>> bcma_host_pci_*
>>> bcma_host_sdio_*
>>>
>>> You are using:
>>> bcma_host_bcma_*
>>>
>>> What do you think about changing this to:
>>> bcma_host_embedded_*
>>> or just some:
>>> bcma_host_emb_*
>>> ?
>>>
>>> Does it make more sense to you? I was trying to keep names in bcma
>>> really clear, so every first-time-reader can see differences between
>>> hosts, host and driver, etc.
>> how about bcma_host_soc ?
> We get then inconsistency with "BCMA_HOSTTYPE_EMBEDDED". I'd like to
> 1) See something like bcma_host_emb...
> xor
> 2) Use bcma_host_soc_* and BCMA_HOSTTYPE_SOC
>

I would go for option 2). It more clearly says what it is. Embedded is a 
broader term. As an example, a handset is an embedded device, but it may 
use BCMA_HOSTTYPE_SDIO.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


