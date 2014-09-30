Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:36330 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaI3GBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 02:01:36 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21546.18274.830284.274616@gargle.gargle.HOWL> (sfid-20140930_080140_131648_9F4180D2)
Date: Tue, 30 Sep 2014 11:32:10 +0530
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath: Add support for tracing
In-Reply-To: <87k34ly992.fsf@kamboji.qca.qualcomm.com>
References: <1411804665-6954-1-git-send-email-sujith@msujith.org>
	<87vbo72bb7.fsf@kamboji.qca.qualcomm.com>
	<21544.64579.558712.465388@gargle.gargle.HOWL>
	<87r3yu3oje.fsf@kamboji.qca.qualcomm.com>
	<21545.4248.512297.913983@gargle.gargle.HOWL>
	<87k34ly992.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> The current debug printing code in ath10k is something like 100 lines, I
> don't see the point of trying to make that common with all ath* drivers.
> 
> In my opinion ath.ko should only have code which used at least two
> different drivers (and I consider ath9k.ko and ath9k_htc.ko as one
> driver). So the right thing here would be to actually move all debugging
> code from ath.ko to ath9k, as it's the only user anyway.

I don't think anyone is interested in moving debug code from ath.ko
to ath9k.ko at this point. There is no benefit and it is just code
churn.

Sujith
