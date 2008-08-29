Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42928
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751281AbYH2VDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 17:03:08 -0400
Date: Fri, 29 Aug 2008 14:03:03 -0700 (PDT)
Message-Id: <20080829.140303.71048853.davem@davemloft.net> (sfid-20080829_230316_993984_7F2F5E4C)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2008-08-29
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080829205414.GB11718@tuxdriver.com>
References: <20080829205414.GB11718@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 29 Aug 2008 16:54:14 -0400

> Here is this week's supply of stuff for -next -- mostly cleanups and
> other driver updates.  Please let me know if there are problems!
 ...
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6.git master

I'm pulling this, thanks John.

I hope to get a chance tonight to deal with that net-2.6 vs. net-next-2.6
wireless conflict by doing a merge.  It had to do with that IBSS message
your ifdef'd out in net-2.6
