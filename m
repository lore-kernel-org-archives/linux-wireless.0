Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35981 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab2EGPYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 11:24:22 -0400
Date: Mon, 7 May 2012 12:24:05 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix coding style
Message-ID: <20120507152113.GA5192@joana> (sfid-20120507_172426_881294_1858F14D)
References: <1336157988-4602-1-git-send-email-gustavo@padovan.org>
 <20120506.123656.1335354317428258137.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120506.123656.1335354317428258137.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* David Miller <davem@davemloft.net> [2012-05-06 12:36:56 -0400]:

> From: Gustavo Padovan <gustavo@padovan.org>
> Date: Fri,  4 May 2012 15:59:48 -0300
> 
> > Fix offending styles all over the tree. This is in conformance David
> > Miller's style rules.
> 
> They aren't just my style rules.
> 
> And, if your plan is to patch things up afterwards so you don't
> have to change existing commits in your tree, think again.
> 
> I absolutely will not pull a tree from John that has commits in
> it that add the bad indentation.
> 
> You have to respin your tree with fixed commits.

John, can you please unpull the bluetooth tree from wireless-next? I'll be
fixing he affected commits and the send you a new pull request. Thanks.

	Gustavo
