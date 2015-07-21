Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58061 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbbGUNrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 09:47:14 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: do not short circuit exit from mwifiex_set_mgmt_ies
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1435086243-10433-1-git-send-email-linville@tuxdriver.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>
Message-Id: <20150721134713.B7491141090@smtp.codeaurora.org> (sfid-20150721_154716_976250_023CD77B)
Date: Tue, 21 Jul 2015 13:47:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Without this change, the code simply exits after calling
> mwifiex_uap_set_head_tail_ies, leving the call to
> mwifiex_set_mgmt_beacon_data_ies as dead code.
> 
> Coverity CID #1271292
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
