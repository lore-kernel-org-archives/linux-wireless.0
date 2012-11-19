Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1747 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab2KSUhu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 15:37:50 -0500
Message-ID: <50AA9892.1060004@broadcom.com> (sfid-20121119_213753_498231_4191846F)
Date: Mon, 19 Nov 2012 21:37:38 +0100
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
Subject: Re: [PATCH v2 16/22] brcmsmac: Add brcms_dbg_int() debug macro
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-17-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1352988492-21340-17-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/15/2012 03:08 PM, Seth Forshee wrote:
> Also convert relevant message to use this macro.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/debug.h |    1 +
>   drivers/net/wireless/brcm80211/brcmsmac/main.c  |   12 ++++++------
>   drivers/net/wireless/brcm80211/include/defs.h   |    1 +
>   3 files changed, 8 insertions(+), 6 deletions(-)



