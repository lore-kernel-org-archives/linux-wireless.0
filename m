Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:53893 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934187Ab3IDC2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 22:28:20 -0400
Date: Tue, 03 Sep 2013 22:28:18 -0400 (EDT)
Message-Id: <20130903.222818.797621801374088373.davem@davemloft.net> (sfid-20130904_042836_276033_EF116D4D)
To: joe@perches.com
Cc: netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH net-next] drivers/net: Convert uses of
 compare_ether_addr to ether_addr_equal
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378061483.1953.3.camel@joe-AO722>
References: <1378061483.1953.3.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joe Perches <joe@perches.com>
Date: Sun, 01 Sep 2013 11:51:23 -0700

> Use the new bool function ether_addr_equal to add
> some clarity and reduce the likelihood for misuse
> of compare_ether_addr for sorting.
> 
> Done via cocci script: (and a little typing)
 ...
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
