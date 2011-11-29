Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63805 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1K2MBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 07:01:18 -0500
Message-ID: <4ED4C8CE.8030408@qca.qualcomm.com> (sfid-20111129_130124_684870_7C597205)
Date: Tue, 29 Nov 2011 13:58:06 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>
Subject: Re: pull request: wireless-next 2011-11-28
References: <20111128200221.GD2681@tuxdriver.com> <20111128.195516.37800643865997337.davem@davemloft.net>
In-Reply-To: <20111128.195516.37800643865997337.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2011 02:55 AM, David Miller wrote:

> Pulled, but please push back on the ath6kl guys, they seem to have
> this disease where they add tons of debugfs files

Sorry about that. I was under impression that there are no strict rules
for debugfs files and drivers can add them without too much worries, but
it seems I was wrong.

> for controlling things like QoS from userspace instead of creating
> and using generic configuration machanisms via netlink or similar
> that any other driver could support too.

Adding a generic QoS interface would take some time to implement and I
doubt that we (=ath6kl team) can do that anytime soon as our first
challange has been to get ath6kl working properly with cfg80211. That's
why we ended up having a debugfs interface for qos as our first step.

Kalle
