Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:42340 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752913AbdK3Qda (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Nov 2017 11:33:30 -0500
Received: by mail-it0-f50.google.com with SMTP id p139so9031636itb.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Nov 2017 08:33:30 -0800 (PST)
Date: Thu, 30 Nov 2017 08:33:27 -0800
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxm@marvell.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>
Subject: Re: [PATCH v2 3/3] mwifiex: debugfs: trigger device dump for usb
 interface
Message-ID: <20171130163326.GB87129@google.com> (sfid-20171130_173355_127852_9683B34C)
References: <1511766555-30780-1-git-send-email-huxm@marvell.com>
 <1511766555-30780-3-git-send-email-huxm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1511766555-30780-3-git-send-email-huxm@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 27, 2017 at 03:09:15PM +0800, Xinming Hu wrote:
> This patch extend device_dump debugfs function to make it
> works for usb interface.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> ---
> v2: Same as v1

With the same problems as v1 :)
