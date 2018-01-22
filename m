Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33156 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751121AbeAVTL7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 14:11:59 -0500
Received: by mail-oi0-f45.google.com with SMTP id y141so6727990oia.0
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jan 2018 11:11:59 -0800 (PST)
Subject: Re: [PATCH 05/10] rtlwifi: btcoex: Add wifi_only series ops to
 control solo card
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180119064551.10084-1-pkshih@realtek.com>
 <20180119064551.10084-6-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <6a16a732-6828-41d1-97bd-645e06951316@lwfinger.net> (sfid-20180122_201203_066071_326B9B01)
Date: Mon, 22 Jan 2018 13:11:56 -0600
MIME-Version: 1.0
In-Reply-To: <20180119064551.10084-6-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/19/2018 12:45 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Originally, btcoex controls the antenna of combo card, but solo card
> is also needed to setup properly. The new ops are named with suffix
> '_wifi_only' opposited to original btc_ops, and new structures and
> definitions are also introduced. The wifi_only oly contains four ops that
> are initial variable, hw config, scan notify, and switch band notify.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 48 +++++++++++++++++++
>   .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       | 47 +++++++++++++++++++
>   .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   | 54 +++++++++++++++++++++-
>   .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |  5 ++
>   drivers/net/wireless/realtek/rtlwifi/core.c        |  6 +++
>   drivers/net/wireless/realtek/rtlwifi/pci.c         |  8 +++-
>   drivers/net/wireless/realtek/rtlwifi/wifi.h        |  7 +++
>   7 files changed, 172 insertions(+), 3 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
