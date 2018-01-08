Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58742 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752093AbeAHQB0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 11:01:26 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: Drivers:RTLWIFI:rtl8723ae: add the function name to the printouts
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1513085679-6279-1-git-send-email-venkat.prashanth2498@gmail.com>
References: <1513085679-6279-1-git-send-email-venkat.prashanth2498@gmail.com>
To: venkat.prashanth2498@gmail.com
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
        linux-wireless@vger.kernel.org,
        Venkat Prashanth B U <venkat.prashanth2498@gmail.com>
Message-Id: <20180108160126.0567B60818@smtp.codeaurora.org> (sfid-20180108_170130_365858_2E8DB13C)
Date: Mon,  8 Jan 2018 16:01:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

venkat.prashanth2498@gmail.com wrote:

> From: Venkat Prashanth B U <venkat.prashanth2498@gmail.com>
> 
> This is a patch to rtl8723ae/trx.c file that adds the
> function name to the printouts.
> 
> Signed-off-by: Venkat Prashanth B U <venkat.prashanth2498@gmail.com>

The title is wrong:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

Also I would like to see an ack from Larry or other active developers before I
take something cosmetic like this.

-- 
https://patchwork.kernel.org/patch/10107381/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
