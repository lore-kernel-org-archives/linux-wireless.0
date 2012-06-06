Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4821 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab2FFJ2X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 05:28:23 -0400
Message-ID: <4FCF22B0.3010808@broadcom.com> (sfid-20120606_112826_135909_58B2BDF6)
Date: Wed, 6 Jun 2012 11:28:16 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/18] brcmsmac: remove ai_findcore()
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-6-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338937641-8519-6-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
> bcma also stores a pointer to the chipcommon core in its struct,
> brcmsmac should use it and not search for the core by its own.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   31 ++++-----------------
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    2 --
>  drivers/net/wireless/brcm80211/brcmsmac/pmu.c     |   12 +++++---
>  3 files changed, 14 insertions(+), 31 deletions(-)
> 

