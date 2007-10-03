Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42458
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753318AbXJCCB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 22:01:57 -0400
Date: Tue, 02 Oct 2007 19:01:56 -0700 (PDT)
Message-Id: <20071002.190156.41633562.davem@davemloft.net> (sfid-20071003_030204_164538_1843BD0B)
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream-davem' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071003012552.GE29361@tuxdriver.com>
References: <20071003012552.GE29361@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 2 Oct 2007 21:25:52 -0400

>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-davem

This doesn't pull cleanly.

Probably you used a recently cloned Linus tree, pulled
net-2.6.24 into that (and resolved the conflicts), and
then put your patches in.

Please don't do it like that, I don't want to pull from
a tree that has linus vs. net-2.6.24 conflict handling
in it.  That's why I usually rebase frequently, to minimize
that as much as is humanly possible.

What you can do is figure out what linus's HEAD was at the last rebase
(basically 'origin' or parent of net-2.6.24), clone that then pull in
net-2.6.24, then add your patches.

That way I can always do a clean pull.

My pull from Jeff today was very clean, for example.

I'll add these wireless bits by hand as patches.

Thanks John.

