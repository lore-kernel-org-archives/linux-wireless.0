Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41033 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbbLKLXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 06:23:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: prism54: off by one BUG_ON() test
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20151204131949.GF12792@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20151211112320.5798B141ACB@smtp.codeaurora.org> (sfid-20151211_122324_578067_9804B2D3)
Date: Fri, 11 Dec 2015 11:23:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This code was supposed to trigger a BUG() if we truncate the output but
> it's off by one so it allows one character to be truncated.  Really
> drivers shouldn't call BUG_ON() and especially for something minor like
> this so I've changed it to a WARN_ON().
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
