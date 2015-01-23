Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:42769 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbbAWTQt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 14:16:49 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k_htc: remove dead code in error path of
 ath9k_htc_txcompletion_cb
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1421694141-18337-1-git-send-email-linville@tuxdriver.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	ath9k-devel@venema.h4ckr.net,
	"John W. Linville" <linville@tuxdriver.com>
Message-Id: <20150123191648.C0F2D141D80@smtp.codeaurora.org> (sfid-20150123_201652_417122_3C580655)
Date: Fri, 23 Jan 2015 19:16:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This clause is conditioned on htc_hdr != NULL, but it will only be NULL
> when that check is reached.
> 
> Coverity: CID 114318
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
