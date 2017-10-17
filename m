Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36424 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753252AbdJQOVx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 10:21:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: Fix typo in if ... else if ... else construct
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171015015402.11217-1-Larry.Finger@lwfinger.net>
References: <20171015015402.11217-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>,
        Steven Ting <steventing@realtek.com>, kbuild-all@01.org,
        Julia Lawall <julia.lawall@lip6.fr>
Message-Id: <20171017142152.741576083E@smtp.codeaurora.org> (sfid-20171017_162209_882839_2ADA8ABC)
Date: Tue, 17 Oct 2017 14:21:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> The kbuild test robot reports two conditions with no effect (if == else).
> These are the result of copy and paste typographical errors.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>
> Cc: kbuild-all@01.org
> Cc: Julia Lawall <julia.lawall@lip6.fr>

Patch applied to wireless-drivers-next.git, thanks.

a7986ce1cb01 rtlwifi: Fix typo in if ... else if ... else construct

-- 
https://patchwork.kernel.org/patch/10006693/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
