Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46125 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034381AbcIZOTp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 10:19:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] hostap: Use memdup_user() rather than duplicating its
 implementation
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <efa66c16-7998-9ceb-0be6-d62dd249a2dc@users.sourceforge.net>
References: <efa66c16-7998-9ceb-0be6-d62dd249a2dc@users.sourceforge.net>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Message-Id: <20160926141944.A5DA06151E@smtp.codeaurora.org> (sfid-20160926_162008_371217_FA769EE1)
Date: Mon, 26 Sep 2016 14:19:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SF Markus Elfring <elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 20 Aug 2016 18:19:43 +0200
> 
> Reuse existing functionality from memdup_user() instead of keeping
> duplicate source code.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Patch set to Rejected.

[1/3] hostap: Use memdup_user() rather than duplicating i... 2016-08-20 SF Markus El Rejected

Reason: A similar patch is already applied.

Applying: hostap: Use memdup_user() rather than duplicating its implementation
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/intersil/hostap/hostap_ioctl.c
CONFLICT (content): Merge conflict in drivers/net/wireless/intersil/hostap/hostap_ioctl.c
Failed to merge in the changes.
Patch failed at 0001 hostap: Use memdup_user() rather than duplicating its implementation

-- 
https://patchwork.kernel.org/patch/9306999/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
