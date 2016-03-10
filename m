Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44427 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbcCJM5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 07:57:25 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: libertas: fix an error code in probe
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160308120408.GA28684@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andreas Kemnade <andreas@kemnade.info>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Message-Id: <20160310125724.879A060DB3@smtp.codeaurora.org> (sfid-20160310_135729_414576_50EBC732)
Date: Thu, 10 Mar 2016 12:57:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> We accidentally return success instead of a negative error code.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
