Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57602 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529AbcGHNt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 09:49:28 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: fix interrupt processing corner case in MSI mode
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1467377812-5716-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Shengzhen Li <szli@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160708134927.D2071611DF@smtp.codeaurora.org> (sfid-20160708_154931_972052_EC6D7F8D)
Date: Fri,  8 Jul 2016 13:49:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Shengzhen Li <szli@marvell.com>
> 
> As interrupt is read in interrupt handler as well as interrupt processing
> thread, we observed a corner case issue for MSI in which interrupt gets
> processed twice.
> 
> This patch moves interrupt reading code for MSI mode from
> mwifiex_interrupt_status() to mwifiex_pcie_process_int() to avoid the
> issue.
> 
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

5781fc29dbbd mwifiex: fix interrupt processing corner case in MSI mode

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9209885/

