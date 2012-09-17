Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:53439 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2IQF3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 01:29:55 -0400
Date: Mon, 17 Sep 2012 01:29:52 -0400 (EDT)
Message-Id: <20120917.012952.1057392150531807806.davem@davemloft.net> (sfid-20120917_073104_621745_479AB7D4)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-09-14
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120914174655.GC17463@tuxdriver.com>
References: <20120914174655.GC17463@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 14 Sep 2012 13:46:55 -0400

> Arend van Spriel sends a simple thinko fix to correct a constant,
> preventing the setting of an invalid power level.
> 
> Colin Ian King gives us a simple allocation failure check to avoid a
> NULL pointer dereference.
> 
> Felix Fietkau sends another ath9k tx power patch, this time disabling a
> feature that has been reported to cause rx problems.
> 
> Hante Meuleman provides a pair of endian fixes for brcmfmac.
> 
> Larry Finger offers an rtlwifi fix that avoids a system lockup related
> to loading the wrong firmware for RTL8188CE devices.
> 
> These have been in linux-next for a few days and I think they should be
> included in the final 3.6 kernel if possible.

Pulled, thanks John.
