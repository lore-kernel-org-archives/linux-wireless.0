Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57338 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbdJ3Ktl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 06:49:41 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: do not transmit in 11N rates when connected in TKIP
 security
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1509098569-19307-1-git-send-email-gbhat@marvell.com>
References: <1509098569-19307-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20171030104940.A79C0605A4@smtp.codeaurora.org> (sfid-20171030_114943_942430_930EF102)
Date: Mon, 30 Oct 2017 10:49:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> Driver is transmitting in 11N rates, when connected to an AP in
> TKIP security mode. Add a check to disable_11n to fix the issue.
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

c6c65a8411cf mwifiex: do not transmit in 11N rates when connected in TKIP security

-- 
https://patchwork.kernel.org/patch/10029519/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
