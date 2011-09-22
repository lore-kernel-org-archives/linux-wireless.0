Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:37953 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710Ab1IVKWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 06:22:25 -0400
Received: by mail-bw0-f44.google.com with SMTP id q10so2288330bka.3
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 03:22:23 -0700 (PDT)
Subject: Re: [PATCH v2] wl12xx: fix forced passive scans
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: stable@kernel.org, yoni.divinsky@ti.com
In-Reply-To: <1316677732-2242-1-git-send-email-coelho@ti.com>
References: <1316676653-1758-1-git-send-email-coelho@ti.com>
	 <1316677732-2242-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 13:22:15 +0300
Message-ID: <1316686935.2157.572.camel@cumari> (sfid-20110922_122228_338214_6A6A34F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-22 at 10:48 +0300, Luciano Coelho wrote: 
> We were using incorrect max and min dwell times during forced passive
> scans because we were still using the active scan states to scan
> (passively) the channels that were not marked as passive.
> 
> Instead of doing passive scans in active states, we now skip active
> states and scan for all channels in passive states.
> 
> Cc: <stable@kernel.org> # 2.6.36+
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

-- 
Cheers,
Luca.

