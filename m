Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54439 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965099AbcIZPG5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 11:06:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/3] hostap: Delete an unnecessary jump label in
 prism2_ioctl_priv_hostapd()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <65ed528f-7ec5-a0f2-6219-3e63a78ca0ee@users.sourceforge.net>
References: <65ed528f-7ec5-a0f2-6219-3e63a78ca0ee@users.sourceforge.net>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Message-Id: <20160926150656.54D1A613F9@smtp.codeaurora.org> (sfid-20160926_170718_143401_E5331B1E)
Date: Mon, 26 Sep 2016 15:06:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SF Markus Elfring <elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 20 Aug 2016 18:21:29 +0200
> 
> Remove a jump label which is unneeded in this function at the end.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

2 patches set to Rejected.

9291771 [2/3] hostap: Delete an unnecessary jump label in prism2_ioctl_priv_hostapd()
9291775 [3/3] hostap: Delete unnecessary initialisations for the variable "ret"

Reason: The benefit is not clear.

-- 
https://patchwork.kernel.org/patch/9291771/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
