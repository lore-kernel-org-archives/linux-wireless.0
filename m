Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55245
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab0JXXyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Oct 2010 19:54:51 -0400
Date: Sun, 24 Oct 2010 16:55:14 -0700 (PDT)
Message-Id: <20101024.165514.52187613.davem@davemloft.net>
To: netdev@vger.kernel.org
CC: linux-wireless@vger.kernel.org, netfilter-devel@vger.kernel.org,
	kaber@trash.net, linville@tuxdriver.com, sfr@canb.auug.org.au
Subject: FYI: net-2.6 and net-next-2.6 rebased
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I've rebased both the net-2.6 and net-next-2.6 trees.

All of the commits that were in those trees are in Linus's
tree now, so in fact this event ought to be %100 transparent
for people pulling from my trees.

No commits will appear in net-next-2.6 until the merge
window is closed, it's just a dummy clone of Linus's current
tree so that Stephen Rothwell's -next pulls "just work."

Thanks.
