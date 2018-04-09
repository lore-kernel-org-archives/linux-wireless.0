Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36030 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752467AbeDIKup (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 06:50:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Xinming Hu <huxm@marvell.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>
Subject: Re: [v2 PATCH] mwifiex: parse key management suite from RSN IE
References: <1523260191-29352-1-git-send-email-huxm@marvell.com>
Date: Mon, 09 Apr 2018 13:50:38 +0300
In-Reply-To: <1523260191-29352-1-git-send-email-huxm@marvell.com> (Xinming
        Hu's message of "Mon, 9 Apr 2018 15:49:51 +0800")
Message-ID: <87o9isr6v5.fsf@codeaurora.org> (sfid-20180409_125051_508800_C27B20CB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxm@marvell.com> writes:

> Association failed when using wpa_supplicant with
> configuration key_mgmt=WPA-PSK-SHA256, and it is noticed
> that wpa_supplicant set WLAN_AKM_SUITE_PSK_SHA256 in
> RSN IE, but miss it in start_ap parameters.
>
> This patch parse key management suite from RSN IE, in
> case it is missed.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>

Shouldn't you fix wpa_supplicant instead of adding a workaround to the
driver?

-- 
Kalle Valo
