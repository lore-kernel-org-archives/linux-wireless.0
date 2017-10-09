Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:51860 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754534AbdJIQxW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2017 12:53:22 -0400
Date: Mon, 09 Oct 2017 09:53:22 -0700 (PDT)
Message-Id: <20171009.095322.1925806832264365123.davem@davemloft.net> (sfid-20171009_185345_603679_04EBC774)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2017-10-09
From: David Miller <davem@davemloft.net>
In-Reply-To: <20171009074013.1979-1-johannes@sipsolutions.net>
References: <20171009074013.1979-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon,  9 Oct 2017 09:40:12 +0200

> The QCA folks found another netlink problem - we were missing validation
> of some attributes. It's not super problematic since one can only read a
> few bytes beyond the message (and that memory must exist), but here's the
> fix for it.
> 
> I thought perhaps we can make nla_parse_nested() require a policy, but
> given the two-stage validation/parsing in regular netlink that won't work.
> 
> Please pull and let me know if there's any problem.

Yeah, nested parsing is messy validation-wise.

Pulled, thanks Johannes.
