Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39349 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbcCSJJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2016 05:09:57 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-kernel@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: btcoexist: Convert BTC_PRINTK to btc_<foo>_dbg
References: <4672f9efb37df545ae504d51ca626bf34237fa63.1458258337.git.joe@perches.com>
	<56EB6DD9.3000300@lwfinger.net> <1458272258.9556.46.camel@perches.com>
Date: Sat, 19 Mar 2016 11:09:50 +0200
In-Reply-To: <1458272258.9556.46.camel@perches.com> (Joe Perches's message of
	"Thu, 17 Mar 2016 20:37:38 -0700")
Message-ID: <87pouqhm01.fsf@kamboji.qca.qualcomm.com> (sfid-20160319_101007_892777_99EFB596)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> On Thu, 2016-03-17 at 21:54 -0500, Larry Finger wrote:
>> On 03/17/2016 07:00 PM, Joe Perches wrote:
>> > Use a more common logging style.
>
> [ 300K+ quote without comment ]

Yeah, please try to avoid that. For example this makes the patchwork
page for the patch really hard to read:

https://patchwork.kernel.org/patch/8615131/

-- 
Kalle Valo
