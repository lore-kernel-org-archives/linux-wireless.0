Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42267 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab2FGNpy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 09:45:54 -0400
Message-ID: <4FD0B08A.1090609@hauke-m.de> (sfid-20120607_154556_607138_AE3D9D20)
Date: Thu, 07 Jun 2012 15:45:46 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 04/18] brcmsmac: use container_of instead of cast
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de> <1338937641-8519-5-git-send-email-hauke@hauke-m.de> <4FCF2283.3010708@broadcom.com>
In-Reply-To: <4FCF2283.3010708@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 11:27 AM, Arend van Spriel wrote:
> On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
> 
> Acked-by: Arend van Spriel <arend@broadcom.com>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   16 ++++++++--------
>>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> Nice. Could add a description that it gets rid of structure layout
> requirement, ie. pub must be first field in struct si_info.
Yes will do so, I hope I found all casts.
> 
> Gr. AvS
> 

