Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:56310 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbAVONa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 09:13:30 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Avinash Patil <patila@marvell.com>, Cathy Luo <cluo@marvell.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mwifiex: check driver status in connect and scan handlers
References: <1420631859-29004-1-git-send-email-akarwar@marvell.com>
	<CAEhWJFnr28=Q4TFwzwcNoWPQRbUY0+mWu8nbocs3789v8X1PHw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951B1633A3FA@SC-VEXCH1.marvell.com>
Date: Thu, 22 Jan 2015 16:13:23 +0200
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951B1633A3FA@SC-VEXCH1.marvell.com>
	(Amitkumar Karwar's message of "Sat, 17 Jan 2015 05:05:25 -0800")
Message-ID: <87lhkunbss.fsf@kamboji.qca.qualcomm.com> (sfid-20150122_151333_215001_020668EC)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> Hi Kalle,
>
>>On Wed, Jan 7, 2015 at 5:27 PM, Amitkumar Karwar <akarwar@marvell.com> wrote:
>>Ignore scan and connection requests from cfg80211 when driver
>>unload is in process or previous command has timed out due to
>>a firmware bug. This patch fixes corner case system crash
>>issues.
>
>>Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
>>Signed-off-by: Cathy Luo <cluo@marvell.com>
>>---
>> drivers/net/wireless/mwifiex/cfg80211.c | 8 ++++++++
>> drivers/net/wireless/mwifiex/scan.c     | 6 ++++++
>> 2 files changed, 14 insertions(+)
>
> Could you please check this patch? Let me know if you want me to
> resend it.

Unfortunately I'm lagging behind because I decided to work on automating
the patch handling. I'm hoping that makes it easier for me to stay
up-to-date.

Also it would help me that instead of mailing me people would check the
status from the patchwork:

https://patchwork.kernel.org/project/linux-wireless/list/

If the patch is delegated to me and state is one of "New", "Under
Review" or "Awaiting Upstream" it means that the patch is in queue of
patches to process. If it's anything else it means that the patch is
dropped due to some reason, either for a reason (issues found during
review etc) or accidentally (which can also happen in rare cases).

This patch is in 'Under Review' state so I will get to it eventually:

https://patchwork.kernel.org/patch/5584351/

And even looks to be in top of my list so it shouldn't take long.

-- 
Kalle Valo
