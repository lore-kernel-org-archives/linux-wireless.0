Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:37081 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2GRSd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 14:33:27 -0400
Date: Wed, 18 Jul 2012 11:33:26 -0700 (PDT)
Message-Id: <20120718.113326.707391526594137288.davem@davemloft.net> (sfid-20120718_203335_713695_3F3512EA)
To: mark.d.rustad@intel.com
Cc: eric.dumazet@gmail.com, nhorman@tuxdriver.com,
	john.r.fastabend@intel.com, h@hmsreliant.think-freely.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Subject: Re: That's pretty much it for 3.5.0
From: David Miller <davem@davemloft.net>
In-Reply-To: <FEB6B45E-1CCF-4CBC-AEB7-21D2088E175C@intel.com>
References: <205259E8-A99F-4573-96C9-7A394235B338@intel.com>
	<1342634139.2626.3281.camel@edumazet-glaptop>
	<FEB6B45E-1CCF-4CBC-AEB7-21D2088E175C@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Rustad, Mark D" <mark.d.rustad@intel.com>
Date: Wed, 18 Jul 2012 18:31:31 +0000

> If this looks like a good change, I can send the patch. Is there any
> concern about init_net going from bss to data?

There is no such concern, I like your change a lot.
