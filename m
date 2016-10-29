Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:53204 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbcJ2V10 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Oct 2016 17:27:26 -0400
Date: Sat, 29 Oct 2016 17:27:24 -0400 (EDT)
Message-Id: <20161029.172724.617624040118729651.davem@davemloft.net> (sfid-20161029_232731_873617_3EB881DC)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2016-10-28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20161028070614.17583-1-johannes@sipsolutions.net>
References: <20161028070614.17583-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 28 Oct 2016 09:06:13 +0200

> First update for 4.10 - nothing major, new features as usual (FILS), and
> sometimes we deprecate old stuff (WDS).
> 
> I don't have the fixes for the on-stack crypto/SG handling in this tree
> (you already have them via mac80211.git), but we did make sure that the
> fils_aead code doesn't re-introduce such an issue.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
