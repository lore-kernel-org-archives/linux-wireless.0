Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38662 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750801AbcKYKA1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 05:00:27 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/4] rsi: Add support to filter rx frames
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1479465429-2412-1-git-send-email-prameela.j04cs@gmail.com>
References: <1479465429-2412-1-git-send-email-prameela.j04cs@gmail.com>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de,
        prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20161125094812.A2338613C2@smtp.codeaurora.org> (sfid-20161125_110051_167740_0F8AEEB4)
Date: Fri, 25 Nov 2016 09:48:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> wrote:
> Filtering rx frames after connection in station mode avoids the
> overhead of processing un-necessary frames. Hence rx filter frame
> is added which can be configured to device at suitable times.
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

4 patches applied to wireless-drivers-next.git, thanks.

e6d6428449c5 rsi: Add support to filter rx frames
8b36de8cf5ab rsi: Add support for configuring tx power
4edbcd1aa783 rsi: Add support for antenna selection
61d108421422 rsi: Add support for 802.11d

-- 
https://patchwork.kernel.org/patch/9436189/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
