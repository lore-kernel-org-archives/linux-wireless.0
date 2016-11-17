Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43496 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938318AbcKQGnX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 01:43:23 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wlcore: Allow scans when in AP mode
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1475855157-21271-1-git-send-email-xander.huff@ni.com>
References: <1475855157-21271-1-git-send-email-xander.huff@ni.com>
To: Xander Huff <xander.huff@ni.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        James Minor <james.minor@ni.com>, linux-kernel@vger.kernel.org,
        xander.huff@ni.com
Message-Id: <20161117064322.50C93615D8@smtp.codeaurora.org> (sfid-20161117_074346_739670_43769960)
Date: Thu, 17 Nov 2016 06:43:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xander Huff <xander.huff@ni.com> wrote:
> From: James Minor <james.minor@ni.com>
> 
> When in AP mode, scans can be done without changing firmware to
> the multi-role firmware. Allow the interface to scan if forced
> in the scan request.
> 
> Signed-off-by: James Minor <james.minor@ni.com>
> Signed-off-by: Xander Huff <xander.huff@ni.com>
> Reviewed-by: Ben Shelton <ben.shelton@ni.com>
> Reviewed-by: Jaeden Amero <jaeden.amero@ni.com>

Patch applied to wireless-drivers-next.git, thanks.

87016f5eb1a3 wlcore: Allow scans when in AP mode

-- 
https://patchwork.kernel.org/patch/9366467/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
