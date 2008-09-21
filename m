Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:41120 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbYIUVLz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 17:11:55 -0400
Date: Mon, 22 Sep 2008 01:10:40 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	reinette.chatre@intel.com, jgarzik@pobox.com,
	linville@tuxdriver.com, davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Message-ID: <20080921211038.GC2135@2ka.mipt.ru> (sfid-20080921_231202_171903_48C73797)
References: <20080921172316.GA6306@2ka.mipt.ru> <20080921110422.1d010b96@infradead.org> <20080921182835.GA11473@2ka.mipt.ru> <20080921113513.16677c4e@infradead.org> <20080921190050.GA20484@2ka.mipt.ru> <20080921205744.2d78f1fa@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080921205744.2d78f1fa@lxorguk.ukuu.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 21, 2008 at 08:57:44PM +0100, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> Try putting it into D3 counting to 10 and powering it back up. Thats
> about as close as you can get to pulling the plug when it hangs.

I will experiment with this, thanks Alan.
Unfortunately my machine builds this only
updated driver for about 10 minutes, so
results will appear not too quickly.
I will start tests tomorrow.

-- 
	Evgeniy Polyakov
