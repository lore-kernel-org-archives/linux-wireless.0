Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1712 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab2KSUig (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 15:38:36 -0500
Message-ID: <50AA98BF.9050802@broadcom.com> (sfid-20121119_213838_628796_8F36A0AF)
Date: Mon, 19 Nov 2012 21:38:23 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	"Daniel Wagner" <wagi@monom.org>
Subject: Re: [PATCH v2 17/22] brcmsmac: Add brcms_dbg_dma() debug macro
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-18-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1352988492-21340-18-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/15/2012 03:08 PM, Seth Forshee wrote:
> Also convert relevant messages to use this macro.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/debug.h |    1 +
>   drivers/net/wireless/brcm80211/brcmsmac/dma.c   |  155 ++++++++++-------------
>   drivers/net/wireless/brcm80211/brcmsmac/dma.h   |    2 +-
>   drivers/net/wireless/brcm80211/brcmsmac/main.c  |   10 +-
>   drivers/net/wireless/brcm80211/include/defs.h   |    1 +
>   5 files changed, 73 insertions(+), 96 deletions(-)



