Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:53037 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754361Ab1LAOYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 09:24:24 -0500
Received: by lagu2 with SMTP id u2so1115152lag.22
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2011 06:24:21 -0800 (PST)
Subject: Re: [PATCH v4 1/2] wl12xx: configure probe-resp template according
 to notification
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320770815-23332-1-git-send-email-arik@wizery.com>
References: <1320770815-23332-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 16:24:17 +0200
Message-ID: <1322749457.8996.30.camel@cumari> (sfid-20111201_152427_003702_F16F2E9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 18:46 +0200, Arik Nemtsov wrote: 
> When operating in AP-mode, replace our probe-response template when a
> notification is recieved from mac80211. We preserve the "legacy" way of
> configuring a probe-response according to beacon for IBSS mode and for
> versions of hostapd that do not support this feature.
> 
> Signed-off-by: Guy Eilam <guy@wizery.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied both patches, toda!

-- 
Cheers,
Luca.

