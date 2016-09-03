Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57643 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752997AbcICQ5V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 12:57:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/2,v2] wlcore: Remove wl pointer from wl_sta structure
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160815082400.12053-1-maxim.altshul@ti.com>
To: Maxim Altshul <maxim.altshul@ti.com>
Cc: <linux-kernel@vger.kernel.org>,
        Maxim Altshul <maxim.altshul@ti.com>,
        <linux-wireless@vger.kernel.org>
Message-Id: <20160903165616.73F1962180@smtp.codeaurora.org> (sfid-20160903_185727_224502_4C581457)
Date: Sat,  3 Sep 2016 16:56:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Altshul <maxim.altshul@ti.com> wrote:
> This field was added to wl_sta struct to get hw in situations
> where it was not given to driver by mac80211. In our case,
> get_expected_throughput op did not send hw to driver.
> 
> This patch reverts the change, as it is no longer needed due to commit
> 4fdbc67a25ce ("mac80211: call get_expected_throughput only after adding
> station") as hw is now sent as a parameter.
> 
> Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

d8c872b57e0f wlcore: Remove wl pointer from wl_sta structure

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9280419/
