Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:60024 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbcIQNya (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 09:54:30 -0400
Date: Sat, 17 Sep 2016 09:54:27 -0400 (EDT)
Message-Id: <20160917.095427.639883783043129882.davem@davemloft.net> (sfid-20160917_155447_552690_39BAD8C0)
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2016-09-15
From: David Miller <davem@davemloft.net>
In-Reply-To: <87zin99p3y.fsf@kamboji.qca.qualcomm.com>
References: <87zin99p3y.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Thu, 15 Sep 2016 18:09:21 +0300

> here's the first pull request for 4.9. The ones I want to point out are
> the FIELD_PREP() and FIELD_GET() macros added to bitfield.h, which are
> reviewed by Linus, and make it possible to remove util.h from mt7601u.
> 
> Also we have new HW support to various drivers and other smaller
> features, the signed tag below contains more information. And I pulled
> my ath-current (uses older net tree as the baseline) branch to fix a
> conflict in ath10k.
> 
> Once again the diffstat from git request-pull was wrong. I fixed it by
> manually copying the diffstat from a test pull against net-next, so
> everything should be ok. But please let me know if there are any
> problems.

Pulled, thanks Kalle.
