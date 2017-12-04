Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54322 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751156AbdLDJqQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 04:46:16 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Xinming Hu <huxm@marvell.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>
Subject: Re: [RESEND, PATCH v3 3/3] mwifiex: debugfs: trigger device dump for usb interface
References: <1512370563-24660-1-git-send-email-huxm@marvell.com>
Date: Mon, 04 Dec 2017 11:46:09 +0200
In-Reply-To: <1512370563-24660-1-git-send-email-huxm@marvell.com> (Xinming
        Hu's message of "Mon, 4 Dec 2017 14:56:03 +0800")
Message-ID: <87vahmvna6.fsf@kamboji.qca.qualcomm.com> (sfid-20171204_104619_825428_336E3B84)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxm@marvell.com> writes:

> This patch extend device_dump debugfs function to make it
> works for usb interface.
>
> For command timeouts, USB firmware will automatically emit
> firmware dump events, so we don't implement device_dump().
>
> For user-initiated dumps, we trigger it by issue firmware
> dump event command to firmware, as there is no command
> response, do not start 10s timer.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> ---
> v2: Same as v1
> v3: Add more comments Regards the different dump mechanism
>     between usb and other interfaces.(Brian Norris)

Please always resubmit the whole patchset, not individual patches:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#resubmit_the_whole_patchset

Also please don't use that awkward "RESEND" stuff some people seem to
insist using. So instead of doing like this:

v2, v3, v3 RESEND, v4

do it like this which makes my life easier:

v2, v3, v4, v5

It's not like we are running out of version numbers :)

-- 
Kalle Valo
