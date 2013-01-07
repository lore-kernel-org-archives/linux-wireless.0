Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:38474 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3AGGF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 01:05:26 -0500
Date: Sun, 06 Jan 2013 22:05:23 -0800 (PST)
Message-Id: <20130106.220523.1783238632929635985.davem@davemloft.net> (sfid-20130107_070532_535646_6694108E)
To: coelho@ti.com
Cc: jiri@resnulli.us, netdev@vger.kernel.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [patch net-next] net: use ETHTOOL_FWVERS_LEN instead of
 ETHTOOL_BUSINFO_LEN for fw_ver strings
From: David Miller <davem@davemloft.net>
In-Reply-To: <1357538335.22318.19.camel@cumari.coelho.fi>
References: <1357474371-30887-1-git-send-email-jiri@resnulli.us>
	<1357538335.22318.19.camel@cumari.coelho.fi>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>
Date: Mon, 7 Jan 2013 07:58:55 +0200

> Hi Jiri,
> 
> On Sun, 2013-01-06 at 13:12 +0100, Jiri Pirko wrote:
>> Signed-off-by: Jiri Pirko <jiri@resnulli.us>
>> ---
> 
> Please add a commit message explaining why this change is needed.

It's obvious, not such commit message is necessary.
