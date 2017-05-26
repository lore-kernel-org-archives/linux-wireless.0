Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36516 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944306AbdEZQqr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 12:46:47 -0400
Received: by mail-pf0-f171.google.com with SMTP id m17so16344464pfg.3
        for <linux-wireless@vger.kernel.org>; Fri, 26 May 2017 09:46:47 -0700 (PDT)
Date: Fri, 26 May 2017 09:46:43 -0700
From: Brian Norris <briannorris@chromium.org>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Xinming Hu <huxm@marvell.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mwifiex: simplify the code around ra_list
Message-ID: <20170526164642.GA102646@google.com> (sfid-20170526_184721_095302_E0974DC5)
References: <1495762909-46795-1-git-send-email-shawn.lin@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495762909-46795-1-git-send-email-shawn.lin@rock-chips.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 26, 2017 at 09:41:49AM +0800, Shawn Lin wrote:
> We don't need to check if the list is empty separately
> as we could use list_first_entry_or_null to cover it.
> 
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>

Looks fine to me.

Reviewed-by: Brian Norris <briannorris@chromium.org>
