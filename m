Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:40199 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513Ab1HLHeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 03:34:37 -0400
Received: by mail-bw0-f45.google.com with SMTP id zv3so2207409bkb.18
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 00:34:35 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: fixes for hw_pg_ver and chip id reporting
From: Luciano Coelho <coelho@ti.com>
To: Gery Kahn <geryk@ti.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>
In-Reply-To: <1310988109-13729-1-git-send-email-geryk@ti.com>
References: <1310988109-13729-1-git-send-email-geryk@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 10:34:32 +0300
Message-ID: <1313134472.2407.944.camel@cumari> (sfid-20110812_093439_950662_EABEC182)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-07-18 at 14:21 +0300, Gery Kahn wrote: 
> Fix the value of PG version for 128x at sysfs, remove write permissions
> from PG version (hw_pg_ver) in sysfs and add remove files
> (hw_pg_ver,bt_coex_state) from sysfs while freeing hardware.
> New macro names for register Fuse_data_2_1 depend on architecture.
> Propagate chip id through wiphy in PLT mode which still not work of
> a bug in ethtool.
> 
> 
> Signed-off-by: Gery Kahn <geryk@ti.com>
> ---

Applied and pushed, thanks Gery.

-- 
Cheers,
Luca.

