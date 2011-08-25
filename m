Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:34715 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898Ab1HYHWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 03:22:23 -0400
Received: by mail-bw0-f50.google.com with SMTP id zu5so1873746bkb.23
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 00:22:22 -0700 (PDT)
Subject: Re: [PATCH 1/2] wl12xx: enter psm only after station role was
 started
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1314106622-7481-1-git-send-email-eliad@wizery.com>
References: <1314106622-7481-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 10:22:19 +0300
Message-ID: <1314256939.2296.250.camel@cumari> (sfid-20110825_092226_692475_9EE78CB7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-23 at 16:37 +0300, Eliad Peller wrote: 
> The station didn't get into psm after recovery, because
> psm was configured before sta role was started.
> 
> Move wl1271_ps_set_mode() to be executed only after
> the role was started.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied both patches.  Toda!

-- 
Cheers,
Luca.

