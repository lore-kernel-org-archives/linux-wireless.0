Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39734 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755197AbcKXHzl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 02:55:41 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Nishant Sarmukadam" <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH v2 0/7] Fix -Wunused-but-set-variable in mwifiex/
Date: Thu, 24 Nov 2016 07:44:58 +0000
Message-ID: <cf27dd85b1ed4ea2a5c1f5e288f49470@SC-EXCH04.marvell.com> (sfid-20161124_085544_484436_8458517E)
References: <cover.1479950323.git.kirtika@google.com>
In-Reply-To: <cover.1479950323.git.kirtika@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Kirtika Ruchandani [mailto:kirtika.ruchandani@gmail.com]
> Sent: Thursday, November 24, 2016 6:54 AM
> To: Amitkumar Karwar
> Cc: Arnd Bergmann; Kalle Valo; linux-wireless@vger.kernel.org; Nishant
> Sarmukadam; Zhaoyang Liu; Bing Zhao; Xinming Hu; Avinash Patil
> Subject: [PATCH v2 0/7] Fix -Wunused-but-set-variable in mwifiex/
> 
> This patchset is part of the effort led by Arnd Bergmann to clean up
> warnings in the kernel. This and following patchsets will focus on "-
> Wunused-but-set-variable" as it among the noisier ones. These were
> found compiling with W=1.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
> 
> ---
> Changes in v2:
> - Reapplied patches on top of wireless-drivers-next.
> - Patch 5/7 ("mwifiex: Remove unused 'pm_flag' variable") had to be
>   redone slightly. The others applied cleanly with 'patch -p1'.
> 
> Kirtika Ruchandani (7):
>   mwifiex: Removed unused mwifiex_private* 'priv' variable
>   mwifiex: Remove unused  'chan_num' variable
>   mwifiex: Remove unused 'sta_ptr' variable
>   mwifiex: Remove unused 'adapter'variable
>   mwifiex: Remove unused 'pm_flag' variable
>   mwifiex: Removed unused 'pkt_type' variable
>   mwifiex: Remove unused 'bcd_usb' variable
> 
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 --
>  drivers/net/wireless/marvell/mwifiex/main.c     | 3 ---
>  drivers/net/wireless/marvell/mwifiex/scan.c     | 8 +++-----
>  drivers/net/wireless/marvell/mwifiex/sdio.c     | 5 -----
>  drivers/net/wireless/marvell/mwifiex/sta_cmd.c  | 2 --
>  drivers/net/wireless/marvell/mwifiex/usb.c      | 3 +--
>  6 files changed, 4 insertions(+), 19 deletions(-)
> 
> --

Thanks for this cleanup work.
Patch series looks fine to me.

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
