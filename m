Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:50990 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756057Ab1INJ4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 05:56:34 -0400
Received: by bkas6 with SMTP id s6so2010210bka.16
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 02:56:30 -0700 (PDT)
Subject: Re: [PATCH 1/6] wl12xx: don't indicate up PS-filtered dummy packets
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1314265397-19873-1-git-send-email-arik@wizery.com>
References: <1314265397-19873-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 12:56:27 +0300
Message-ID: <1315994187.2498.89.camel@cumari> (sfid-20110914_115636_939487_E917DB77)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-08-25 at 12:43 +0300, Arik Nemtsov wrote: 
> Dummy packets are currently only sent on the system_hlid link. The
> system_hlid link should never be filtered for PS (as it is not
> a STA link). Even so, for correctness, don't indicate dummy packets up.
> The skb does not belong to mac80211 and as such does not contain a
> correct skb->cb.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied this patchset, thanks!

-- 
Cheers,
Luca.

