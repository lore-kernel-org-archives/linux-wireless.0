Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:42242 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755525AbeAJIOc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 03:14:32 -0500
Received: by mail-wm0-f52.google.com with SMTP id b141so25110741wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jan 2018 00:14:32 -0800 (PST)
Subject: Re: [PATCH 05/10] rtlwifi: enable mac80211 fast-tx support
To: pkshih@realtek.com, kvalo@codeaurora.org
References: <20180110052002.9544-1-pkshih@realtek.com>
 <20180110052002.9544-6-pkshih@realtek.com>
Cc: Larry.Finger@lwfinger.net, yhchuang@realtek.com,
        linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A55CB65.6010409@broadcom.com> (sfid-20180110_091444_963673_B8834AE6)
Date: Wed, 10 Jan 2018 09:14:29 +0100
MIME-Version: 1.0
In-Reply-To: <20180110052002.9544-6-pkshih@realtek.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/10/2018 6:19 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
>
> To enable the mac80211 fast-tx feature, the hw/driver needs to support
> dynamic power saving and fragmentation. Since our driver does not
> need to fragment packet into smaller pieces, we just hook an empty
> callback of set_frag_threshold to avoid fragmentation in mac80211.
>
> After this, the mac80211 will not fragment the packets and can transmit
> them faster by cache the header information.
>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

Your sob is missing here (also in patch 6/10).

Regards,
Arend
