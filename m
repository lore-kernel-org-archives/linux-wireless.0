Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42730 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbdHQHAL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 03:00:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: do not use random MAC for pre-association scanning
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1502368886-16539-2-git-send-email-gbhat@marvell.com>
References: <1502368886-16539-2-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20170817070010.9D5BD6037B@smtp.codeaurora.org> (sfid-20170817_090014_707734_7E48CA85)
Date: Thu, 17 Aug 2017 07:00:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> Driver should use random MAC address only if the scan is
> requested by user(provided NL80211_SCAN_FLAG_RANDOM_ADDR
> is set in scan request). It should not be used for a scan
> performed before association.
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

2 patches applied to wireless-drivers-next.git, thanks.

2af2c2c77e5a mwifiex: do not use random MAC for pre-association scanning
89001c1c8dc3 mwifiex: check for NL80211_SCAN_FLAG_RANDOM_ADDR during hidden SSID scan

-- 
https://patchwork.kernel.org/patch/9893639/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
