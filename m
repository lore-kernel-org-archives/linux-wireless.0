Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58544 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932385AbdEKL4d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 07:56:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH v2 08/10] rtlwifi: btcoex: 21a 2ant: refine bt info notify to have more profilings
References: <20170505161712.8685-1-Larry.Finger@lwfinger.net>
        <20170505161712.8685-9-Larry.Finger@lwfinger.net>
Date: Thu, 11 May 2017 14:56:26 +0300
In-Reply-To: <20170505161712.8685-9-Larry.Finger@lwfinger.net> (Larry Finger's
        message of "Fri, 5 May 2017 11:17:10 -0500")
Message-ID: <871srvvc7p.fsf@kamboji.qca.qualcomm.com> (sfid-20170511_135705_166275_70E25047)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>
> We add some profiling combinations when the bt notifies the coex
> mechanism to detect more situations and adjust the coex to fit to it.
>
> Also monitro if the wifi is under 5G mode, if so, the signals do net

typo: "monitro"

> intefere each other, bt can just ignore it
>
> v2 - resubmit after removal of BT_AUTO_REPORT_XXXX symbols.
> ---
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Pkshih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>
> ---

Version log before "---" line but S-o-b lines are after that line.

-- 
Kalle Valo
