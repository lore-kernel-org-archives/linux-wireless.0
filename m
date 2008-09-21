Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:35402 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbYIUWIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 18:08:10 -0400
Date: Mon, 22 Sep 2008 02:07:08 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: Arjan van de Ven <arjan@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	reinette.chatre@intel.com, jgarzik@pobox.com,
	linville@tuxdriver.com, davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Message-ID: <20080921220708.GA31413@2ka.mipt.ru>
References: <20080921182835.GA11473@2ka.mipt.ru> <20080921140203.4698a2ee@infradead.org> <20080921210554.GA2135@2ka.mipt.ru> <200809220043.07345.denys@visp.net.lb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809220043.07345.denys@visp.net.lb>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 22, 2008 at 12:43:07AM +0300, Denys Fedoryshchenko (denys@visp.net.lb) wrote:
> You are not right. I had totaly disfunctional Intel driver on two laptops and 
> reported about issue to Intel. Yes it took time, they took all debugs and 
> went coma mode (i was thinking that), but suddently i got mail from them, and 
> next kernel/firmware release worked for me flawlessly. So they did perfect 
> job.

I'm talking about current situation.

> Don't be negative and prepare yourself for giving long debug outputs. Patience 
> and only patience.

Just to be clear, did it take 4 years? :)

Anyway, I already made conclusions, as probably others: I will
experiment with different 'workarounds' for this bug, maybe I will
succeed, maybe Intel will decided to fix it, maybe LHC will crash the
world. Verbose warning about the bug was frowned upon, so its up to uses
to make a progress here...

-- 
	Evgeniy Polyakov
