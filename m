Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52129 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbcFVJBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 05:01:49 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>
Subject: Re: [PATCH V2 2/2] ath6kl: replace semaphore with mutex
Date: Wed, 22 Jun 2016 08:59:59 +0000
Message-ID: <87h9cliooi.fsf@kamboji.qca.qualcomm.com> (sfid-20160622_110217_739745_F23F3388)
References: <20160621232210.5801-1-chaehyun.lim@gmail.com>
In-Reply-To: <20160621232210.5801-1-chaehyun.lim@gmail.com> (Chaehyun Lim's
	message of "Wed, 22 Jun 2016 08:22:10 +0900")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Adding ath6k list)

Chaehyun Lim <chaehyun.lim@gmail.com> writes:

> It replaces struct semaphore sem with struct mutex mutex
>
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
> V2: fix build failure reported by kbuild test robot

I don't think Reported-by is correct, it should be only used when
reporting the original issue

Have you tested this on a real device? I'm reluctant to apply this big
locking change without some level of testing.

-- 
Kalle Valo