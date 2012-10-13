Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:38075 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750947Ab2JMCDc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 22:03:32 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Linux Wireless List <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>, Jouni Malinen <j@w1.fi>,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	Dan Williams <dcbw@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Fri, 12 Oct 2012 18:55:16 -0700
Subject: RE: [PATCH 1/3] wireless: drivers: make use of
 WLAN_EID_VENDOR_SPECIFIC
Message-ID: <477F20668A386D41ADCC57781B1F7043083B80D8BB@SC-VEXCH1.marvell.com> (sfid-20121013_040336_201704_6D05F0CE)
References: <1350037696-23747-1-git-send-email-arend@broadcom.com>
 <1350037696-23747-2-git-send-email-arend@broadcom.com>
In-Reply-To: <1350037696-23747-2-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

> The include file linux/ieee80211.h contains three definitions for
> the same thing in enum ieee80211_eid due to historic changes:
> 
> /* Information Element IDs */
> enum ieee80211_eid {
>     :
>     WLAN_EID_WPA = 221,
>     WLAN_EID_GENERIC = 221,
>     WLAN_EID_VENDOR_SPECIFIC = 221,
>     :
> };
> 
> The standard refers to this as "vendor specific" element so the
> other two definitions are better not used. This patch changes the
> wireless drivers to use one definition, ie. WLAN_EID_VENDOR_SPECIFIC.
> 
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: Jouni Malinen <j@w1.fi>
> Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> Cc: Dan Williams <dcbw@redhat.com>
> Cc: Bing Zhao <bzhao@marvell.com>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

For mwifiex part,

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing
