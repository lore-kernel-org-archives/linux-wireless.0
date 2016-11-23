Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59542 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965259AbcKWPgn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 10:36:43 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/7] mwifiex: Removed unused mwifiex_private* 'priv' variable
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <ad72403d4d99a1b13ea7f99b0ea992b23aa2ea09.1479458373.git.kirtika@google.com>
References: <ad72403d4d99a1b13ea7f99b0ea992b23aa2ea09.1479458373.git.kirtika@google.com>
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Avinash Patil <patila@marvell.com>
Message-Id: <20161123153637.63104605B6@smtp.codeaurora.org> (sfid-20161123_163658_825380_DD10EC3C)
Date: Wed, 23 Nov 2016 15:36:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kirtika Ruchandani <kirtika.ruchandani@gmail.com> wrote:
> Commit bec568ff5107 removed the last remaining usage of struct
> mwifiex_private* priv in mwifiex_fw_dpc(), by removing the call to
> mwifiex_del_virtual_intf().
> Compiling mwifiex/ with W=1 gives the following warning, fix it.
> mwifiex/main.c: In function ‘mwifiex_fw_dpc’:
> mwifiex/main.c:520:26: warning: variable ‘priv’ set but not used [-Wunused-but-set-variable]
> 
> Fixes: bec568ff5107 ("mwifiex: failure path handling in mwifiex_add_virtual_intf()")
> Cc: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Kirtika Ruchandani <kirtika@google.com>

Failed to apply to wireless-drivers-next:

Applying: mwifiex: Remove unused 'pm_flag' variable
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/marvell/mwifiex/sdio.c
CONFLICT (content): Merge conflict in drivers/net/wireless/marvell/mwifiex/sdio.c
Failed to merge in the changes.
Patch failed at 0001 mwifiex: Remove unused 'pm_flag' variable

7 patches set to Changes Requested.

9435943 [1/7] mwifiex: Removed unused mwifiex_private* 'priv' variable
9435945 [2/7] mwifiex: Remove unused 'chan_num' variable
9435947 [3/7] mwifiex: Remove unused 'sta_ptr' variable
9435949 [4/7] mwifiex: Remove unused 'adapter'variable
9435951 [5/7] mwifiex: Remove unused 'pm_flag' variable
9435953 [6/7] mwifiex: Removed unused 'pkt_type' variable
9435955 [7/7] mwifiex: Remove unused 'bcd_usb' variable

-- 
https://patchwork.kernel.org/patch/9435943/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
