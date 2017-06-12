Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:33000 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752340AbdFLOP7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 10:15:59 -0400
Date: Mon, 12 Jun 2017 10:15:51 -0400 (EDT)
Message-Id: <20170612.101551.1401883231011186549.davem@davemloft.net> (sfid-20170612_161646_798908_DEA5012E)
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2017-06-12
From: David Miller <davem@davemloft.net>
In-Reply-To: <87poe98h90.fsf@kamboji.qca.qualcomm.com>
References: <87poe98h90.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Mon, 12 Jun 2017 16:31:23 +0300

> here's a pull request to net-next, more info in the tag below. But do
> note that Stephen reported qtnfmac will fail to build with the net tree
> due to the changes in netdev destructor:
> 
> https://lkml.kernel.org/r/20170608122759.7ffda0c3@canb.auug.org.au
> 
> So once you pull these changes AND your net tree to net-next you need to
> apply Stephen's patch above. As of this writing there is no build
> breakage (yet).
> 
> Please let me know if there are any problems.

Yep, I'll have to deal with that in the merge commit next time I pull
net into net-next, thanks for reminding me.

Pulled, thanks.
