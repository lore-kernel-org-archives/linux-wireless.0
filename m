Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45024 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753774AbcL3L02 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 06:26:28 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: change width of MAC control variable
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1481873145-5381-1-git-send-email-akarwar@marvell.com>
References: <1481873145-5381-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20161230112628.3D2DE6145C@smtp.codeaurora.org> (sfid-20161230_122632_414975_29578FF7)
Date: Fri, 30 Dec 2016 11:26:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> Firmware has started making use of reserved field.
> Accordingly change curr_pkt_filter from u16 to u32.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

2 patches applied to wireless-drivers-next.git, thanks.

b82dd3bdf1a1 mwifiex: change width of MAC control variable
d7864cf21235 mwifiex: Enable dynamic bandwidth signalling

-- 
https://patchwork.kernel.org/patch/9477347/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
