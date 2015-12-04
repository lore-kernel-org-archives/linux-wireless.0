Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbbLDPrG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2015 10:47:06 -0500
Date: Fri, 4 Dec 2015 16:46:04 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] iwlegacy: cleanup end of il_send_add_sta()
Message-ID: <20151204154544.GA25510@redhat.com> (sfid-20151204_164712_445744_0E5A36E7)
References: <20151204131645.GC12792@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151204131645.GC12792@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 04, 2015 at 04:16:45PM +0300, Dan Carpenter wrote:
> This code causes a static checker warning because we check for
> "if (ret == 0)" but we have already had verified that was true.  Clean
> it up a little.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
