Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41641 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2IDQGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 12:06:43 -0400
Message-ID: <1346774827.3737.34.camel@jlt4.sipsolutions.net> (sfid-20120904_180648_529364_E2459A57)
Subject: Re: [PATCH] nl80211: [PATCH] nl80211: fix possible memory leak
 nl80211_connect()
From: Johannes Berg <johannes@sipsolutions.net>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linville@tuxdriver.com, davem@davemloft.net,
	yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Date: Tue, 04 Sep 2012 18:07:07 +0200
In-Reply-To: <CAPgLHd_ykxWnV82swesivdEkyqP+a+hBgTTT8SXwn9RYWR1HFA@mail.gmail.com> (sfid-20120902_154106_606560_49157A83)
References: <CAPgLHd_ykxWnV82swesivdEkyqP+a+hBgTTT8SXwn9RYWR1HFA@mail.gmail.com>
	 (sfid-20120902_154106_606560_49157A83)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-02 at 21:41 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> connkeys is malloced in nl80211_parse_connkeys() and should
> be freed in the error handling case, otherwise it will cause
> memory leak.
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)

Applied, thanks. I fixed the subject for you :)

johannes

