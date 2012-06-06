Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1770 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab2FFJRr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 05:17:47 -0400
Message-ID: <4FCF2030.503@broadcom.com> (sfid-20120606_111751_865568_E2AACB8A)
Date: Wed, 6 Jun 2012 11:17:36 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 03/18] brcmsmac: remove ai_get_buscore{type,rev}()
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338937641-8519-4-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
> These two functions are not used any more.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   15 ---------------
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    4 ----
>  2 files changed, 19 deletions(-)
> 

