Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42570 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab3CTNKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 09:10:23 -0400
Message-ID: <1363785008.8224.0.camel@jlt4.sipsolutions.net> (sfid-20130320_141046_974645_2C1E5911)
Subject: Re: [PATCH -next] cfg80211: fix error return code in cfg80211_init()
From: Johannes Berg <johannes@sipsolutions.net>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org
Date: Wed, 20 Mar 2013 14:10:08 +0100
In-Reply-To: <CAPgLHd_Aepo=sLocJqVawRO_G7ifFLhQaYUxxF9HHXB0gcGbBA@mail.gmail.com> (sfid-20130320_132315_179320_934FAD92)
References: <CAPgLHd_Aepo=sLocJqVawRO_G7ifFLhQaYUxxF9HHXB0gcGbBA@mail.gmail.com>
	 (sfid-20130320_132315_179320_934FAD92)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-20 at 20:22 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in this function.

Applied, thanks.

johannes

