Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:46137 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbbA0AML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 19:12:11 -0500
Date: Mon, 26 Jan 2015 16:12:10 -0800 (PST)
Message-Id: <20150126.161210.78215547165591571.davem@davemloft.net> (sfid-20150127_011216_657212_DB4713F9)
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2015-01-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <87h9vjnic4.fsf@kamboji.qca.qualcomm.com>
References: <87h9vjnic4.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Thu, 22 Jan 2015 13:52:11 +0200

> now a bigger pull request for net-next. Rafal found a UTF-8 bug in
> patchwork[1] and because of that two commits (d0c102f70aec and
> d0f66df5392a) have his name corrupted:
> 
>     Acked-by: Rafa? Mi?ecki <zajec5@gmail.com>
> 
> Somehow I failed to spot that when I commited the patches. As rebasing
> public git trees is bad, I thought we can live with these and decided
> not to rebase. But I'll pay close attention to this in the future to
> make sure that it won't happen again. Also we requested an update to
> patchwork.kernel.org, the latest patchwork doesn't seem to have this
> bug.
> 
> Also please note this pull request also adds one DT binding doc, but
> this was reviewed in the device tree list:
> 
>  .../bindings/net/wireless/qcom,ath10k.txt          |   30 +
> 
> Please let me know if you have any issues.

Pulled, thanks.
