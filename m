Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36964 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750861AbdGYMUo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 08:20:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH v4 01/10] rtlwifi: Fill in_4way field by driver
References: <20170702181239.17911-1-Larry.Finger@lwfinger.net>
        <20170702181239.17911-2-Larry.Finger@lwfinger.net>
Date: Tue, 25 Jul 2017 15:20:39 +0300
In-Reply-To: <20170702181239.17911-2-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Sun, 2 Jul 2017 13:12:30 -0500")
Message-ID: <87bmo8k8rs.fsf@codeaurora.org> (sfid-20170725_142048_059626_44AEB224)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> Because it isn't always correct to use EAPOL to check 4-way,
> we add a timer to handle exception.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>
> ---
> v2 - no changes
> v3 - no changes
> v4 - no changes

BTW, for my sake you don't need to have changelogs for every patch. For
me it's enough (and what I also prefer) that the cover letter contains
the changelog.

-- 
Kalle Valo
