Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53749 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbcBFMBm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2016 07:01:42 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: fix a reversed condition
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160202100005.GA3040@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	chunfan chen <jeffc@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20160206120141.65A2B60445@smtp.codeaurora.org> (sfid-20160206_130145_748080_CB2207EC)
Date: Sat,  6 Feb 2016 12:01:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The NULL test here is reversed.
> 
> Fixes: 7d7f07d8c5d3 ('mwifiex: add wowlan net-detect support')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
