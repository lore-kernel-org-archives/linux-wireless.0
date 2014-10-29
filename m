Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:16369 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642AbaJ2Ibs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 04:31:48 -0400
Message-ID: <5450A5F0.30303@broadcom.com> (sfid-20141029_093153_303534_1A6DC60E)
Date: Wed, 29 Oct 2014 09:31:44 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/16] brcmfmac: wowl support and cleanup
References: <1414504579-12562-1-git-send-email-arend@broadcom.com> <1414508040.6643.5.camel@perches.com>
In-Reply-To: <1414508040.6643.5.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/28/14 15:54, Joe Perches wrote:
> On Tue, 2014-10-28 at 14:56 +0100, Arend van Spriel wrote:
>> This series has a couple of wowl patches that were too late to make
>> the 3.18 merge window. Apart from those there are a number of rename
>> and rework patches that get rid of the terms dhd and wl.
>>
>> The series is intended for 3.19 and applies to the master branch
>> of the wireless-next repository.
>>
>> Arend van Spriel (3):
>>    brcmfmac: show firmware error as string in debug message
>>    brcmfmac: remove unused defintion
>>    brcmfmac: do not use firmware error code in driver
>>
>> Hante Meuleman (13):
>>    brcmfmac: Add wowl support for USB devices.
>>    brcmfmac: Add wowl support for SDIO devices.
>>    brcmfmac: Add wowl patterns support.
>>    brcmfmac: (clean) Remove usb_rdl.h as it is not needed.
>>    brcmfmac: (clean) Remove packet filter configuration.
>>    brcmfmac: (clean) Move tracepoint related function.
>>    brcmfmac: (clean) Rename files dhd_dbg to debug
>>    brcmfmac: (clean) Rename dhd_bus.h in bus.h
>>    brcmfmac: (clean) Rename dhd_common.c in common.c
>>    brcmfmac: (clean) Rename files wl_cfg80211 to cfg80211
>>    brcmfmac: (clean) Rename sdio related files.
>>    brcmfmac: (clean) Rename sdio related files.
>>    brcmfmac: (clean) Move sdio related function.
>
> Does "(clean) " add anything to these commit subjects?

I think Hante added that to easily track renames in the git log.

Regards,
Arend
