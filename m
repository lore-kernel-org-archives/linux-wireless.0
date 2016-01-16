Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:40810 "EHLO m12-13.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbcAPNRp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jan 2016 08:17:45 -0500
Message-ID: <569A42EA.5080509@163.com> (sfid-20160116_141752_614244_9458E351)
Date: Sat, 16 Jan 2016 21:17:30 +0800
From: Jia-Ju Bai <baijiaju1990@163.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: kvalo@codeaurora.org, zajec5@gmail.com, joe@perches.com,
	davem@davemloft.net, johannes.berg@intel.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v2 resend] b43: Fix memory leaks in b43_bus_dev_ssb_init
 and b43_bus_dev_bcma_init
References: <1452949690-16387-1-git-send-email-baijiaju1990@163.com> <20160116141321.6e0d5a87@wiggum>
In-Reply-To: <20160116141321.6e0d5a87@wiggum>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/16/2016 09:13 PM, Michael Büsch wrote:
>
> This still needs to be tested on both ssb and bcma devices. As long as
> it's untested, there is no need to resend it to the maintainers.
>

Okay, thanks for the reply :)


Jia-Ju Bai

