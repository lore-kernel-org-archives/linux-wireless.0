Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47762 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750896AbeAIMMs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 07:12:48 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,01/10] qtnfmac: check that MAC exists in regulatory notifier
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171219112856.22463-2-sergey.matyukevich.os@quantenna.com>
References: <20171219112856.22463-2-sergey.matyukevich.os@quantenna.com>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Message-Id: <20180109121247.C95116081B@smtp.codeaurora.org> (sfid-20180109_131252_160022_8A8BB9AD)
Date: Tue,  9 Jan 2018 12:12:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> 
> It is possible that regulatory notifier is called before MAC data
> was allocated. We need to verify that MAC data exists before trying
> to send a regulatory change event.
> 
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

10 patches applied to wireless-drivers-next.git, thanks.

4fd045cdb239 qtnfmac: check that MAC exists in regulatory notifier
5bf374ab91ad qtnfmac: pass complete channel data between driver and firmware
b05ee456fd21 qtnfmac: add support for radar detection and CAC
e6ef8cd05145 qtnfmac: change default interface mode from AP to STA
e6e594aff26a qtnfmac: check for passed channel being NULL in MGMT_TX command
fbad963a28e4 qtnfmac: fix rssi data passed to wireless core
9cbd599966d8 qtnfmac: fill wiphy's extended capabilities
4d2a7a1cfa68 qtnfmac: modify GET_STA_STATS cmd format for back/forward compatibility
7a4d3a3bc84e qtnfmac: keeping track of "generation" for STA info
f1398fd2dd8c qtnfmac: support MAC address based access control

-- 
https://patchwork.kernel.org/patch/10123079/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
