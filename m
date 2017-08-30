Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43572 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbdH3Qvo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 12:51:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rsi: remove memset before memcpy
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1504032890-25229-1-git-send-email-himanshujha199640@gmail.com>
References: <1504032890-25229-1-git-send-email-himanshujha199640@gmail.com>
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: amit.karwar@redpinesignals.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Himanshu Jha <himanshujha199640@gmail.com>
Message-Id: <20170830165144.5D82E60209@smtp.codeaurora.org> (sfid-20170830_185204_251121_2A902F93)
Date: Wed, 30 Aug 2017 16:51:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Himanshu Jha <himanshujha199640@gmail.com> wrote:

> calling memcpy immediately after memset with the same region of memory
> makes memset redundant.
> 
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

66a3479e1217 rsi: remove memset before memcpy

-- 
https://patchwork.kernel.org/patch/9927943/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
