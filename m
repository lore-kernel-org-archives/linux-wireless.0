Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57146 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753882AbcL3NjE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 08:39:04 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl_usb: Fix missing entry in USB driver's private data
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161221171855.5056-1-Larry.Finger@lwfinger.net>
References: <20161221171855.5056-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, driver-devel@vger.kernel.org
Message-Id: <20161230133903.D082361481@smtp.codeaurora.org> (sfid-20161230_143940_922700_4FBD3915)
Date: Fri, 30 Dec 2016 13:39:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> These drivers need to be able to reference "struct ieee80211_hw" from
> the driver's private data, and vice versa. The USB driver failed to
> store the address of ieee80211_hw in the private data. Although this
> bug has been present for a long time, it was not exposed until
> commit ba9f93f82aba ("rtlwifi: Fix enter/exit power_save").
> 
> Fixes: ba9f93f82aba ("rtlwifi: Fix enter/exit power_save")
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers.git, thanks.

60f59ce02785 rtlwifi: rtl_usb: Fix missing entry in USB driver's private data

-- 
https://patchwork.kernel.org/patch/9483579/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
