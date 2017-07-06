Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33217 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdGFRQB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 13:16:01 -0400
Received: by mail-pf0-f172.google.com with SMTP id e7so4053081pfk.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 10:16:01 -0700 (PDT)
Date: Thu, 6 Jul 2017 10:15:58 -0700
From: Brian Norris <briannorris@chromium.org>
To: Jeffy Chen <jeffy.chen@rock-chips.com>
Cc: linux-wireless@vger.kernel.org, akarwar@marvell.com,
        Xinming Hu <huxm@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-kernel@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] mwifiex: uninit wakeup info in the error handling
Message-ID: <20170706171557.GA121983@google.com> (sfid-20170706_191636_405639_759E0B62)
References: <1499327728-25388-1-git-send-email-jeffy.chen@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1499327728-25388-1-git-send-email-jeffy.chen@rock-chips.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 06, 2017 at 03:55:28PM +0800, Jeffy Chen wrote:
> We inited wakeup info at the beginning of mwifiex_add_card, so we need
> to uninit it in the error handling.
> 
> It's much the same as what we did in:
> 36908c4 mwifiex: uninit wakeup info when removing device
> 
> Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
> 
> ---
> 
> Changes in v2:
> Uninit wakeup when _mwifiex_fw_dpc failed too.

Looks good to me:

Reviewed-by: Brian Norris <briannorris@chromium.org>
