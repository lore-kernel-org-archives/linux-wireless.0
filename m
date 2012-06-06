Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:39774 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754698Ab2FFIRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:17:51 -0400
Received: by lbbgk8 with SMTP id gk8so5149510lbb.26
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 01:17:25 -0700 (PDT)
Message-ID: <1338970636.7078.0.camel@cumari.coelho.fi> (sfid-20120606_101800_861907_BE17EB5E)
Subject: Re: [PATCH 1/4] wlcore: use psd_type indexing according to spec
From: Luciano Coelho <coelho@ti.com>
To: Yoni Divinsky <yoni.divinsky@ti.com>
Cc: linux-wireless@vger.kernel.org, arik@wizery.com
Date: Wed, 06 Jun 2012 11:17:16 +0300
In-Reply-To: <1336474934-22069-1-git-send-email-yoni.divinsky@ti.com>
References: <1336474934-22069-1-git-send-email-yoni.divinsky@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-08 at 14:02 +0300, Yoni Divinsky wrote:
> In ieee80211.h the uapsd bit mask is defined such that
> VO=BIT(0), VI=BIT(1), BK=BIT(2), BE=BIT(3).
> The firmware uses the indexing as defined in the ieee80211
> spec, meaning that VO=3, VI=2, BK=1, BE=0.
> 
> In AP mode when adding peer wlcore needs to convert
> the indexing accordingly.
> 
> Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
> ---

Applied and pushed this series, except for 3/4, which was sent as v2 in
a separate patchset.

-- 
Luca.

