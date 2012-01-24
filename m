Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:37379 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401Ab2AXS4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 13:56:00 -0500
Received: by mail-lpp01m010-f44.google.com with SMTP id l5so654146lah.31
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 10:55:58 -0800 (PST)
Subject: Re: [PATCH 2/2] wl12xx: remove wl1271_tx_update_filters
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1327421923-25586-2-git-send-email-eliad@wizery.com>
References: <1327421923-25586-1-git-send-email-eliad@wizery.com>
	 <1327421923-25586-2-git-send-email-eliad@wizery.com>
Date: Tue, 24 Jan 2012 20:55:54 +0200
Message-ID: <1327431354.3625.186.camel@cumari> (sfid-20120124_195603_545215_7C58CD22)
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-24 at 18:18 +0200, Eliad Peller wrote: 
> wl1271_tx_update_filters() is used as some workaround
> to open filters while roaming on the same channel.
> 
> However, it doesn't handle roaming to a different channel,
> and it might also sleep in the tx path, which is a bug.
> 
> With the new auth/assoc redesign, roaming is much simpler,
> and this function is not needed anymore.

And is this okay without the redesign?


-- 
Cheers,
Luca.

