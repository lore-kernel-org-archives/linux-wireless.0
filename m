Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46444 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbdHDGXX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Aug 2017 02:23:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Michael Skeffingfon <mike@astro.ai>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rt2x00: Fix MMIC Countermeasures.
References: <20170803153121.9046-1-mike@astro.ai>
Date: Fri, 04 Aug 2017 09:23:18 +0300
In-Reply-To: <20170803153121.9046-1-mike@astro.ai> (Michael Skeffingfon's
        message of "Thu, 3 Aug 2017 11:31:21 -0400")
Message-ID: <87tw1nn961.fsf@kamboji.qca.qualcomm.com> (sfid-20170804_082334_001235_72E34309)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Skeffingfon <mike@astro.ai> writes:

> From: Michael Skeffington <mike@astro.ai>
>
> Set RX_FLAG_DECRYPTED in case of MMIC failure so that ieee80211_rx_h_decrypt() doesnt drop the frame before getting to ieee80211_rx_h_michael_mic_verify().
>
> Signed-off-by: Michael Skeffington <mike@astro.ai>

The commit log is not wrapped to 72 characters per line and the period
is not preferred in the title. But I can fix those.


-- 
Kalle Valo
