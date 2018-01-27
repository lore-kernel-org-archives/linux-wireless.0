Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f178.google.com ([74.125.82.178]:35060 "EHLO
        mail-ot0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751946AbeA0TYj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 14:24:39 -0500
Received: by mail-ot0-f178.google.com with SMTP id j45so774181ota.2
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jan 2018 11:24:39 -0800 (PST)
Subject: Re: [PATCH 10/10] rtlwifi: btcoex: Add 8822be btcoex supported files
 for wifi only
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180126074645.27201-1-pkshih@realtek.com>
 <20180126074645.27201-11-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <4aef0077-1b9a-8090-32c0-58b3ed690d34@lwfinger.net> (sfid-20180127_202503_096612_CDF957A6)
Date: Sat, 27 Jan 2018 13:24:37 -0600
MIME-Version: 1.0
In-Reply-To: <20180126074645.27201-11-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2018 01:46 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> The wifi only btcoex is used to solo card (without BT), and it is also
> useful to exclude the interference with BT to make debug easier.
> There are only four ops for wifi only btcoex to initialze antenna and
> switch the settings while band is changed.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
