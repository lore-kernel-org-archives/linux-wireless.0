Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54024 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbcDZJ3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:29:23 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: missing error code on allocation failure
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160419142158.GA4876@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20160426092922.97867612EC@smtp.codeaurora.org> (sfid-20160426_112929_056026_F64DD32D)
Date: Tue, 26 Apr 2016 09:29:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> We accidentally return success instead of -ENOMEM.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

e0bdef0f75f0 mwifiex: missing error code on allocation failure
394f0ed53108 mwifiex: fix loop timeout in mwifiex_prog_fw_w_helper()

Kalle Valo
