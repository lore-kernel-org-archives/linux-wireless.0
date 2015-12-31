Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42411 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbbLaNNX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 08:13:23 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] wil6210: fix a warning message condition
References: <20151216111000.GC21018@mwanda>
Date: Thu, 31 Dec 2015 15:13:16 +0200
In-Reply-To: <20151216111000.GC21018@mwanda> (Dan Carpenter's message of "Wed,
	16 Dec 2015 14:10:00 +0300")
Message-ID: <87a8oqoj6b.fsf@kamboji.qca.qualcomm.com> (sfid-20151231_141328_315614_52E6F28E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> "iter" is -1 at the end of the loop and not zero.  It means we don't
> print a warning message.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied to ath.git, thanks.

-- 
Kalle Valo
