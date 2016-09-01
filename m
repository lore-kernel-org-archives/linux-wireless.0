Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52768 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934075AbcIAQPt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 12:15:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: linux-4.8-rcX:  ath9k traceback
References: <1472682267.2607.8.camel@linux.vnet.ibm.com>
Date: Thu, 01 Sep 2016 19:15:42 +0300
In-Reply-To: <1472682267.2607.8.camel@linux.vnet.ibm.com> (Mimi Zohar's
        message of "Wed, 31 Aug 2016 18:24:27 -0400")
Message-ID: <87eg5338b5.fsf@purkki.adurom.net> (sfid-20160901_181554_219297_9FF35905)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mimi Zohar <zohar@linux.vnet.ibm.com> writes:

> There weren't any problems on linux-4.7 kernels.  I'm getting the
> following traceback on linux-4.8-rc1/-rc4 kernels.  Let me know if you
> need any additional information.
>
> [   64.006529] WARNING: CPU: 3 PID: 94 at drivers/net/wireless/ath/ath9k/beacon.c:642 ath9k_beacon_config+0x12c/0x140 [ath9k]

This should fix it:

ath9k: fix client mode beacon configuration

https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=05860bed491b114a9f2d7a4f6e09fb02c0b69056

-- 
Kalle Valo
