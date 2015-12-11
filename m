Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40731 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbLKLQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 06:16:17 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: iwlegacy: cleanup end of il_send_add_sta()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20151204131645.GC12792@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20151211111616.B1A60141A6F@smtp.codeaurora.org> (sfid-20151211_121621_651567_178D8D68)
Date: Fri, 11 Dec 2015 11:16:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This code causes a static checker warning because we check for
> "if (ret == 0)" but we have already had verified that was true.  Clean
> it up a little.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
