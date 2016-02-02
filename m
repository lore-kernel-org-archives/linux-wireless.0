Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35271 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbcBBQZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 11:25:31 -0500
Date: Tue, 2 Feb 2016 21:55:19 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Paul Mcquade <paulmcquad@gmail.com>
Cc: kvalo@codeaurora.org, zajec5@gmail.com, davem@davemloft.net,
	joe@perches.com, johannes.berg@intel.com, sd@queasysnail.net,
	m@bues.ch, mike.looijmans@topic.nl, khoroshilov@ispras.ru,
	cengelma@gmx.at, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [v2,2/3] net: wireless: b43: Coding Style
Message-ID: <20160202162519.GC8235@sudip-laptop> (sfid-20160202_172552_058824_89DF55A1)
References: <1445270543-2209-3-git-send-email-paulmcquad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445270543-2209-3-git-send-email-paulmcquad@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 19, 2015 at 05:02:22PM +0100, Paul Mcquade wrote:
> Fixed Pointer Coding Style
> 
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> Acked-by: Michael Buesch <m@bues.ch>

Please fix the From: name like i just replied in another of your patch
and this patch will not apply anymore as the driver has moved to a new
location drivers/net/wireless/broadcom/b43/

can you please rebase it against the current tree and send.

regards
sudip
