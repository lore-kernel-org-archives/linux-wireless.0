Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:40719 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962Ab1IVFdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 01:33:36 -0400
Received: by mail-bw0-f54.google.com with SMTP id zs8so2764712bkb.41
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 22:33:34 -0700 (PDT)
Subject: Re: [PATCH 1/2] wl12xx: add dynamic_ps_timeout debugfs entry
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316347759-22030-1-git-send-email-eliad@wizery.com>
References: <1316347759-22030-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 08:33:30 +0300
Message-ID: <1316669610.2157.552.camel@cumari> (sfid-20110922_073339_410563_4CCD06DD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-09-18 at 15:09 +0300, Eliad Peller wrote: 
> Add debugfs entry to control the dynamic ps default
> timeout (value in ms).
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Dropped this series, since the mac80211 change that supports this was
not accepted.  We'll get all this dynamic PS stuff in the firmware soon
anyway.

-- 
Cheers,
Luca.

