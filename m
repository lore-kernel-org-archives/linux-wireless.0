Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:44518 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbdJ0EvK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 00:51:10 -0400
Date: Fri, 27 Oct 2017 13:51:07 +0900 (KST)
Message-Id: <20171027.135107.1328125263477288028.davem@davemloft.net> (sfid-20171027_065114_472163_88953017)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2017-10-25
From: David Miller <davem@davemloft.net>
In-Reply-To: <20171025140343.21477-1-johannes@sipsolutions.net>
References: <20171025140343.21477-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 25 Oct 2017 16:03:42 +0200

> Here are a few more fixes for net, we started comprehensive testing
> for the security issues and found that the problem wasn't addressed
> in TKIP, so that's included, along with a handful other fixes.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
