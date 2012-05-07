Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:48765 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab2EGP6B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 11:58:01 -0400
Date: Mon, 07 May 2012 11:56:55 -0400 (EDT)
Message-Id: <20120507.115655.1099092499206396209.davem@davemloft.net> (sfid-20120507_175807_373033_9599931B)
To: gustavo@padovan.org
Cc: linville@tuxdriver.com, linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix coding style
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120507152113.GA5192@joana>
References: <1336157988-4602-1-git-send-email-gustavo@padovan.org>
	<20120506.123656.1335354317428258137.davem@davemloft.net>
	<20120507152113.GA5192@joana>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gustavo Padovan <gustavo@padovan.org>
Date: Mon, 7 May 2012 12:24:05 -0300

> * David Miller <davem@davemloft.net> [2012-05-06 12:36:56 -0400]:
> 
>> From: Gustavo Padovan <gustavo@padovan.org>
>> Date: Fri,  4 May 2012 15:59:48 -0300
>> 
>> > Fix offending styles all over the tree. This is in conformance David
>> > Miller's style rules.
>> 
>> They aren't just my style rules.
>> 
>> And, if your plan is to patch things up afterwards so you don't
>> have to change existing commits in your tree, think again.
>> 
>> I absolutely will not pull a tree from John that has commits in
>> it that add the bad indentation.
>> 
>> You have to respin your tree with fixed commits.
> 
> John, can you please unpull the bluetooth tree from wireless-next? I'll be
> fixing he affected commits and the send you a new pull request. Thanks.

And John also make sure these guys don't add unreasonable commit log
messages saying things like that this multi-line condition style thing
is my specific coding style.  It's not.

