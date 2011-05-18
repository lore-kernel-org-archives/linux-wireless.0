Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:49941 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755951Ab1ERIey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 04:34:54 -0400
Received: by wwi18 with SMTP id 18so994416wwi.5
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 01:34:52 -0700 (PDT)
Subject: Re: [PATCH] nl80211: remove unnecessary cfg80211_ssid pointer in
 nl80211_trigger_scan
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
In-Reply-To: <1305706865-17672-1-git-send-email-coelho@ti.com>
References: <1305706865-17672-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 11:34:48 +0300
Message-ID: <1305707688.12586.1532.camel@cumari> (sfid-20110518_103457_496449_C681713F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-18 at 11:21 +0300, Luciano Coelho wrote:
> The struct cfg80211_ssid *ssid variable was only used to figure out
> the size of the struct when allocating memory.  This is not necessary,
> because sizeof(*request->ssids) can be used instead.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Please ignore this patch, I'll send another one with a couple more
similar clean-ups instead.

-- 
Cheers,
Luca.

