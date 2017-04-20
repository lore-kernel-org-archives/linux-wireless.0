Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:45878 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966093AbdDTRhW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 13:37:22 -0400
Date: Thu, 20 Apr 2017 13:37:20 -0400 (EDT)
Message-Id: <20170420.133720.1579326858707108793.davem@davemloft.net> (sfid-20170420_193726_580714_123E23A0)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2017-04-18
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170418082156.4706-1-johannes@sipsolutions.net>
References: <20170418082156.4706-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 18 Apr 2017 10:21:55 +0200

> Here's a single remaining fix - it's not even super urgent for
> this cycle since it's in a "fringe" feature, but it's for an
> SKB out-of-bounds access.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
