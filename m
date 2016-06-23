Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:35129 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbcFWTlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 15:41:14 -0400
Date: Thu, 23 Jun 2016 15:41:07 -0400 (EDT)
Message-Id: <20160623.154107.694884084216639870.davem@davemloft.net> (sfid-20160623_214136_846201_B2A74E88)
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2016-06-21
From: David Miller <davem@davemloft.net>
In-Reply-To: <87a8ien7hq.fsf@kamboji.qca.qualcomm.com>
References: <87a8ien7hq.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Tue, 21 Jun 2016 13:47:45 +0300

> I hope it's ok to send two pull requests the same day, both for net
> and net-next? This is targeted to 4.8 so it is for net-next.

Yeah that's fine.

> Even though is this the first pull request for 4.8 we actually
> remove more code than add, thanks to Guenter Roeck's on removing
> unused "phy_a" support from b43. Otherwise there's not really
> anything standing out, adding new chipset support to brcmfmac and
> ath10k, lots of fixes and the usual.

Pulled, thanks.
