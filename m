Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:60562 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751423AbdJKRPe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 13:15:34 -0400
Date: Wed, 11 Oct 2017 10:15:31 -0700 (PDT)
Message-Id: <20171011.101531.1673001523626350498.davem@davemloft.net> (sfid-20171011_191615_367485_21A78B87)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2017-10-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <20171011123613.28890-1-johannes@sipsolutions.net>
References: <20171011123613.28890-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 11 Oct 2017 14:36:12 +0200

> Here's a -next pull request. The only bigger thing here is the
> addition of the regulatory database as firmware, which will
> allow us to - over time - get rid of CRDA, as well as having
> the option of adding more fields to the database where needed,
> this would've been extremely complex with CRDA because it had
> not been built with extensibility in mind.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks!
