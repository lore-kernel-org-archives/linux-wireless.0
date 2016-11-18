Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53386 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751243AbcKRLL5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 06:11:57 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/2] mwifiex: ignore calibration data failure
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1477062948-8558-2-git-send-email-akarwar@marvell.com>
References: <1477062948-8558-2-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20161118111156.AC772625EB@smtp.codeaurora.org> (sfid-20161118_121200_925838_175E0B63)
Date: Fri, 18 Nov 2016 11:11:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> Firmware may reject calibration data from host for certain OTP
> settings. In that case, we should continue initialisation ignoring
> the failure.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

14e5e9375926 mwifiex: ignore calibration data failure

-- 
https://patchwork.kernel.org/patch/9389487/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
