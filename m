Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58898 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdAQMUl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 07:20:41 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8192de: Remove a pointless goto
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170110161526.22255-1-Larry.Finger@lwfinger.net>
References: <20170110161526.22255-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20170117121332.7C0CC607C6@smtp.codeaurora.org> (sfid-20170117_132044_978056_EA437AC6)
Date: Tue, 17 Jan 2017 12:13:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In commit c93ac39da0064 ("rtlwifi: Remove some redundant code), a goto
> statement was inadvertently left in the code.
> 
> Fixes: c93ac39da0064 ("rtlwifi: Remove some redundant code)
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

7f2f61377bca rtlwifi: rtl8192de: Remove a pointless goto

-- 
https://patchwork.kernel.org/patch/9508121/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
