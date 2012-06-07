Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42286 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab2FGNsL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 09:48:11 -0400
Message-ID: <4FD0B115.7070103@hauke-m.de> (sfid-20120607_154813_834026_64452B5C)
Date: Thu, 07 Jun 2012 15:48:05 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 03/18] brcmsmac: remove ai_get_buscore{type,rev}()
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de> <1338937641-8519-4-git-send-email-hauke@hauke-m.de> <4FCF2030.503@broadcom.com>
In-Reply-To: <4FCF2030.503@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 11:17 AM, Arend van Spriel wrote:
> On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
>> These two functions are not used any more.
> 
> Acked-by: Arend van Spriel <arend@broadcom.com>
This patch depends on the two patches before this in the patch series,
without them this patch will not apply. Is your Acked-by also for these
patches?
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   15 ---------------
>>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    4 ----
>>  2 files changed, 19 deletions(-)
>>
> 
