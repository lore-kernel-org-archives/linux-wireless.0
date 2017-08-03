Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60884 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbdHCJUw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 05:20:52 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 1/2] mwifiex: Do not change bss_num in change_virtual_intf
References: <1501751608-12829-1-git-send-email-huxinming820@gmail.com>
Date: Thu, 03 Aug 2017 12:20:47 +0300
In-Reply-To: <1501751608-12829-1-git-send-email-huxinming820@gmail.com>
        (Xinming Hu's message of "Thu, 3 Aug 2017 09:13:27 +0000")
Message-ID: <87bmnxovm8.fsf@kamboji.qca.qualcomm.com> (sfid-20170803_112057_328093_D4AAB4C3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> writes:

> From: Xinming Hu <huxm@marvell.com>
>
> Commit "mwifiex: Do not change bss_type in change_virtual_intf"
> Keep original bss_type unchanged. bss_num should keep the same
> style, in this way. Unique tuple (bss_type, bss_num) will be
> able to locate the right priv structure.

The preferred way to reference commits is:

Commit 4d7ab36f0c47 ("mwifiex: Do not change bss_type in
change_virtual_intf") kept original bss_type unchanged. bss_num should
keep the same style, in this way. Unique tuple (bss_type, bss_num) will
be able to locate the right priv structure.

I can fix that during commit.

-- 
Kalle Valo
