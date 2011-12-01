Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:42458 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754520Ab1LAOeu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 09:34:50 -0500
Received: by mail-lpp01m010-f53.google.com with SMTP id l5so227867lah.26
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2011 06:34:46 -0800 (PST)
Subject: Re: [PATCH] wl12xx: init CMD_TEMPL_KLV to sizeof(ieee80211_qos_hdr)
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320837165-11935-1-git-send-email-eliad@wizery.com>
References: <1320837165-11935-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 16:34:41 +0200
Message-ID: <1322750081.8996.31.camel@cumari> (sfid-20111201_153453_966453_85F532D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-09 at 13:12 +0200, Eliad Peller wrote: 
> The keep alive template should have a max size of
> sizeof(struct ieee80211_qos_hdr).
> 
> Additionally, Remove the redundant wl12xx_qos_null_data_template
> struct.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

