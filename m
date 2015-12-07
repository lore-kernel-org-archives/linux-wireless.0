Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56463 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778AbbLGPLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2015 10:11:12 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: fix gigantic memleak in rtl_usb
References: <1449424677-3140-1-git-send-email-peter@lekensteyn.nl>
	<5664981C.1040704@lwfinger.net> <20151206213926.GA30777@al>
Date: Mon, 07 Dec 2015 17:11:03 +0200
In-Reply-To: <20151206213926.GA30777@al> (Peter Wu's message of "Sun, 6 Dec
	2015 22:39:26 +0100")
Message-ID: <87k2oqcn08.fsf@kamboji.qca.qualcomm.com> (sfid-20151207_161141_269472_0FB60DA8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Wu <peter@lekensteyn.nl> writes:

> Originally I had the Cc: stable line added, but the SubmittingPatches
> document seems to discourage that for networking. Added it again.

Yeah, stable wireless patches are handled differently from rest of the
networking subsystem. It would be great if somebody could update the
documentation.

-- 
Kalle Valo
