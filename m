Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58300 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753422AbcICRGX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 13:06:23 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi/rtl8192de: Fix print format string
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1472267543-810602-1-git-send-email-green@linuxhacker.ru>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Drokin <green@linuxhacker.ru>
Message-Id: <20160903170538.3538362184@smtp.codeaurora.org> (sfid-20160903_190627_504812_E8D21E48)
Date: Sat,  3 Sep 2016 17:05:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleg Drokin <green@linuxhacker.ru> wrote:
> %ul was likely meant as %lu to print an unsigned long,
> not an unsigned with a letter l at the end.
> But in fact the value printed is u32 anyway, so just drop
> the l completely.
> 
> Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, 1 patch applied to wireless-drivers-next.git:

5856cd5b8dda rtlwifi/rtl8192de: Fix print format string

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9302259/
