Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54224 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932357AbcK1Phc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 10:37:32 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtl8xxxu: tx rate reported before set
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161126021158.GA12838@box64.home.org>
References: <20161126021158.GA12838@box64.home.org>
To: Barry Day <briselec@gmail.com>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
        linux-wireless@vger.kernel.org
Message-Id: <20161128153731.43276612E9@smtp.codeaurora.org> (sfid-20161128_163735_363668_3741E360)
Date: Mon, 28 Nov 2016 15:37:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Barry Day <briselec@gmail.com> wrote:
> Move the dev_info call that attempts to show the rate used before it is set.
> 
> Signed-off-by: Barry Day <briselec@gmail.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Barry Day <briselec@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

c06696a95820 rtl8xxxu: tx rate reported before set

-- 
https://patchwork.kernel.org/patch/9448225/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
