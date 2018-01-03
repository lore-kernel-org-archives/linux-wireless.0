Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:55953 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750952AbeACULD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jan 2018 15:11:03 -0500
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] wireless: libertas_tf: Adjustments for three function
 implementations
Message-ID: <e8b93aae-8dea-7089-43fe-9222054f0749@users.sourceforge.net> (sfid-20180103_211124_759496_D5B6AB6A)
Date: Wed, 3 Jan 2018 21:10:55 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 3 Jan 2018 21:06:54 +0100

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete an error message for a failed memory allocation
    in __if_usb_submit_rx_urb()
  Improve a size determination in two functions

 drivers/net/wireless/marvell/libertas_tf/if_usb.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
2.15.1
