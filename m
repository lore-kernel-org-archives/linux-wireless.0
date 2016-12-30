Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44420 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751691AbcL3LWU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 06:22:20 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: use module_*_driver helper macros
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1480597700-2456-1-git-send-email-akarwar@marvell.com>
References: <1480597700-2456-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20161230112219.B630C612C1@smtp.codeaurora.org> (sfid-20161230_122224_399962_4991BE32)
Date: Fri, 30 Dec 2016 11:22:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> After user_rmmod global flag removal, *_init_module() and
> *_cleanup_module() have become just a wrapper functions.
> We will get rid of them with the help of module_*_driver() macros.
> 
> For pcie, existing ".init_if" handler has same name as what
> module_pcie_driver() macro will create. Let's rename it to
> avoid conflict.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Doesn't apply.

fatal: sha1 information is lacking or useless (drivers/net/wireless/marvell/mwifiex/pcie.c).
Applying: mwifiex: use module_*_driver helper macros
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 mwifiex: use module_*_driver helper macros

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9456135/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
