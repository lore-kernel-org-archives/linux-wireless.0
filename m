Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51930 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751998AbdHHLxt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:53:49 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] rt2x00: Fix MMIC Countermeasures
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170807164736.20564-1-mike@astro.ai>
References: <20170807164736.20564-1-mike@astro.ai>
To: Michael Skeffington <mike@astro.ai>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Michael Skeffingfon <mike@astro.ai>
Message-Id: <20170808115349.938FA600E6@smtp.codeaurora.org> (sfid-20170808_135352_640122_45D5FB4E)
Date: Tue,  8 Aug 2017 11:53:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Skeffington <mike@astro.ai> wrote:

> Set RX_FLAG_DECRYPTED in case of MMIC failure so that
> ieee80211_rx_h_decrypt() doesnt drop the frame before getting to
> ieee80211_rx_h_michael_mic_verify().
> 
> Signed-off-by: Michael Skeffington <mike@astro.ai>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

2db3aaba0a9f rt2x00: Fix MMIC Countermeasures

-- 
https://patchwork.kernel.org/patch/9885839/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
