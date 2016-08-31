Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:37454 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbcHaEfb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 00:35:31 -0400
Date: Tue, 30 Aug 2016 21:35:23 -0700 (PDT)
Message-Id: <20160830.213523.229275070090351509.davem@davemloft.net> (sfid-20160831_063539_685481_D7A99B9B)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2016-08-30
From: David Miller <davem@davemloft.net>
In-Reply-To: <1472537959-8249-1-git-send-email-johannes@sipsolutions.net>
References: <1472537959-8249-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 30 Aug 2016 08:19:18 +0200

> Nothing much, but we have three little fixes, see below. I've included the
> static inline so that BATMAN_ADV_BATMAN_V can be changed to be allowed w/o
> cfg80211 sooner, and it's a trivial change.
> 
> Let me know if there's any problem.

Pulled, thanks Johannes.
