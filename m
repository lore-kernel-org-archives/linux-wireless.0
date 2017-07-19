Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:49042 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754373AbdGSXeo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 19:34:44 -0400
Date: Wed, 19 Jul 2017 16:34:43 -0700 (PDT)
Message-Id: <20170719.163443.111801342022545425.davem@davemloft.net> (sfid-20170720_013641_601227_9CD08F45)
To: gustavo@embeddedor.com
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: airo: remove unnecessary static in
 writerids()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170718203711.GA30044@embeddedgus>
References: <20170718203711.GA30044@embeddedgus>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Tue, 18 Jul 2017 15:37:11 -0500

> Remove unnecessary static on local function pointer _writer_.
> Such pointer is initialized before being used, on every
> execution path throughout the function. The static has no
> benefit and, removing it reduces the object file size.
> 
> This issue was detected using Coccinelle and the following semantic patch:
 ...
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied.
