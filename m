Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1944 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab2KSUgA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 15:36:00 -0500
Message-ID: <50AA9824.6020308@broadcom.com> (sfid-20121119_213604_107074_5FFE7C5C)
Date: Mon, 19 Nov 2012 21:35:48 +0100
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
Subject: Re: [PATCH v2 12/22] brcmsmac: Add support for writing debug
 messages to the trace buffer
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-13-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1352988492-21340-13-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/15/2012 03:08 PM, Seth Forshee wrote:
> Add a new brcmsmac_msg trace system to enable writing of debug messages
> to the trace buffer, and add brcms_* macros for storing device debug
> messages in the trace buffer in addition to the printk log buffer.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/Makefile   |    3 +-
>   .../brcm80211/brcmsmac/brcms_trace_events.h        |   68 +++++++++++++++++++-
>   drivers/net/wireless/brcm80211/brcmsmac/debug.c    |   44 +++++++++++++
>   drivers/net/wireless/brcm80211/brcmsmac/debug.h    |   40 ++++++++++++
>   4 files changed, 151 insertions(+), 4 deletions(-)
>   create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/debug.c
>   create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/debug.h



