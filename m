Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40930 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab1HLOUj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 10:20:39 -0400
Received: by fxh19 with SMTP id 19so2335752fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 07:20:38 -0700 (PDT)
From: Alexander Simon <alexander.simon@saxnet.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] cfg80211: Add cfg80211_get_bss_ht to also match HT configuration
Date: Fri, 12 Aug 2011 16:20:35 +0200
Message-ID: <13827813.Gu7HpFb9Pg@alex-1> (sfid-20110812_162046_604530_7D398D0C)
In-Reply-To: <1313152351.4022.6.camel@jlt3.sipsolutions.net>
References: <1888623.Vt5VZUN2cU@alex-1> <1312998657.3128.45.camel@alex-2> <1313152351.4022.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Well, I would keep the wrapper but make it an inline, not a separate
> exported function, like cfg80211_get_ibss() (which really is quite
> pointless, does anything still use it?)
> 
> johannes
Yep, i've already done so. Additionally, i also changed the wrapper 
cfg80211_get_ibss to use cfg80211_get_bss_ht.

Alex
