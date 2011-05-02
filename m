Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53956
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805Ab1EBTYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 15:24:52 -0400
Date: Mon, 02 May 2011 12:24:19 -0700 (PDT)
Message-Id: <20110502.122419.193698649.davem@davemloft.net> (sfid-20110502_212512_954791_16E0DFDB)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-05-02
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110502182013.GA6768@tuxdriver.com>
References: <20110502182013.GA6768@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 2 May 2011 14:20:13 -0400

> Dave,
> 
> Here are a few more intended for 2.6.39.  There is a one-liner for b43
> which adds a missing MODULE_FIRMWARE declaration (so maybe someone's
> initrd will get generated correctly), an iwlegacy fix from Wey-Yi that
> corrects an LED flashing change that people are complaining about,
> an iwl4965 WARNING fix from Stanislaw, and a matching pair of iwlagn
> and iwl4965 regression fixes also from Stanislaw that correct problems
> with using the wrong station ID for block ACK sessions.
> 
> Please let me know if there are problems!
> 
> John
> 
> P.S.  I know the LED flashing fix is questionable, but it is an
> annoyance and it should not effect any other hardware.

Looks fine, pulled, thanks John.
