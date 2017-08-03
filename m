Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49568 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752263AbdHCKAH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 06:00:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,01/12] qtnfmac: updates for regulatory support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170727230654.30850-2-sergey.matyukevich.os@quantenna.com>
References: <20170727230654.30850-2-sergey.matyukevich.os@quantenna.com>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Message-Id: <20170803100007.7EE0E607C6@smtp.codeaurora.org> (sfid-20170803_120021_648013_634E09B0)
Date: Thu,  3 Aug 2017 10:00:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> On startup driver obtains regulatory rules from firmware and
> enables them during wiphy registration. Later on regulatory
> domain change can be requested by host. In this case firmware
> is notified about the upcoming changes. If the change is valid,
> then firmware updates hardware channel configuration and host
> driver receives updated channel info for each band.
> 
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> Signed-off-by: Avinash Patil <avinashp@quantenna.com>

12 patches applied to wireless-drivers-next.git, thanks.

4dd07d2b58d5 qtnfmac: updates for regulatory support
ea19479f6849 qtnfmac: regulatory configuration for self-managed setup
9ef7509505c8 qtnfmac: add missing bus lock
7c04b43984a5 qtnfmac: implement cfg80211 dump_survey handler
278944482b29 qtnfmac: implement reporting current channel
fd19ecebe03e qtnfmac: fix station leave reason endianness
34f1145b2c5e qtnfmac: move current channel info from vif to mac
97883695d596 qtnfmac: implement cfg80211 channel_switch handler
c7ead2abd26a qtnfmac: implement scan timeout
41c8fa0c6274 qtnfmac: fix handling of iftype mask reported by firmware
03ddf59d786d qtnfmac: remove function qtnf_cmd_skb_put_action
805b28c05c8e qtnfmac: prepare for AP_VLAN interface type support

-- 
https://patchwork.kernel.org/patch/9867659/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
