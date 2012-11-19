Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4606 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab2KSUfa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 15:35:30 -0500
Message-ID: <50AA97FB.7070101@broadcom.com> (sfid-20121119_213533_781514_04238BEF)
Date: Mon, 19 Nov 2012 21:35:07 +0100
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
Subject: Re: [PATCH v2 11/22] brcmsmac: Add module parameter for setting
 the debug level
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-12-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1352988492-21340-12-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/15/2012 03:08 PM, Seth Forshee wrote:
> The debug level can be set by passing debug=... to brcmsmac whenever
> CONFIG_BRCMDBG is enabled.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>   .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   16 ++++++++--------
>   drivers/net/wireless/brcm80211/brcmsmac/main.c     |    7 +------
>   2 files changed, 9 insertions(+), 14 deletions(-)


