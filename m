Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:49849 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965115Ab1GMJEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 05:04:35 -0400
Received: by mail-bw0-f51.google.com with SMTP id 18so6768697bwa.24
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2011 02:04:34 -0700 (PDT)
Subject: Re: [PATCH 08/11] wl12xx: remove wext dependencies
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110713084034.328005382@sipsolutions.net>
References: <20110713083908.713123063@sipsolutions.net>
	 <20110713084034.328005382@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 12:04:31 +0300
Message-ID: <1310547871.1514.813.camel@cumari> (sfid-20110713_110440_023862_562100EF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 10:39 +0200, Johannes Berg wrote:
> plain text document attachment (011-wl12xx-fix-wext.patch)
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This driver uses IW_ESSID_MAX_SIZE when it should
> be using IEEE80211_MAX_SSID_LEN instead.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

Acked-by: Luciano Coelho <coelho@ti.com>

-- 
Cheers,
Luca.

