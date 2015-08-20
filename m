Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:49971 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbbHTQjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 12:39:20 -0400
Message-ID: <55D602B4.3000409@broadcom.com> (sfid-20150820_183923_990227_9BEBB340)
Date: Thu, 20 Aug 2015 18:39:16 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH V2 3/7] brcmfmac: Increase nr of supported flowrings.
References: <1439708139-7527-1-git-send-email-arend@broadcom.com>	<1439708139-7527-4-git-send-email-arend@broadcom.com> <CACna6rzrfGwpNS1nm1wDhGvu5voKMGH4BE1w5ZS0WeQUbgZUAQ@mail.gmail.com>
In-Reply-To: <CACna6rzrfGwpNS1nm1wDhGvu5voKMGH4BE1w5ZS0WeQUbgZUAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/20/2015 06:16 PM, Rafał Miłecki wrote:
> On 16 August 2015 at 08:55, Arend van Spriel <arend@broadcom.com> wrote:
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.h b/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
>> index 5551861..3a7d9c2 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
>> @@ -16,7 +16,7 @@
>>   #define BRCMFMAC_FLOWRING_H
>>
>>
>> -#define BRCMF_FLOWRING_HASHSIZE                256
>> +#define BRCMF_FLOWRING_HASHSIZE                512             /* has to be 2^x */
>>   #define BRCMF_FLOWRING_INVALID_ID      0xFFFFFFFF
>
> Applying patch *and* switching back to 256 let brcmfmac work again
> with my BCM43602. Not sure if it helps to understand the problem much.

Not to me. Maybe Hante gets some ideas, but he is ooo till monday.

Regards,
Arend

