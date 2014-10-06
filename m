Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:38829 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaJFWZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 18:25:04 -0400
Date: Mon, 06 Oct 2014 18:25:02 -0400 (EDT)
Message-Id: <20141006.182502.2177677435591869741.davem@davemloft.net> (sfid-20141007_002517_280988_61EF700A)
To: netdev@vger.kernel.org
CC: netfilter-devel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: net-next is CLOSED...
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


We are in a sort-of state of limbo with 3.17 having been released the
other day and the actual merge window integration happening next week
when Linus returns from some travels.

Please do not submit new feature patches until I open net-next back
up which will probably be in just over 2 weeks from now.

I understand that the ->xmit_more batching stuff might still need
some fixes and/or heuristic tweaks and that's fine.

Please direct your efforts to stabilizing things over the next
week or two, thanks!
