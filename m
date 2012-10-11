Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50737 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758852Ab2JKQln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 12:41:43 -0400
Message-ID: <1349973736.13097.12.camel@jlt4.sipsolutions.net> (sfid-20121011_184145_889228_5CAFFD48)
Subject: Re: [RFC] wireless: cfg80211: add peer-to-peer related definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Oct 2012 18:42:16 +0200
In-Reply-To: <1349965104-14475-1-git-send-email-arend@broadcom.com>
References: <1349965104-14475-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-11 at 16:18 +0200, Arend van Spriel wrote:

> +++ b/include/linux/ieee80211.h
> @@ -168,6 +168,9 @@
>  #define IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK	0x03
>  #define IEEE80211_WMM_IE_STA_QOSINFO_SP_SHIFT	5
>  
> +/* Vendor-specific IE */
> +#define IEEE80211_VENDOR_SPEC_IE		0xDD

actually this already exists, as ..._EID_VENDOR or so?

johannes

