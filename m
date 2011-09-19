Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:33193 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889Ab1ISFHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 01:07:42 -0400
Received: by mail-fx0-f48.google.com with SMTP id 23so4988802fxd.21
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 22:07:40 -0700 (PDT)
Subject: Re: [PATCH 1/2] wl12xx: add dynamic_ps_timeout debugfs entry
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316347759-22030-1-git-send-email-eliad@wizery.com>
References: <1316347759-22030-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 08:07:37 +0300
Message-ID: <1316408857.2157.7.camel@cumari> (sfid-20110919_070749_530717_0FAE6F30)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eliad,

On Sun, 2011-09-18 at 15:09 +0300, Eliad Peller wrote: 
> Add debugfs entry to control the dynamic ps default
> timeout (value in ms).
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Please mention the dependency to the mac80211 changes in this cases.
This was easy to figure out, but explicitly mentioning it makes my life
a bit easier. ;)

-- 
Cheers,
Luca.

