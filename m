Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35712 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751739AbdATJrr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 04:47:47 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: don't complain about 'unknown event id: 0x63'
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170114021657.147016-1-briannorris@chromium.org>
References: <20170114021657.147016-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20170120094746.8FDEC609C9@smtp.codeaurora.org> (sfid-20170120_104807_014427_7070F020)
Date: Fri, 20 Jan 2017 09:47:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> Marvell folks tell me this is a debugging event that the driver doesn't
> need to handle, but on 8997 w/ firmware 16.68.1.p97, I see several of
> these sorts of messages at (for instance) boot time:
> 
> [   13.825848] mwifiex_pcie 0000:01:00.0: event: unknown event id: 0x63
> [   14.838561] mwifiex_pcie 0000:01:00.0: event: unknown event id: 0x63
> [   14.850397] mwifiex_pcie 0000:01:00.0: event: unknown event id: 0x63
> [   32.529923] mwifiex_pcie 0000:01:00.0: event: unknown event id: 0x63
> 
> Let's handle this "event" with a much lower verbosity.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

0ed917d09d51 mwifiex: don't complain about 'unknown event id: 0x63'

-- 
https://patchwork.kernel.org/patch/9516687/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
