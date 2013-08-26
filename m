Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50209 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3HZHhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 03:37:19 -0400
Message-ID: <1377502629.13247.2.camel@jlt4.sipsolutions.net> (sfid-20130826_093722_458912_F6A0B865)
Subject: Re: [PATCH] mac80211_hwsim: fix error return code in
 init_mac80211_hwsim()
From: Johannes Berg <johannes@sipsolutions.net>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org
Date: Mon, 26 Aug 2013 09:37:09 +0200
In-Reply-To: <CAPgLHd-GQuhYuKXBj6FVjtpGYWZYVwuGR-Sj3w19JSMcTm1JLg@mail.gmail.com> (sfid-20130826_093303_664307_FE807DDA)
References: <CAPgLHd-GQuhYuKXBj6FVjtpGYWZYVwuGR-Sj3w19JSMcTm1JLg@mail.gmail.com>
	 (sfid-20130826_093303_664307_FE807DDA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-08-26 at 15:32 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -ENOMEM in the netdev alloc error handling
> case instead of 0, as done elsewhere in this function.

Makes sense, applied.

johannes

