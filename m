Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42974 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752704AbeFAP4o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Jun 2018 11:56:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: Re: [PATCH 1/2] Revert "mwifiex: handle race during mwifiex_usb_disconnect"
References: <1527849680-31445-1-git-send-email-gbhat@marvell.com>
Date: Fri, 01 Jun 2018 18:56:39 +0300
In-Reply-To: <1527849680-31445-1-git-send-email-gbhat@marvell.com> (Ganapathi
        Bhat's message of "Fri, 1 Jun 2018 16:11:19 +0530")
Message-ID: <87k1rih554.fsf@purkki.adurom.net> (sfid-20180601_175654_093250_1B85647D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> writes:

> This reverts commit b817047ae70c0bd67b677b65d0d69d72cd6e9728.
>
> We have a better fix for this issue, which will be sent on top
> of this revert.
>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

I'll queue both of these patches to 4.18.

-- 
Kalle Valo
