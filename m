Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56063
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbYCDVkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 16:40:13 -0500
Date: Tue, 04 Mar 2008 13:40:03 -0800 (PST)
Message-Id: <20080304.134003.223058560.davem@davemloft.net> (sfid-20080304_214017_843665_ABF16DB0)
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-03-04
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080304212953.GB3158@tuxdriver.com>
References: <20080304212953.GB3158@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 4 Mar 2008 16:29:53 -0500

> Here is today's round of fixes for the 2.6.25 tree.  These are mostly
> simple fixes, even one-liners.  The rc80211-pid patch is, of course, an
> exception...

Please don't just clone Linus's tree, pull net-2.6, and then stuff
things on top of that and ask me to pull.  I end up being forced to
end up with a merge of Linus's current tree as a result, and that's
not how this is supposed to work.

I keep net-2.6 stable for a reason.  Jeff did what you're doing right
now the other week and now you're doing it too.

There is zero point in my keeping net-2.6 clean and not rebasing it
constantly if people are going to use it like this.

You should just have a clone of net-2.6 sitting around as your
wireless fixes tree, and you simply add wireless patches and ask me to
pull whenever it is appropriate.
