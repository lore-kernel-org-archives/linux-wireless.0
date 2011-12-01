Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:58542 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754780Ab1LAOhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 09:37:09 -0500
Received: by mail-lpp01m010-f53.google.com with SMTP id l5so218020lah.40
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2011 06:37:05 -0800 (PST)
Subject: Re: [PATCH] wl12xx: avoid bail out when probe-resp is not set by
 mac80211
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1321984379-1565-1-git-send-email-arik@wizery.com>
References: <1321984379-1565-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 16:37:02 +0200
Message-ID: <1322750222.8996.34.camel@cumari> (sfid-20111201_153714_006946_16810B6E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-22 at 19:52 +0200, Arik Nemtsov wrote: 
> During reconfig we can get the BSS_CHANGED_AP_PROBE_RESP indication
> even if a probe-resp has not been set in the first place. Therefore
> ignore the error when not getting a probe-resp from mac80211. Resort to
> the legacy probe-resp in this case.
> 
> Also take this opportunity to add a vif argument to the set_probe_resp
> function.
> 
> Reported-by: Eliad Peller <eliad@wizery.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied.  Thanks!

-- 
Cheers,
Luca.

