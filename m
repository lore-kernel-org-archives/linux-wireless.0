Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44592 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751925AbdHHLtk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:49:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: Do not change bss_num in change_virtual_intf
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1501751608-12829-1-git-send-email-huxinming820@gmail.com>
References: <1501751608-12829-1-git-send-email-huxinming820@gmail.com>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Message-Id: <20170808114939.C53B560115@smtp.codeaurora.org> (sfid-20170808_134943_482767_43C29211)
Date: Tue,  8 Aug 2017 11:49:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> wrote:

> From: Xinming Hu <huxm@marvell.com>
> 
> Commit 4d7ab36f0c47 ("mwifiex: Do not change bss_type in
> change_virtual_intf") kept original bss_type unchanged. bss_num should
> keep the same style, in this way. Unique tuple (bss_type, bss_num) will
> be able to locate the right priv structure.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

2 patches applied to wireless-drivers-next.git, thanks.

2d33140f90e8 mwifiex: Do not change bss_num in change_virtual_intf
20e5476d6c30 mwifiex: wrapper wps ie in pass through tlv

-- 
https://patchwork.kernel.org/patch/9878505/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
