Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:38131 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655AbbKRTTL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 14:19:11 -0500
Subject: Re: [PATCH v2 06/27] brcm80211: move under broadcom vendor directory
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
References: <1447857966-19560-1-git-send-email-kvalo@codeaurora.org>
 <1447857966-19560-7-git-send-email-kvalo@codeaurora.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Arend van Spriel <arend@broadcom.com>,
	brcm80211-dev-list@broadcom.com
From: Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <564CCF2A.4030203@hauke-m.de> (sfid-20151118_201939_252960_2E12FCE8)
Date: Wed, 18 Nov 2015 20:19:06 +0100
MIME-Version: 1.0
In-Reply-To: <1447857966-19560-7-git-send-email-kvalo@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2015 03:45 PM, Kalle Valo wrote:
> Part of reorganising wireless drivers directory and Kconfig. Note that I had to
> edit Makefiles from subdirectories to use the new location.
> 
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> ---

I would prefer to remove the brcm80211 directory in this process and create:
drivers/net/wireless/broadcom/brcmfmac
drivers/net/wireless/broadcom/brcmsmac
drivers/net/wireless/broadcom/brcmutil
drivers/net/wireless/broadcom/include

This way we have one directory less.

Hauke
