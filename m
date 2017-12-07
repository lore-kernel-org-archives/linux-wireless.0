Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39206 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932181AbdLGNRs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 08:17:48 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] mwl8k: Expand non-DFS 5G channels
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171116075955.qbbqhwqn4lys3xco@ximibaba.lan>
References: <20171116075955.qbbqhwqn4lys3xco@ximibaba.lan>
To: Weixiao Zhang <waveletboy@gmail.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Weixiao Zhang <waveletboy@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20171207131748.6153D609D1@smtp.codeaurora.org> (sfid-20171207_141850_045068_A0640EBB)
Date: Thu,  7 Dec 2017 13:17:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Weixiao Zhang <waveletboy@gmail.com> wrote:

> Add non-DFS 5G upper channels (149-165) besides existed 4 lower channels
> (36, 40, 44, 48).
> 
> Signed-off-by: Weixiao Zhang <waveletboy@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

4628257bf300 mwl8k: Expand non-DFS 5G channels

-- 
https://patchwork.kernel.org/patch/10060831/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
