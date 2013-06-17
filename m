Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:40309 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3FQXTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 19:19:02 -0400
Date: Mon, 17 Jun 2013 16:19:01 -0700 (PDT)
Message-Id: <20130617.161901.1229542193546651097.davem@davemloft.net> (sfid-20130618_011936_644578_FDE40658)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-06-17
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130617182719.GC2104@tuxdriver.com>
References: <20130617182719.GC2104@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 17 Jun 2013 14:27:20 -0400

> This will probably be the last batch of wireless fixes intended
> for 3.10.  Many of these are one- or two-liners, and a couple of
> others are mostly relocating existing code to avoid races or to
> limit the code to effecting specific hardware, etc.

This looks fine even though the HT info fix is a bit sizable.

Pulled, thanks a lot.
