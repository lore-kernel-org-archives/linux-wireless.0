Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54932 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbaCMS7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2014 14:59:47 -0400
Date: Thu, 13 Mar 2014 14:59:42 -0400 (EDT)
Message-Id: <20140313.145942.1469921760118318430.davem@davemloft.net> (sfid-20140313_195955_901385_5195B4C0)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2014-03-13
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140313184353.GD30579@tuxdriver.com>
References: <20140311.234712.259725858772258155.davem@davemloft.net>
	<20140311.235115.534789621550791915.davem@davemloft.net>
	<20140313184353.GD30579@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 13 Mar 2014 14:43:54 -0400

> I have amended this commit request to correct the build problems in
> staging, including a warning added to one of the staging drivers by
> the wireless-next tree.  I also included a fix from Larry Finger to
> address an issue found in rtl8723be by Dan Carpenter and smatch.
> 
> Please let me know if there are problems!

Ok, pulled, let's see how this build goes :-)
