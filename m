Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35966 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753986AbeEWIC5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 04:02:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] rsi: add fix for crash during assertions
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1526375071-7010-1-git-send-email-sushant2k1513@gmail.com>
References: <1526375071-7010-1-git-send-email-sushant2k1513@gmail.com>
To: Sushant Kumar Mishra <sushant2k1513@gmail.com>
Cc: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Konduri <sanjay.konduri@redpinesignals.com>
Message-Id: <20180523080257.4940860618@smtp.codeaurora.org> (sfid-20180523_100311_988082_8C3E6857)
Date: Wed, 23 May 2018 08:02:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sushant Kumar Mishra <sushant2k1513@gmail.com> wrote:

> From: Sanjay Konduri <sanjay.konduri@redpinesignals.com>
> 
> Observed crash in some scenarios when assertion has occurred,
> this is because hw structure is freed and is tried to get
> accessed in some functions where null check is already
> present. So, avoided the crash by making the hw to NULL after
> freeing.
> 
> Signed-off-by: Sanjay Konduri <sanjay.konduri@redpinesignals.com>
> Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>

2 patches applied to wireless-drivers-next.git, thanks.

abd39c6ded9d rsi: add fix for crash during assertions
eeed833aaa38 rsi: add fix for corruption of auto rate table

-- 
https://patchwork.kernel.org/patch/10400687/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
