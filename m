Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:52683 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752240Ab1IWLoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 07:44:39 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so3414280bkb.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2011 04:44:37 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Use dev_hlid for auth and assoc req
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316091947-8953-1-git-send-email-eliad@wizery.com>
References: <1316091947-8953-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 14:44:34 +0300
Message-ID: <1316778274.2157.733.camel@cumari> (sfid-20110923_134442_182502_CA25A994)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 16:05 +0300, Eliad Peller wrote: 
> On roaming, the auth and assoc req are sent with the sta
> hlid. This is wrong, as the sta hlid is configured according
> to the old ap. Use the dev_hlid instead.
> 
> Move the wl1271_tx_update_filters() call into wl1271_tx_get_hlid(),
> so wl->dev_hlid will be valid.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

