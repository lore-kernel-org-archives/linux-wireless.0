Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:50196 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754674AbXIQS6d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 14:58:33 -0400
Message-ID: <46EECE52.1060206@lwfinger.net>
Date: Mon, 17 Sep 2007 13:58:26 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] b43legacy: Don't cancel the restart workqueue in wireless_core_exit
References: <46e577e8.J3sSMKsbv5F0EAQY%Larry.Finger@lwfinger.net> <20070917150358.GC9282@tuxdriver.com> <46EEB3E0.4010501@lwfinger.net> <20070917173754.GD9282@tuxdriver.com>
In-Reply-To: <20070917173754.GD9282@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Mon, Sep 17, 2007 at 12:05:36PM -0500, Larry Finger wrote:
>> John W. Linville wrote:
>>> Is this the correct patch?  The first hunk conflicts with an earlier
>>> patch ("b43legacy: Fix cancellation of work queues").
>>>
>>> John
>> Yes, this one is correct. The first one was without a commit message, and had an error.
> 
> Hmmmm, not that one.  There was another patch that (looking closer)
> you sent me and cc'ed bcm43xx-dev on or about 30 August.  I guess
> I'll drop that one and use this one instead.

No, the Aug 30 one is needed. Somehow my patch sets got confused. Please apply the August 30 patch
and drop the Sept. 10 one. I'll fix it after your tree gets updated. I don't think it will cause any
problems. As you said, the first hunk is already in the Aug. 30 patch.

Larry
