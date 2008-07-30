Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41669
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751080AbYG3ErO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 00:47:14 -0400
Date: Tue, 29 Jul 2008 21:47:11 -0700 (PDT)
Message-Id: <20080729.214711.244268817.davem@davemloft.net> (sfid-20080730_064716_921313_AA32D368)
To: linville@tuxdriver.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: Please do not pull 2.6.27-rc1 into wireless-testing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080729174623.GA4923@tuxdriver.com>
References: <488E9FB8.3080804@lwfinger.net>
	<20080729174623.GA4923@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 29 Jul 2008 13:46:23 -0400

> On Mon, Jul 28, 2008 at 11:42:32PM -0500, Larry Finger wrote:
> 
> > As stated in the subject, please do not update wireless-testing with 
> > 2.6.27-rc1, at least for a while. In the thread that starts at  
> > http://thread.gmane.org/gmane.linux.kernel.wireless.general/18423, I 
> > found that commit 175f9c1bba9b825d2 breaks wireless, at least for b43. 
> > Until that is fixed, I think wireless-testing should remain at 2.6.26.
> 
> Have you tried the patches Johannes sent today?  Do they help the
> situation?

And also not keeping wireless-testing at the latest upstream release
is completely counter productive.

It's just going to result in more and more merge hassles for John
than is really reasonable to expect him to deal with just because
mac80211 has some bug that needs to be fixed.

And keep in mind that in this particular case, mac80211 has had this
bug forever, it's just that how the stack is organized now the bug
matters all the time instead of "sometimes."
