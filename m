Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44310 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751607AbdAROth (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 09:49:37 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [3/3] rtlwifi: Enable debug mask to be set from sysfs
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170101010706.13234-4-Larry.Finger@lwfinger.net>
References: <20170101010706.13234-4-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Message-Id: <20170118144936.91B3E6080C@smtp.codeaurora.org> (sfid-20170118_154939_807479_D2EFE43B)
Date: Wed, 18 Jan 2017 14:49:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> The previous commit changes the debug system to use a mask to select
> which components are to be debugged. Now, we add the necessary code
> to change the mask from sysfs.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>

There's already a generic sysfs interface to change module parameters in
/sys/module/<driver>/parameters, drivers should not have a private interface for
that.

-- 
https://patchwork.kernel.org/patch/9492849/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
