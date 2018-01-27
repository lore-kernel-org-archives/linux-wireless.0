Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:45534 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbeA0Scz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 13:32:55 -0500
Received: by mail-oi0-f67.google.com with SMTP id c189so1696815oib.12
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jan 2018 10:32:55 -0800 (PST)
Subject: Re: [PATCH 01/10] rtlwifi: enable mac80211 fast-tx support
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180126074645.27201-1-pkshih@realtek.com>
 <20180126074645.27201-2-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <71591635-eb70-f12e-d510-a90a873afcc7@lwfinger.net> (sfid-20180127_193259_744841_CF53DE97)
Date: Sat, 27 Jan 2018 12:32:53 -0600
MIME-Version: 1.0
In-Reply-To: <20180126074645.27201-2-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2018 01:46 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Enable the mac80211 fast-tx feature, since our driver already support
> hw_flags required by fast-tx and is able to let mac80211 stack to transmit
> packet through fast-xmit path.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
