Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2238 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab3K0JBs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 04:01:48 -0500
Message-ID: <5295B4EB.70609@broadcom.com> (sfid-20131127_100157_090869_C7283E94)
Date: Wed, 27 Nov 2013 10:01:31 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: invalid sparse warnings ?
References: <5294AE3F.3090901@broadcom.com> (
 sfid-20131126_152109_226540_16C4AA96)
 <1385475973.4177.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1385475973.4177.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/26/2013 03:26 PM, Johannes Berg wrote:
> On Tue, 2013-11-26 at 15:20 +0100, Arend van Spriel wrote:
>> Does some of you get these possibly invalid sparse warnings since 3.13-rc1?
>>
>> brcm80211/brcmfmac/bcmsdh.c:777:1: warning: symbol
>> '__ksymtab_brcmf_sdio_probe' was not declared. Should it be static?
>>
>> The function brcmf_sdio_probe() is exported using EXPORT_SYMBOL macro.
>> Maybe upgrade my sparse installment?
>
> See the sparse mailing list,
> http://www.spinics.net/lists/linux-sparse/msg03297.html

Thanks, Johannes

I should improve my google skills ;-)

Gr. AvS


