Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57892 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933656AbdIYIGZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 04:06:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8821ae: Fix connection lost problem
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170920211505.26171-1-Larry.Finger@lwfinger.net>
References: <20170920211505.26171-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>
Message-Id: <20170925080624.04C9960618@smtp.codeaurora.org> (sfid-20170925_104606_105870_6D27B04A)
Date: Mon, 25 Sep 2017 08:06:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> In commit 40b368af4b75 ("rtlwifi: Fix alignment issues"), the read
> of REG_DBI_READ was changed from 16 to 8 bits. For unknown reasonsi
> this change results in reduced stability for the wireless connection.
> This regression was located using bisection.
> 
> Fixes: 40b368af4b75 ("rtlwifi: Fix alignment issues")
> Reported-and-tested-by: James Cameron <quozl@laptop.org>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> # 4.11+
> Cc: Ping-Ke Shih <pkshih@realtek.com>

Should I queue this for 4.14?

(The first commit was v4.11-rc1.)

-- 
https://patchwork.kernel.org/patch/9962615/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
