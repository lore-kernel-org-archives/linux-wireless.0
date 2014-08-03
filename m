Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:51084 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaHCCjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2014 22:39:40 -0400
Date: Sat, 02 Aug 2014 19:39:39 -0700 (PDT)
Message-Id: <20140802.193939.2179004210212543536.davem@davemloft.net> (sfid-20140803_043958_633963_C0300415)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next 2014-08-01
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140801165738.GA26953@tuxdriver.com>
References: <20140801165738.GA26953@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 1 Aug 2014 12:57:38 -0400

> Please pull this last(?) batch of wireless change intended for the
> 3.17 stream...

When I pull this I get tons of conflicts for:

CONFLICT (content): Merge conflict in net/6lowpan/iphc.c

I don't feel comfortable fixing these up, where are they coming
from?
