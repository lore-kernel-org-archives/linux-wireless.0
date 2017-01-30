Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48270 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753625AbdA3OvM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 09:51:12 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Iain Hunter <drhunter95@gmail.com>
Cc: linux-wireless@vger.kernel.org, Iain Hunter <i-hunter1@ti.com>
Subject: Re: [PATCH] wlcore: let AP support allmulticast for MDNS. It can be enabled by bringing up the interface with ip command with the argument allmulticast on
References: <20170130125417.6188-1-i-hunter1@ti.com>
Date: Mon, 30 Jan 2017 16:24:32 +0200
In-Reply-To: <20170130125417.6188-1-i-hunter1@ti.com> (Iain Hunter's message
        of "Mon, 30 Jan 2017 12:54:17 +0000")
Message-ID: <87d1f4sk0v.fsf@kamboji.qca.qualcomm.com> (sfid-20170130_155125_845002_0ECBC143)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Iain Hunter <drhunter95@gmail.com> writes:

> Let AP support allmulticast for MDNS.
> It can be enabled by bringing up the interface with ip command with the argument allmulticast on
>
> Signed-off-by: Iain Hunter <i-hunter1@ti.com>

I see your patch now in patchwork (twice actually):

https://patchwork.kernel.org/patch/9545223/

But there's a problem with the title, you just copied the commit log as
the title. The format should be something like this (also please word
wrap the commit log):

----------------------------------------------------------------------
wlcore: disable firmware multicast filter in AP mode

Let AP support allmulticast for MDNS. It can be enabled by bringing up
the interface with ip command with the argument allmulticast on.

Signed-off-by: Ed Example <ed@example.org>
----------------------------------------------------------------------

You can see examples from patchwork, like this iwlwifi patch:

https://patchwork.kernel.org/patch/9544763/

-- 
Kalle Valo
