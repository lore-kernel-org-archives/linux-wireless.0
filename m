Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:5471 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbcAOIiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2016 03:38:52 -0500
From: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 1/5] ath9k: avoid ANI restart if no trigger
Date: Fri, 15 Jan 2016 08:38:46 +0000
Message-ID: <1452847122461.2165@qti.qualcomm.com> (sfid-20160115_093857_987075_BB30CFB0)
References: <1452821009-1156-1-git-send-email-miaoqing@codeaurora.org>
	<1452821009-1156-2-git-send-email-miaoqing@codeaurora.org>,<871t9j8e7i.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <871t9j8e7i.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit 54da20d83f0e7fe87b75aec44bc2b1448d119320 ("ath9k_hw: improve ANI processing and rx desensitizing parameters") first introduced this issue, ath9k_ani_restart() is always be invoked is wrong.

Thanks,
Miaoqing

________________________________________
From: Valo, Kalle
Sent: Friday, January 15, 2016 4:00 PM
To: miaoqing@codeaurora.org
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; ath9k-devel
Subject: Re: [PATCH 1/5] ath9k: avoid ANI restart if no trigger

<miaoqing@codeaurora.org> writes:

> From: Miaoqing Pan <miaoqing@codeaurora.org>
>
> ath9k_ani_restart() is always be invoked even if the trigger
> condition is false.
>
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

Why? The commit log should always answer that.

--
Kalle Valo
