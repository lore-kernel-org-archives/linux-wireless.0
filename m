Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:36249 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753317Ab2BBHpB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 02:45:01 -0500
Received: by lagk11 with SMTP id k11so1172054lag.29
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2012 23:44:59 -0800 (PST)
Subject: Re: [PATCH v2 4/7] wl12xx: add forced_ps debugfs file
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1328021048-8944-5-git-send-email-eliad@wizery.com>
References: <1328021048-8944-1-git-send-email-eliad@wizery.com>
	 <1328021048-8944-5-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Feb 2012 09:44:56 +0200
Message-ID: <1328168696.3626.247.camel@cumari> (sfid-20120202_084506_172092_F5F3B4EF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-31 at 16:44 +0200, Eliad Peller wrote: 
> From: Eyal Shapira <eyal@wizery.com>
> 
> Added control over forced_ps option through debugfs.
> This can be either 1 or 0.
> 
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Ah, now I see it. :)

This should be squashed with the previous one.  And I think it should
probably be the same file (ie. "dynamic_ps_timeout") that should include
this feature.  Maybe passing -1 to enable forced PS?

-- 
Cheers,
Luca.

