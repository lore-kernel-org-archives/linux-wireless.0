Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1846 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab2FFMOZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 08:14:25 -0400
Message-ID: <4FCF4993.7060409@broadcom.com> (sfid-20120606_141442_240375_2F163B17)
Date: Wed, 6 Jun 2012 14:14:11 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 08/18] brcmsmac: remove some redundant chip common
 workarounds
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-9-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338937641-8519-9-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
> The removed workarounds are already performed in bcma_pmu_workarounds()
> and bcma_core_chipcommon_init()

Could refer to "bcma: complete workaround for BCMA43224 and BCM4313"
which it seems to depend on.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   42 ---------------------
>  1 file changed, 42 deletions(-)

