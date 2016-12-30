Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21341 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751771AbcL3JOl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 04:14:41 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: support dev_coredump for crash dump
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20161221121921.25119.93932.stgit@potku.adurom.net>
References: <20161221121921.25119.93932.stgit@potku.adurom.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <ea5cf07e249847d5a4f5078c8f31889e@euamsexm01a.eu.qualcomm.com> (sfid-20161230_101445_031176_1186916B)
Date: Fri, 30 Dec 2016 10:14:34 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> From: Arun Khandavalli <akhandav@qti.qualcomm.com>
> 
> Whenever firmware crashes, and both CONFIG_ATH10K_DEBUGFS and
> CONFIG_ALLOW_DEV_COREDUMP are enabled, dump information about the crash via a
> devcoredump device. Dump can be read from userspace for further analysis from:
> 
> /sys/class/devcoredump/devcd*/data
> 
> As until now we have provided the firmware crash dump file via fw_crash_dump
> debugfs keep it still available but deprecate and a warning print that the user
> should switch to using dev_coredump.
> 
> Future improvement would be not to depend on CONFIG_ATH10K_DEBUGFS, as there
> might be systems which want to get the firmware crash dump but not enable
> debugfs. How to handle memory consumption is also something which needs to be
> taken into account.
> 
> Signed-off-by: Arun Khandavalli <akhandav@qti.qualcomm.com>
> [kvalo@qca.qualcomm.com: rebase, fixes, improve commit log]
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

727000e6af34 ath10k: support dev_coredump for crash dump

-- 
https://patchwork.kernel.org/patch/9482989/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
