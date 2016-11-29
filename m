Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45040 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757695AbcK2P2Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 10:28:16 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2, 1/7] mwifiex: Removed unused mwifiex_private* 'priv' variable
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <fa8a77df4638cf21720d8c5094afb83475947843.1479950323.git.kirtika@google.com>
References: <fa8a77df4638cf21720d8c5094afb83475947843.1479950323.git.kirtika@google.com>
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Avinash Patil <patila@marvell.com>
Message-Id: <20161129152816.14B74612BA@smtp.codeaurora.org> (sfid-20161129_162820_462552_D856DFFB)
Date: Tue, 29 Nov 2016 15:28:16 +0000 (UTC)
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

7 patches applied to wireless-drivers-next.git, thanks.

70d740598713 mwifiex: Removed unused mwifiex_private* 'priv' variable
8ac9134161d9 mwifiex: Remove unused 'chan_num' variable
2c2bcabf02e1 mwifiex: Remove unused 'sta_ptr' variable
60261b266a84 mwifiex: Remove unused 'adapter'variable
e9f1db8b6859 mwifiex: Remove unused 'pm_flag' variable
67dd2a754906 mwifiex: Removed unused 'pkt_type' variable
4133828c76c3 mwifiex: Remove unused 'bcd_usb' variable

-- 
https://patchwork.kernel.org/patch/9444651/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
