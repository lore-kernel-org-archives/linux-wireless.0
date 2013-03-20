Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:60783 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab3CTTVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 15:21:41 -0400
Date: Wed, 20 Mar 2013 15:21:38 -0400 (EDT)
Message-Id: <20130320.152138.409022277193754258.davem@davemloft.net> (sfid-20130320_202213_698338_A15C02A9)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-03-20
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130320191107.GA9978@tuxdriver.com>
References: <20130320191107.GA9978@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 20 Mar 2013 15:11:08 -0400

> I present to you another batch of fixes intended for the 3.9 stream...
> 
> On the bluetooth bits, Gustavo says:
> 
> "I put together 3 fixes intended for 3.9, there are support for two
> new devices and a NULL dereference fix in the SCO code."
> 
> Amitkumar Karwar fixes a command queueing race in mwifiex.
> 
> Bing Zhao provides a pair of mwifiex related to cleaning-up before
> a shutdown.
> 
> Felix Fietkau provides an ath9k fix for a regression caused by an
> earlier calibration fix, and another ath9k fix to avoid race conditions
> that unnecessarily lead to chip resets.
> 
> Jussi Kivilinna prevents and skbuff leak in rtlwifi.
> 
> Stanislaw Gruszka corrects a length paramater for a DMA buffer mapping
> operation in iwlegacy.

Pulled, thanks John!
