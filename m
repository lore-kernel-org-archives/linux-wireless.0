Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2055 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab2FFJdb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 05:33:31 -0400
Message-ID: <4FCF23DE.1040300@broadcom.com> (sfid-20120606_113334_193463_B9F7EE8D)
Date: Wed, 6 Jun 2012 11:33:18 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 07/18] brcmsmac: remove si_pmu_spuravoid_pllupdate()
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-8-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338937641-8519-8-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
> si_pmu_spuravoid_pllupdate() is now replaced by
> bcma_pmu_spuravoid_pllupdate() which does the same thing, but supports
> more chips.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |    3 +-
>  drivers/net/wireless/brcm80211/brcmsmac/pmu.c      |   84 --------------------
>  drivers/net/wireless/brcm80211/brcmsmac/pmu.h      |    1 -
>  3 files changed, 2 insertions(+), 86 deletions(-)


