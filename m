Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:34707 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbbFOSZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 14:25:33 -0400
MIME-Version: 1.0
In-Reply-To: <1434389075-4693-1-git-send-email-hofrat@osadl.org>
References: <1434389075-4693-1-git-send-email-hofrat@osadl.org>
Date: Mon, 15 Jun 2015 22:25:32 +0400
Message-ID: <CA++WF2Ppn66VP8fq5Q-MXY_=7M3TqPM_tbF5VzWtVb1osyAngA@mail.gmail.com> (sfid-20150615_202537_294458_BA071FE4)
Subject: Re: [PATCH] wireless: ipw2100: fix timeout bug - always evaluated to 0
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	James Ketrenos <jketreno@linux.intel.com>,
	wireless <linux-wireless@vger.kernel.org>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 June 2015 at 21:24, Nicholas Mc Guire <hofrat@osadl.org> wrote:
> commit: commit 2c86c275015c ("Add ipw2100 wireless driver.") introduced
> HW_PHY_OFF_LOOP_DELAY (HZ / 5000) which always evaluated to 0. Clarified
> by Stanislav Yakovlev <stas.yakovlev@gmail.com> that it should be 50
> milliseconds thus fixed up to msecs_to_jiffies(50).
>
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> ---
>
> Patch was compile tested with x86_64_defconfig + CONFIG_IPW2100=m
> (with a few buildwarnings in ipw2100.c though not related to this patch)
>
> Patch is against 4.1-rc7 (localversion-next is -next-20150615)
>
>  drivers/net/wireless/ipw2x00/ipw2100.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Acked-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>

Stanislav.
