Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:51971 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2DSTxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 15:53:04 -0400
Date: Thu, 19 Apr 2012 15:49:54 -0400 (EDT)
Message-Id: <20120419.154954.1322943404183128381.davem@davemloft.net> (sfid-20120419_215314_874722_A3C8A9A8)
To: meenakshi.venkataraman@intel.com
Cc: socketcan@hartkopp.net, wey-yi.w.guy@intel.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, david.spinadel@intel.com
Subject: Re: net-next iwlwifi breaks compile - was Re: pull request:
 wireless-next 2012-04-18
From: David Miller <davem@davemloft.net>
In-Reply-To: <4595B4D22AB93C4FABBA84AAD5AA37FD1258AA@ORSMSX103.amr.corp.intel.com>
References: <20120418.153653.2130740499995307564.davem@davemloft.net>
	<4F8F9977.9040703@hartkopp.net>
	<4595B4D22AB93C4FABBA84AAD5AA37FD1258AA@ORSMSX103.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
Date: Thu, 19 Apr 2012 19:47:58 +0000

> It was fixed internally in a subsequent patch, but that patch has
> not made it into net-next. I don't see it in the public iwlwifi
> repository either. We'll add the fix to the repository so you can
> pick it up.

That's not how this works.

You should submit a patch to fix the build directly to me, immediately,
so that I can push it directly into net-next as fast as possible.
