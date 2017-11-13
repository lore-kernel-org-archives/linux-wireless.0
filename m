Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:52900 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755858AbdKMVX1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 16:23:27 -0500
Received: by mail-oi0-f67.google.com with SMTP id r128so12273389oig.9
        for <linux-wireless@vger.kernel.org>; Mon, 13 Nov 2017 13:23:27 -0800 (PST)
Subject: Re: [PATCH 0/3] rtlwifi: Refactor TX/RX flow to improve throughput
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, steventing@realtek.com,
        yhchuang@realtek.com
References: <20171113093935.20431-1-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <ecd9ff6c-fa45-7eec-33c1-914f9ab49275@lwfinger.net> (sfid-20171113_222331_012820_95354FC8)
Date: Mon, 13 Nov 2017 15:23:25 -0600
MIME-Version: 1.0
In-Reply-To: <20171113093935.20431-1-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/13/2017 03:39 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> This patchset is aim to reduce IO to improve TX/RX performance, and also I
> cleanup the code to make it easier and simpler.
> 
> Ping-Ke Shih (3):
>    rtlwifi: Reduce IO in RX interrupt to boost throughput
>    rtlwifi: fix the wrong size to calculate fifo space
>    rtlwifi: cleanup the code that check whether TX ring is available

All 3 Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> 
>   drivers/net/wireless/realtek/rtlwifi/pci.c         | 13 ++---
>   drivers/net/wireless/realtek/rtlwifi/pci.h         |  5 +-
>   .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   | 57 ++++------------------
>   3 files changed, 15 insertions(+), 60 deletions(-)
> 
