Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37859 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbbK3M6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 07:58:30 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: libertas: cleanup a variable name
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20151126120449.GK10556@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Message-Id: <20151130125830.29FEA1409D5@smtp.codeaurora.org> (sfid-20151130_135834_464514_49160BDE)
Date: Mon, 30 Nov 2015 12:58:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> "&card->priv->driver_lock" and "&priv->driver_lock" are the same and
> it's nicer to use the shorter one consistently.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
