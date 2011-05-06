Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:35958 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783Ab1EFIjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 04:39:09 -0400
Received: by eyg24 with SMTP id 24so1219412eyg.11
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 01:39:07 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: simplify wl1271_ssid_set()
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1304233005-20249-1-git-send-email-eliad@wizery.com>
References: <1304233005-20249-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 11:39:03 +0300
Message-ID: <1304671143.12586.424.camel@cumari> (sfid-20110506_103914_237613_9A9C78DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-05-01 at 09:56 +0300, Eliad Peller wrote:
> Simplify wl1271_ssid_set by re-using cfg80211_find_ie instead of
> reimplementing it.
> 
> Additionally, add a length check to prevent a potential buffer overflow.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thank you!

-- 
Cheers,
Luca.

