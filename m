Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0050.outbound.protection.outlook.com ([104.47.32.50]:38252
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752267AbeAINKH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 08:10:07 -0500
Date: Tue, 9 Jan 2018 16:09:53 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [v2,01/10] qtnfmac: check that MAC exists in regulatory notifier
Message-ID: <20180109130951.2vowioqa3vcwnqv2@bars> (sfid-20180109_141023_336347_8BF1A432)
References: <20171219112856.22463-2-sergey.matyukevich.os@quantenna.com>
 <20180109121247.C95116081B@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180109121247.C95116081B@smtp.codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Kalle,

> > It is possible that regulatory notifier is called before MAC data
> > was allocated. We need to verify that MAC data exists before trying
> > to send a regulatory change event.
> >
> > Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> 
> 10 patches applied to wireless-drivers-next.git, thanks.
> 
> 4fd045cdb239 qtnfmac: check that MAC exists in regulatory notifier
> 5bf374ab91ad qtnfmac: pass complete channel data between driver and firmware
> b05ee456fd21 qtnfmac: add support for radar detection and CAC
> e6ef8cd05145 qtnfmac: change default interface mode from AP to STA
> e6e594aff26a qtnfmac: check for passed channel being NULL in MGMT_TX command
> fbad963a28e4 qtnfmac: fix rssi data passed to wireless core
> 9cbd599966d8 qtnfmac: fill wiphy's extended capabilities
> 4d2a7a1cfa68 qtnfmac: modify GET_STA_STATS cmd format for back/forward compatibility
> 7a4d3a3bc84e qtnfmac: keeping track of "generation" for STA info
> f1398fd2dd8c qtnfmac: support MAC address based access control

Just to understand the timelines... Could you please clarify if these patches
are still going to make it into 4.16 merge window ?

Regards,
Sergey
