Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45870 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3DVNpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 09:45:10 -0400
Message-ID: <1366638294.8637.13.camel@jlt4.sipsolutions.net> (sfid-20130422_154542_479865_B8F996E3)
Subject: Re: [PATCH] net: rfkill: fix error return code in
 rfkill_gpio_probe()
From: Johannes Berg <johannes@sipsolutions.net>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org
Date: Mon, 22 Apr 2013 15:44:54 +0200
In-Reply-To: <CAPgLHd-cTe_+yhaYCDjsqm3Dr+O_VPEB9ansvYb-GVzJXgQfQA@mail.gmail.com> (sfid-20130418_043132_761228_B22C2377)
References: <CAPgLHd-cTe_+yhaYCDjsqm3Dr+O_VPEB9ansvYb-GVzJXgQfQA@mail.gmail.com>
	 (sfid-20130418_043132_761228_B22C2377)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-04-18 at 10:31 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in this function.

Applied (to mac80211-next, I don't want to maintain a separate tree for
the two rfkill I get a year)

johannes

