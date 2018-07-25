Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51906 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbeGYJvP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jul 2018 05:51:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Reizer\, Eyal" <eyalr@ti.com>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com
Subject: Re: [PATCH] drivers: net: wlcore: remove duplicate \n for some warnings
References: <af660348ade58fd33396d2dca432536d2ac85cf7.1532498079.git.hns@goldelico.com>
        <87lg9zyg1p.fsf@codeaurora.org>
        <F5C1808B-516D-4D74-BC43-6E997D9F012A@goldelico.com>
Date: Wed, 25 Jul 2018 11:40:30 +0300
In-Reply-To: <F5C1808B-516D-4D74-BC43-6E997D9F012A@goldelico.com> (H. Nikolaus
        Schaller's message of "Wed, 25 Jul 2018 10:30:45 +0200")
Message-ID: <87lg9zvhc1.fsf@kamboji.qca.qualcomm.com> (sfid-20180725_104052_005108_DB613E2E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"H. Nikolaus Schaller" <hns@goldelico.com> writes:

>> Am 25.07.2018 um 08:40 schrieb Kalle Valo <kvalo@codeaurora.org>:
>> 
>> "H. Nikolaus Schaller" <hns@goldelico.com> writes:
>> 
>>> wl1271_warning() already appends a \n to the format,
>>> so adding one to the warning string gives empty lines in the log.
>>> 
>>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>> 
>> "drivers: net:" in the title is unnecessary, but I can remove that.
>
> Ok, thanks! I wasn't aware of the precise subsystem tagging style here.

Yeah, subsystems can do it a bit differently. But you can easily check
with git log the preferred style:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#subject

-- 
Kalle Valo
