Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3646 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab3FEPf3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 11:35:29 -0400
Message-ID: <51AF5AB7.2070703@broadcom.com> (sfid-20130605_173531_921397_30BB7F95)
Date: Wed, 5 Jun 2013 17:35:19 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Antonio Quartulli" <ordex@autistici.org>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Antonio Quartulli" <antonio@open-mesh.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCHv4 2/4] brcm80211: make mgmt_tx in brcmfmac accept a
 NULL channel
References: <1370444989-2095-1-git-send-email-ordex@autistici.org>
 <1370444989-2095-2-git-send-email-ordex@autistici.org>
 <51AF5A92.9050906@broadcom.com>
In-Reply-To: <51AF5A92.9050906@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2013 05:34 PM, Arend van Spriel wrote:
> On 06/05/2013 05:09 PM, Antonio Quartulli wrote:
>> From: Antonio Quartulli <antonio@open-mesh.com>
>>
>> cfg80211 passes a NULL channel to mgmt_tx if the frame has
>> to be sent on the one currently in use by the device.
>> Make the implementation of mgmt_tx correctly handle this
>> case
>>
>> Cc: Arend van Spriel <arend@broadcom.com>
>> Cc: brcm80211-dev-list@broadcom.com
>> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
>> ---
>
> For my name above you (or Johannes) can change 'Cc:' to 'Acked-by:'

Or John?

> Gr. AvS
>
>> v3:
>> - read current freq from the firmware via BRCMF_C_GET_CHANNEL
>>
>>   drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 15
>> ++++++++++++---
>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>
>


