Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42063 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175Ab2FGNAI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 09:00:08 -0400
Message-ID: <4FD0A5CF.7090806@hauke-m.de> (sfid-20120607_150012_700746_F1D96FD3)
Date: Thu, 07 Jun 2012 14:59:59 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 08/18] brcmsmac: remove some redundant chip common workarounds
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de> <1338937641-8519-9-git-send-email-hauke@hauke-m.de> <4FCF4993.7060409@broadcom.com>
In-Reply-To: <4FCF4993.7060409@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 02:14 PM, Arend van Spriel wrote:
> On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
>> The removed workarounds are already performed in bcma_pmu_workarounds()
>> and bcma_core_chipcommon_init()
> 
> Could refer to "bcma: complete workaround for BCMA43224 and BCM4313"
> which it seems to depend on.
Yes will do that in a v2.
> 
> Acked-by: Arend van Spriel <arend@broadcom.com>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   42 ---------------------
>>  1 file changed, 42 deletions(-)
> 

