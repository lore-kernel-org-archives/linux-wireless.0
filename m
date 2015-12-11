Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41004 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbbLKLWc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 06:22:32 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: hostap: fix an error code in prism2_config()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20151204131746.GE12792@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Message-Id: <20151211112232.34708141AC6@smtp.codeaurora.org> (sfid-20151211_122238_809180_52C5815E)
Date: Fri, 11 Dec 2015 11:22:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The current code returns success if prism2_init_local_data() fails, but
> we want to return an error code.  Also we can remove the bogus
> ret initializer because it is wrong and never used.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
