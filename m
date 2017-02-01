Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:41372 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753103AbdBARrL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 12:47:11 -0500
Date: Wed, 01 Feb 2017 12:47:09 -0500 (EST)
Message-Id: <20170201.124709.2004482664731316247.davem@davemloft.net> (sfid-20170201_184822_868024_77AB245F)
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2017-02-01
From: David Miller <davem@davemloft.net>
In-Reply-To: <87efzip7z1.fsf@kamboji.qca.qualcomm.com>
References: <87efzip7z1.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Wed, 01 Feb 2017 11:37:38 +0200

> here's a pull request to 4.11, more details in the signed tag below.
> 
> I forgot to mention in the tag that this includes one small change to
> include/linux/soc/qcom/smem_state.h which was acked by Andy Gross in
> commit 6c0b2e833f14. It was needed to fix a build problem with wcn36xx
> using the SMD interface.
> 
> Please let me know if you have any problems.

Pulled, thank you.
