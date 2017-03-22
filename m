Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 8.mo68.mail-out.ovh.net ([46.105.74.219]:33379 "EHLO
        8.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753749AbdCVU1h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 16:27:37 -0400
Received: from player737.ha.ovh.net (b9.ovh.net [213.186.33.59])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id EC0CF43C77
        for <linux-wireless@vger.kernel.org>; Wed, 22 Mar 2017 21:27:34 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 22 Mar 2017 21:27:26 +0100
From: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH] brcmfmac: update BRCMFMAC symbol description
In-Reply-To: <90f2fa7c-4bb7-7f1a-0641-19ff1e21e64c@broadcom.com>
References: <20170321144339.1709-1-zajec5@gmail.com>
 <90f2fa7c-4bb7-7f1a-0641-19ff1e21e64c@broadcom.com>
Message-ID: <183d0808584e0d55cae4afe46db3b5f7@milecki.pl> (sfid-20170322_213123_753349_7D917F37)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-03-22 20:38, Arend Van Spriel wrote:
> On 21-3-2017 15:43, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> For quite some time now brcmfmac supports 802.11ac chipsets and it's
>> not limited to embedded devices only. There are even standalone PCIe
>> cards based on BCM43602 or BCM4366.
> 
> minor comments below.
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>>  drivers/net/wireless/broadcom/brcm80211/Kconfig | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/Kconfig 
>> b/drivers/net/wireless/broadcom/brcm80211/Kconfig
>> index d93561f6ef97..817cb28f518f 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/Kconfig
>> +++ b/drivers/net/wireless/broadcom/brcm80211/Kconfig
>> @@ -18,14 +18,14 @@ config BRCMSMAC
>>  	  module, the driver will be called brcmsmac.ko.
>> 
>>  config BRCMFMAC
>> -	tristate "Broadcom IEEE802.11n embedded FullMAC WLAN driver"
>> +	tristate "Broadcom IEEE802.11n WLAN driver"
> 
> You still mention 11n. Let's drop the 'n' here or IEEE802.11n entirely
> like below. Would like to keep the term FullMAC though.

No idea how I missed that. Even commit message says we support 802.11ac 
now ;)
