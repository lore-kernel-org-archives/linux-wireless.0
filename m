Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36066 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbcEKTDf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 15:03:35 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: atmel: potential underflow in atmel_set_freq()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160510192117.GC30712@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Simon Kelley <simon@thekelleys.org.uk>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Message-Id: <20160511190334.5797D61322@smtp.codeaurora.org> (sfid-20160511_210354_722718_2322A1FF)
Date: Wed, 11 May 2016 19:03:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Smatch complains that we cap the upper bound of "fwrq->m" but not the
> lower bound.  I don't know if it can actually happen but it's simple
> enough to check for negatives.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

d9739a26fbca atmel: potential underflow in atmel_set_freq()

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9061371/

