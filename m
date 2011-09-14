Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:45285 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753535Ab1INJVy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 05:21:54 -0400
Received: by bkbzs2 with SMTP id zs2so1711839bkb.14
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 02:21:52 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: set psd_type and sp_len on
 wl12xx_cmd_add_peer()
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1314100302-25913-1-git-send-email-eliad@wizery.com>
References: <1314100302-25913-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 12:21:44 +0300
Message-ID: <1315992104.2498.78.camel@cumari> (sfid-20110914_112157_715075_66DE7F95)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-23 at 14:51 +0300, Eliad Peller wrote: 
> Use the values given by mac80211 in order to configure
> WME correctly (AP mode)
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

I ignored this patch since "wl12xx: declare support for
WIPHY_FLAG_AP_UAPSD" is a superset of this one.

-- 
Cheers,
Luca.

