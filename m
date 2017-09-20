Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48202 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751663AbdITMkE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:40:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/8] rsi: add p2p support parameters to mac80211
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1504085908-2163-2-git-send-email-amitkarwar@gmail.com>
References: <1504085908-2163-2-git-send-email-amitkarwar@gmail.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20170920124003.9A2E860725@smtp.codeaurora.org> (sfid-20170920_144008_134517_65AB6D60)
Date: Wed, 20 Sep 2017 12:40:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> wrote:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> 
> This patch adds p2p supported parameters to mac80211 hw and
> wiphy structures during mac80211 registration.
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

8 patches applied to wireless-drivers-next.git, thanks.

421eedff1180 rsi: add p2p support parameters to mac80211
b8bd3a439f35 rsi: add/remove interface enhancements for p2p
df771911914a rsi: add support for p2p listen
4671c209ac46 rsi: handle peer connection and disconnection in p2p mode
eac4eed3224b rsi: tx and rx path enhancements for p2p mode
efe877aa0f40 rsi: disallow power save config when AP vap running
c7245c0975f1 rsi: aggregation changes for p2p mode
af75687286bf rsi: miscellaneous changes for p2p mode

-- 
https://patchwork.kernel.org/patch/9929129/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
