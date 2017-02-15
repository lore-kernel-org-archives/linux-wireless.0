Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45858 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751077AbdBOJNz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:13:55 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: orinoco: Use net_device_stats from struct net_device
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170210130313.27821-1-tklauser@distanz.ch>
References: <20170210130313.27821-1-tklauser@distanz.ch>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <20170215091355.096DB60C53@smtp.codeaurora.org> (sfid-20170215_101401_027104_CEE0E301)
Date: Wed, 15 Feb 2017 09:13:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tobias Klauser <tklauser@distanz.ch> wrote:
> Instead of using a private copy of struct net_device_stats in
> struct orinoco_private, use stats from struct net_device. Also remove
> the now unnecessary .ndo_get_stats function.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Patch applied to wireless-drivers-next.git, thanks.

3a6282045b22 orinoco: Use net_device_stats from struct net_device

-- 
https://patchwork.kernel.org/patch/9566717/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
