Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46238 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751098AbdG0Jry (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 05:47:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] rtlwifi: Replace hardcode value with macro
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170630081945.GA3265@symbol-HP-ZBook-15>
References: <20170630081945.GA3265@symbol-HP-ZBook-15>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
        linux-wireless@vger.kernel.org
Message-Id: <20170727094754.45C2E6081B@smtp.codeaurora.org> (sfid-20170727_114758_242085_7E5070C5)
Date: Thu, 27 Jul 2017 09:47:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Souptick Joarder <jrdr.linux@gmail.com> wrote:

> In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
> and hw->max_rate_tries are replaced by macro.
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

The comment ("defined these...") in the code does not make sense, it
should be removed.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9818675/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
