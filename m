Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1351 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab2FFJbf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 05:31:35 -0400
Message-ID: <4FCF2372.6080506@broadcom.com> (sfid-20120606_113138_509139_6A7CAE24)
Date: Wed, 6 Jun 2012 11:31:30 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/18] brcmsmac: remove si_pmu_init() and
 si_pmu_res_init()
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-7-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338937641-8519-7-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
> This is already done by bcma_pmu_init() and bcma_pmu_resources_init() in bcma.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    2 -
>  drivers/net/wireless/brcm80211/brcmsmac/pmu.c     |   76 ---------------------
>  drivers/net/wireless/brcm80211/brcmsmac/pmu.h     |    2 -
>  3 files changed, 80 deletions(-)


