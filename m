Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.171]:26115 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728357AbeGYJrq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jul 2018 05:47:46 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH] drivers: net: wlcore: remove duplicate \n for some warnings
From: "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <87lg9zyg1p.fsf@codeaurora.org>
Date: Wed, 25 Jul 2018 10:30:45 +0200
Cc: Arnd Bergmann <arnd@arndb.de>, "Reizer, Eyal" <eyalr@ti.com>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com
Message-Id: <F5C1808B-516D-4D74-BC43-6E997D9F012A@goldelico.com> (sfid-20180725_103714_465573_0285099C)
References: <af660348ade58fd33396d2dca432536d2ac85cf7.1532498079.git.hns@goldelico.com> <87lg9zyg1p.fsf@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Am 25.07.2018 um 08:40 schrieb Kalle Valo <kvalo@codeaurora.org>:
> 
> "H. Nikolaus Schaller" <hns@goldelico.com> writes:
> 
>> wl1271_warning() already appends a \n to the format,
>> so adding one to the warning string gives empty lines in the log.
>> 
>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> 
> "drivers: net:" in the title is unnecessary, but I can remove that.

Ok, thanks! I wasn't aware of the precise subsystem tagging style here.

BR,
Nikolaus
