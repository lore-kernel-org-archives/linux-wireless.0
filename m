Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56365 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751987AbcICJ6P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 05:58:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 1/8] mwifiex: Fixed endianness problem for big endian platform
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1469461871-3135-2-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Karthik D A <karthida@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160903095814.E77D162017@smtp.codeaurora.org> (sfid-20160903_115818_972495_1EAFDE08)
Date: Sat,  3 Sep 2016 09:58:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Karthik D A <karthida@marvell.com>
> 
> The driver sends and recives information to and from the firmware.
> Correct endianness should be ensured as firmware follows little
> endian format and host can be little/big endian.
> 
> Signed-off-by: Karthik D A <karthida@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 8 patches applied to wireless-drivers-next.git:

902831a7629b mwifiex: Fixed endianness problem for big endian platform
e5988c62b9e6 mwifiex: add region code information in debugfs
c8ccf3ade785 mwifiex: fix failed to reconnect after interface disabled/enabled
c2a8f0ff9c6c mwifiex: support random MAC address for scanning
99ffe72cdae4 mwifiex: process rxba_sync event
5536c4aafcac mwifiex: remove misleading disconnect message
432da7d243da mwifiex: add HT aggregation support for adhoc mode
441756b6a6e3 mwifiex: fix radar detection issue

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9245981/
