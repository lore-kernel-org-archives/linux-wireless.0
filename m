Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52982 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeE2HW1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 03:22:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: avoid exporting mwifiex_send_cmd
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1527159988-20624-1-git-send-email-gbhat@marvell.com>
References: <1527159988-20624-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20180529072227.3B15F60646@smtp.codeaurora.org> (sfid-20180529_092230_668641_34C97840)
Date: Tue, 29 May 2018 07:22:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> This is a follow-up patch for commit 21c5c83ce833
> ("mwifiex: support sysfs initiated device coredump").
> 
> Let us avoid exporting mwifiex_send_cmd and instead use a utility
> function mwifiex_fw_dump_event to achive the work.
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

618fd1ed17d4 mwifiex: avoid exporting mwifiex_send_cmd

-- 
https://patchwork.kernel.org/patch/10424201/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
