Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48781 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbcAGJSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 04:18:01 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 2/4] mwifiex: enable pcie MSIx interrupt mode support
References: <1451571855-29449-1-git-send-email-akarwar@marvell.com>
	<1451571855-29449-2-git-send-email-akarwar@marvell.com>
Date: Thu, 07 Jan 2016 11:17:54 +0200
In-Reply-To: <1451571855-29449-2-git-send-email-akarwar@marvell.com>
	(Amitkumar Karwar's message of "Thu, 31 Dec 2015 06:24:13 -0800")
Message-ID: <87egdtlpdp.fsf@kamboji.qca.qualcomm.com> (sfid-20160107_101813_643974_C7DC20C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> From: Xinming Hu <huxm@marvell.com>
>
> Newer pcie chipsets (8997 onwards) support MSIx. This
> patch enables it.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

I have dropped this patch, please resend once the build issue is solved.

-- 
Kalle Valo
