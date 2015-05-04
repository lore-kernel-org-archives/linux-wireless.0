Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45307 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbbEDK4u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 06:56:50 -0400
Message-ID: <1430737006.2013.19.camel@sipsolutions.net> (sfid-20150504_125653_819974_91CED297)
Subject: Re: [PATCH] mac80211: fix 90 kernel-doc warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Date: Mon, 04 May 2015 12:56:46 +0200
In-Reply-To: <553DA95E.7010406@infradead.org> (sfid-20150427_051611_280767_5C76737F)
References: <553DA95E.7010406@infradead.org>
	 (sfid-20150427_051611_280767_5C76737F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-04-26 at 20:13 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Eliminate 90 of these warnings:
> 
> Warning(..//include/net/mac80211.h:1682): No description found for parameter 'drv_priv[0]'

Applied, thanks.

johannes

