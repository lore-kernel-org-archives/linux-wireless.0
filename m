Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:44388 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbbFDGqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 02:46:17 -0400
Date: Wed, 03 Jun 2015 23:46:15 -0700 (PDT)
Message-Id: <20150603.234615.1661393741259779017.davem@davemloft.net> (sfid-20150604_084626_408536_EA0374FA)
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2015-06-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <87bngwtv1o.fsf@kamboji.qca.qualcomm.com>
References: <87bngwtv1o.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Wed, 03 Jun 2015 23:07:47 +0300

> here's a pull request for 4.2. Most notable change here is a new driver
> mt7601u for a Mediatek USB Wi-Fi device, for other driver more
> information in the signed tag. There's a trivial conflict in iwlwifi
> Kconfig help text but otherwise I'm not expecting any issues. But please
> let me know if you have any problems.

Pulled, thanks for the heads up about the trivial conflict.
