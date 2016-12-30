Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34050 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751854AbcL3NzU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 08:55:20 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/14,V2] rtlwifi: Replace local debug macro RT_ASSERT
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161215182310.13713-2-Larry.Finger@lwfinger.net>
References: <20161215182310.13713-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Message-Id: <20161230135520.4E3CC61482@smtp.codeaurora.org> (sfid-20161230_145529_565973_503A6756)
Date: Fri, 30 Dec 2016 13:55:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> This macro can be replaced with WARN_ONCE. In addition to using a
> standard debugging macro for these critical errors, we also get
> a stack dump.
> 
> In rtl8821ae/hw.c, a senseless comment was removed, and an incorrect
> indentation was fixed.
> 
> This patch also fixes two places in each of rtl8192ee, rtl8723be,
> and rtl8821ae where the logical condition was incorrect.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>

14 patches applied to wireless-drivers-next.git, thanks.

531940f9644d rtlwifi: Replace local debug macro RT_ASSERT
b03d968b6644 rtlwifi: Remove RT_TRACE messages that use DBG_EMERG
004a1e167905 rtlwifi: rtl8821ae: Remove all instances of DBG_EMERG
4e2b4378f9d7 rtlwifi: rtl8723be: Remove all instances of DBG_EMERG
a67005bc46d9 rtlwifi: rtl8723ae: Remove all instances of DBG_EMERG
a44f59d60365 rtlwifi: rtl8192ee: Remove all instances of DBG_EMERG
c7532b87653b rtlwifi: rtl8723-common: Remove all instances of DBG_EMERG
2d15acac2354 rtlwifi: rtl8192se: Remove all instances of DBG_EMERG
b8c79f454880 rtlwifi: rtl8192de: Remove all instances of DBG_EMERG
c38af3f06af4 rtlwifi: rtl8192cu: Remove all instances of DBG_EMERG
e40a005652ad rtlwifi: rtl8192ce: Remove all instances of DBG_EMERG
0fc30e9350be rtlwifi: rtl8192c-common: Remove all instances of DBG_EMERG
02527a73beb3 rtlwifi: rtl8188ee: Remove all instances of DBG_EMERG
c93ac39da006 rtlwifi: Remove some redundant code

-- 
https://patchwork.kernel.org/patch/9476703/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
