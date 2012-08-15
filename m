Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:52821 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2HOWwL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2012 18:52:11 -0400
Date: Wed, 15 Aug 2012 15:52:06 -0700 (PDT)
Message-Id: <20120815.155206.172710419448408328.davem@davemloft.net> (sfid-20120816_005218_323414_707331A4)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2012-08-15
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120815185409.GA2137@tuxdriver.com>
References: <20120815185409.GA2137@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 15 Aug 2012 14:54:10 -0400

> This is a batch of updates intended for 3.7.  The ath9k, mwifiex,
> and b43 drivers get the bulk of the commits this time, with a handful
> of other driver bits thrown-in.  It is mostly just minor fixes and
> cleanups, etc.
> 
> Also included is a Bluetooth pull, with a lot of refactoring.
> Gustavo says:
> 
> 	"These are the changes I queued for 3.7. There are a many
> 	small fixes/improvements by Andre Guedes. A l2cap channel
> 	refcounting refactor by Jaganath. Bluetooth sockets now
> 	appears in /proc/net, by Masatake Yamato and Sachin Kamat
> 	changes ours drivers to use devm_kzalloc()."
> 
> Please let me know if there are problems!

Pulled, thanks John.
