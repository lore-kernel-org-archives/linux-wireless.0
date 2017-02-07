Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51170 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbdBGH3L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 02:29:11 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [PATCH 00/11 V4] rtlwifi: Various updates
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
Date: Tue, 07 Feb 2017 09:29:06 +0200
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Mon, 6 Feb 2017 21:29:57 -0600")
Message-ID: <87y3xi7931.fsf@codeaurora.org> (sfid-20170207_082915_608736_0D53BFAD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> These 11 changes fix a number of deficiencies. None of them are
> serious enough to be pushed to stable; however they help in the
> stability of the drivers, and in the robustness of authentication/
> association.
>
> This material should be sent to the 4.11 stream.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> ---
>
> V2 - Fix Kalle's comment about unended loops. It now runs a maximum of 200 times.
> V3 - Fix "WARNING: possible condition with no effect (if == else)" found by Test Robot
> V4 - No chenges -resubmitting as requested by Kalle.
> ---
> Larry Finger (1):
>   rtlwifi: btcoexist: Change logging in halbtc8192e2ant.c
>
> Ping-Ke Shih (10):
>   rtlwifi: Fix programing CAM content sequence.
>   rtlwifi: Set retry limit depends on vif type.
>   rtlwifi: Add a new enumeration value to btc_set_type
>   rtlwifi: btcoexist: Add vendor definition for new btcoexist
>   rtlwifi: rtl8723be: btcoexist: Add single_ant_path
>   rtlwifi: move btcoex's ant_num declaration
>   rtlwifi: rtl8723be: btcoex: add package_type function to btcoex
>   rtlwifi: btcoex: move bt_type declaration
>   rtlwifi: rtl8723be: fix ant_sel code
>   rtlwifi: Add work queue for c2h cmd.

Thanks, as patchwork doesn't seem to detect this patchset I applied these
manually:

1e75622c630b rtlwifi: Fix programing CAM content sequence.
8d0d43e34208 rtlwifi: Set retry limit depends on vif type.
6f85c03bc34c rtlwifi: Add a new enumeration value to btc_set_type
1a2814739fe5 rtlwifi: btcoexist: Add vendor definition for new btcoexist
d46fa3e47aeb rtlwifi: btcoexist: Change logging in halbtc8192e2ant.c
db8cb0095b0e rtlwifi: rtl8723be: btcoexist: Add single_ant_path
0de9b5db9fbf rtlwifi: move btcoex's ant_num declaration
7fe1fe75c311 rtlwifi: rtl8723be: btcoex: add package_type function to btcoex
e0215c142026 rtlwifi: btcoex: move bt_type declaration
0ff78adeef11 rtlwifi: rtl8723be: fix ant_sel code
cceb0a597320 rtlwifi: Add work queue for c2h cmd.

-- 
Kalle Valo
