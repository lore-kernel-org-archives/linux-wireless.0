Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:53342 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2CGUke (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 15:40:34 -0500
Date: Wed, 07 Mar 2012 15:39:13 -0500 (EST)
Message-Id: <20120307.153913.824845751182717386.davem@davemloft.net> (sfid-20120307_214056_240765_C6D29546)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-03-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120306201528.GC3353@tuxdriver.com>
References: <20120306201528.GC3353@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 6 Mar 2012 15:15:28 -0500

> Here are a few more squeakers hoping for 3.3...
> 
> Two of them are for carl9170: a one-line fix for a memory accounting
> leak; and a fix that corrects the handling of frames with a couple of
> status flags set by mac80211 (enabling delivery to sleeping stations).
> Also included is a one-liner for mwifiex that should have been included
> in "mwifiex: clear previous security setting during association".
> Finally, a one-line fix from Johannes Berg for an iwlwifi regression
> brings-up the rear.
> 
> Please let me know if there are problems!

Pulled, but no promises getting these into 3.3
