Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36338 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752290AbeCZPKe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 11:10:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath: fix false radar detection in JP region
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1519385779-25816-1-git-send-email-srirrama@codeaurora.org>
References: <1519385779-25816-1-git-send-email-srirrama@codeaurora.org>
To: srirrama@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Sriram R <srirrama@codeaurora.org>
Message-Id: <20180326151033.E1EEA60AFB@smtp.codeaurora.org> (sfid-20180326_171037_640926_5DEC4272)
Date: Mon, 26 Mar 2018 15:10:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

srirrama@codeaurora.org wrote:

> This fixes false radar detection (of radar type 7)
> in Japan region by correcting the radar pulse type
> to Chirp as per specification.
> 
> Signed-off-by: Sriram R <srirrama@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

ba21ac6cdaef ath: fix false radar detection in JP region

-- 
https://patchwork.kernel.org/patch/10237459/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
