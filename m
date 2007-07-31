Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43984 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760559AbXGaPBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 11:01:07 -0400
Subject: Re: [PATCH] softmac: Fix deadlock of wx_set_essid with assoc work
From: David Woodhouse <dwmw2@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200707311457.33723.mb@bu3sch.de>
References: <200707311457.33723.mb@bu3sch.de>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 16:01:00 +0100
Message-Id: <1185894060.3083.115.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-07-31 at 14:57 +0200, Michael Buesch wrote:
> The essid wireless extension does deadlock against the assoc mutex,
> as we don't unlock the assoc mutex.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> --
> 
> David, please test if this fixes your deadlock. 

Seems to, although I'll have to leave it a few more hours before I'm
sure. Thanks.

-- 
dwmw2

