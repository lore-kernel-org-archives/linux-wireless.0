Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:35535 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbcHNInX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2016 04:43:23 -0400
Date: Sat, 13 Aug 2016 14:55:12 -0700 (PDT)
Message-Id: <20160813.145512.718202374151341346.davem@davemloft.net> (sfid-20160814_104338_136844_3E401834)
To: wsa-dev@sang-engineering.com
Cc: linux-usb@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
	linux-can@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 00/16] net: don't print error when allocating urb fails
From: David Miller <davem@davemloft.net>
In-Reply-To: <1470949539-25392-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949539-25392-1-git-send-email-wsa-dev@sang-engineering.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wolfram Sang <wsa-dev@sang-engineering.com>
Date: Thu, 11 Aug 2016 23:05:19 +0200

> This per-subsystem series is part of a tree wide cleanup. usb_alloc_urb() uses
> kmalloc which already prints enough information on failure. So, let's simply
> remove those "allocation failed" messages from drivers like we did already for
> other -ENOMEM cases. gkh acked this approach when we talked about it at LCJ in
> Tokyo a few weeks ago.

Series applied to net-next, thank you.
