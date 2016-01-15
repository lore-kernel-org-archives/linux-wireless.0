Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31785 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbcAOJlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2016 04:41:23 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
CC: "miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 1/5] ath9k: avoid ANI restart if no trigger
References: <1452821009-1156-1-git-send-email-miaoqing@codeaurora.org>
	<1452821009-1156-2-git-send-email-miaoqing@codeaurora.org>
	<871t9j8e7i.fsf@kamboji.qca.qualcomm.com>
	<1452847122461.2165@qti.qualcomm.com>
Date: Fri, 15 Jan 2016 11:41:03 +0200
In-Reply-To: <1452847122461.2165@qti.qualcomm.com> (Miaoqing Pan's message of
	"Fri, 15 Jan 2016 10:38:46 +0200")
Message-ID: <87wprb6uz4.fsf@kamboji.qca.qualcomm.com> (sfid-20160115_104128_829635_772466F0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Pan, Miaoqing" <miaoqing@qti.qualcomm.com> writes:

> The commit 54da20d83f0e7fe87b75aec44bc2b1448d119320 ("ath9k_hw:
> improve ANI processing and rx desensitizing parameters") first
> introduced this issue, ath9k_ani_restart() is always be invoked is
> wrong.

Then you should add this to the commit log:

Fixes: 54da20d83f0e ("ath9k_hw: improve ANI processing and rx desensitizing parameters")

Also you need to explain more, especially why you think it's wrong. How
did you notice this? What kind of user visible issue this fixes?

-- 
Kalle Valo
