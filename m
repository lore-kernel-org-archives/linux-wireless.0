Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:44750 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbbJ1C7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 22:59:36 -0400
Date: Tue, 27 Oct 2015 20:16:18 -0700 (PDT)
Message-Id: <20151027.201618.2181567284358003532.davem@davemloft.net> (sfid-20151028_035957_594095_BC24C24C)
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2015-10-27
From: David Miller <davem@davemloft.net>
In-Reply-To: <87y4eowvf5.fsf@kamboji.qca.qualcomm.com>
References: <87y4eowvf5.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Tue, 27 Oct 2015 10:46:38 +0200

> here's a bigger pull request for 4.4. The diffstat looks scary as we
> created a new directory realtek for all realtek drivers. In the future
> I'm planning to create similar directories for all vendors, currently we
> just have ath, mediatek and realtek. This change has been in linux-next
> for a couple of weeks so it should be safe, but of course you never
> know.
> 
> There's also a new driver rtl8xxxu for few realtek USB devices. This
> just made it to the last linux-next build.
> 
> Otherwise there's nothing really special, more info below. If time
> permits, and it's ok for you, I'm hoping to send you a one more pull
> request this week.

Pulled, thanks.
