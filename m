Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49570
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172Ab1EJWIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 18:08:46 -0400
Date: Tue, 10 May 2011 15:08:14 -0700 (PDT)
Message-Id: <20110510.150814.226778453.davem@davemloft.net> (sfid-20110511_000851_348991_8B0ED817)
To: netdev@vger.kernel.org
CC: linux-wireless@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: GIT net-2.6 rolled back 8 commits...
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I made a mistake and applied to net-2.6 a patch from Eric Dumazet that
only is applicable for net-next-2.6

I really don't want to have to toss Linus that commit and a revert commit
just to fix it up.

So I rewound the net-2.6 tree by 8 commits.

So if you've pulled in the past 3 hours, please reset your pull and repull.

Thanks!
