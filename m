Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from up.icubehost.com ([185.62.36.194]:51052 "EHLO up.icubehost.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750936AbdJBHoV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 03:44:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 02 Oct 2017 13:14:18 +0530
From: Alagu Sankar <alagusankar@silex-india.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: silexcommon@gmail.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/11] ath10k_sdio: sdio htt data transfer fixes
In-Reply-To: <59D1EC94.2020307@broadcom.com>
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
 <1506793068-27445-2-git-send-email-alagusankar@silex-india.com>
 <59D1EC94.2020307@broadcom.com>
Message-ID: <f4255671cb5e7b52f823e26ba6816d2f@silex-india.com> (sfid-20171002_094238_744510_80F135D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On 2017-10-02 13:06, Arend van Spriel wrote:
> On 9/30/2017 7:37 PM, silexcommon@gmail.com wrote:
>> From: Alagu Sankar <alagusankar@silex-india.com>
>> 
> 
> [...]
> 
>> 
>> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
> 
> Not really have a specific remark for this patch, but for the entire
> series. These patches are sent using an anonymous email address, apart
> from 'silex' being in there, which does not show up in the certificate
> of origin. Just wondering if this is acceptable?
> 
> Regards,
> Arend
> 
>> ---
>>   drivers/net/wireless/ath/ath10k/core.c   | 20 +++++++++++++++++---
>>   drivers/net/wireless/ath/ath10k/htt_rx.c |  6 ++++--
>>   drivers/net/wireless/ath/ath10k/htt_tx.c | 24 
>> +++++++++++++++++++-----
>>   3 files changed, 40 insertions(+), 10 deletions(-)
> 
Could not use git send-email from the official ID due to mail server 
restrictions. If this is not acceptable, I will figure out a way to 
overcome this.

Regards,
Alagu Sankar
