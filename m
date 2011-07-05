Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1533 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab1GEVkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 17:40:41 -0400
Message-ID: <4E1384C8.9070501@broadcom.com> (sfid-20110705_234045_076030_48CE81CC)
Date: Tue, 5 Jul 2011 23:40:24 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 00/21] staging: brcm80211: mostly fullmac cleanup
 patches
References: <1309896377-4425-1-git-send-email-arend@broadcom.com>
 <CACna6rwqWnrK_UOhx8OEwm9vPv+LYtv6kV8frnQHB6c4wB3ZJQ@mail.gmail.com>
In-Reply-To: <CACna6rwqWnrK_UOhx8OEwm9vPv+LYtv6kV8frnQHB6c4wB3ZJQ@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/05/2011 10:38 PM, Rafał Miłecki wrote:
> 2011/7/5 Arend van Spriel<arend@broadcom.com>:
>> (...)
>>   staging: brcm80211: removed brcmf_sdioh_interrupt_pending()
>>   staging: brcm80211: removed brcmf_sdioh_reset()
>>   staging: brcm80211: removed brcmf_sdioh_start() and
>>     brcmf_sdioh_stop()
> Arend, can you say something more about what does happen here?
>
> You drop some functions that were empty, but I guess there were here
> for some reason. Did you discover in development process that things
> like start/stop/reset is not needed? Or did you put place for
> something that appeared to be not available on SDIO?
>
> Shouldn't we keep it here and just implement lacking code?

 From what I know this code was intended platform/os independent. In the 
open-source linux driver it was not needed as it relies on 
mmc_core/sdhci/etc. modules. I am more focused on softmac driver so the 
fullmac guys may want to correct my statements made here.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


