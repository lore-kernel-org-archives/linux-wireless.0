Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45724 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753808AbcL3L2W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 06:28:22 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja\@google.com" <rajatja@google.com>,
        "briannorris\@google.com" <briannorris@google.com>,
        "dmitry.torokhov\@gmail.com" <dmitry.torokhov@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [1/2] mwifiex: code rearrangement in pcie.c and sdio.c
References: <1480517537-9920-1-git-send-email-akarwar@marvell.com>
        <20161205110906.28C706034F@smtp.codeaurora.org>
        <25e936b31e1e4f3d9db2c2309da9f798@SC-EXCH04.marvell.com>
Date: Fri, 30 Dec 2016 13:28:16 +0200
In-Reply-To: <25e936b31e1e4f3d9db2c2309da9f798@SC-EXCH04.marvell.com>
        (Amitkumar Karwar's message of "Wed, 7 Dec 2016 10:52:15 +0000")
Message-ID: <87mvfdk65r.fsf@kamboji.qca.qualcomm.com> (sfid-20161230_122826_200004_5683E5D4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> Hi Kalle,
>
>> Failed to apply:
>> 
>> fatal: sha1 information is lacking or useless
>> (drivers/net/wireless/marvell/mwifiex/pcie.c).
>> Applying: mwifiex: get rid of global user_rmmod flag Repository lacks
>> necessary blobs to fall back on 3-way merge.
>> Cannot fall back to three-way merge.
>> Patch failed at 0001 mwifiex: get rid of global user_rmmod flag
>> 
>> 2 patches set to Changes Requested.
>> 
>> 9454491 [1/2] mwifiex: code rearrangement in pcie.c and sdio.c
>> 9454493 [2/2] mwifiex: get rid of global user_rmmod flag
>> 
>> --
>> https://patchwork.kernel.org/patch/9454491/
>> 
>> Documentation about submitting wireless patches and checking status
>> from patchwork:
>> 
>> https://wireless.wiki.kernel.org/en/developers/documentation/submitting
>> patches
>
>
> These two patches have dependency with other patch series. I want you to consider patches in following order(first being recent).
>
> mwifiex: sdio: fix use after free issue for save_adapter

This applied fine.

> mwifiex: use module_*_driver helper macros
>
> [2/2] mwifiex: get rid of global user_rmmod flag
> [1/2] mwifiex: code rearrangement in pcie.c and sdio.c
>
> [v3,5/5] mwifiex: move pcie_work and related variables inside card -------- This series can be accepted if there are no further concerns/comments from Brian/Dmitry. 
> [v3,4/5] mwifiex: wait firmware dump complete during card remove process
> [v3,3/5] mwifiex: get rid of drv_info* adapter variables
> [v3,2/5] mwifiex: do not free firmware dump memory in shutdown_drv
> [v3,1/5] mwifiex: don't wait for main_process in shutdown_drv

But these didn't. Can you please rebase these and resubmit in one
patchset? Less conflicts that way.

-- 
Kalle Valo
