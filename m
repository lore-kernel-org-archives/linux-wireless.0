Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:48771 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754403Ab1LAOge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 09:36:34 -0500
Received: by mail-lpp01m010-f49.google.com with SMTP id u2so1123767lag.22
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2011 06:36:32 -0800 (PST)
Subject: Re: [PATCH 1/2] wl12xx: make WL1271_FLAG_IDLE flag per-vif
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320837504-12026-1-git-send-email-eliad@wizery.com>
References: <1320837504-12026-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 16:36:13 +0200
Message-ID: <1322750173.8996.33.camel@cumari> (sfid-20111201_153637_250712_4A548447)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-09 at 13:18 +0200, Eliad Peller wrote: 
> This flag should be set per-vif, rather than globally.
> 
> Rename the flag to indicate IN_USE (rather than IDLE), as
> in the default configuration (i.e. flag is clear) the vif
> should be idle.
> 
> Change all the bit operations (and elp conditions) appropriately.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied both and did a tiny merge with Arik's "configure probe-resp
template" patch.

-- 
Cheers,
Luca.

