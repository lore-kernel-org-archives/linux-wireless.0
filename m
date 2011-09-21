Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:44915 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752592Ab1IUITM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 04:19:12 -0400
Received: by gye5 with SMTP id 5so1220374gye.4
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 01:19:10 -0700 (PDT)
Message-ID: <4E799DF9.9060807@ti.com> (sfid-20110921_101928_181352_28B834C3)
Date: Wed, 21 Sep 2011 11:19:05 +0300
From: Victor Goldenshtein <victorg@ti.com>
Reply-To: victorg@ti.com
MIME-Version: 1.0
To: johannes@sipsolutions.net
CC: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result event.
References: <1315224151-16552-1-git-send-email-VictorG@ti.com> <1315224151-16552-4-git-send-email-VictorG@ti.com>
In-Reply-To: <1315224151-16552-4-git-send-email-VictorG@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2011 15:02, Victor Goldenshtein wrote:
> Adding intermediate scan result event by exposing new
> NL80211_CMD_IM_SCAN_RESULT event, which will contain
> NL80211_BSS_BSSID to specify the BSSID of received scan result and
> NL80211_BSS_SIGNAL_MBM to indicate signal strength.
>

Hi,

Just talked with Luciano, and we though to make this event more generic 
and to pass the whole BSS info instead of just BSSID and rssi, what do 
you think?


Thanks,
Victor.
