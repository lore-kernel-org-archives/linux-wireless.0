Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:58124 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756241Ab1INKAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 06:00:37 -0400
Received: by mail-bw0-f47.google.com with SMTP id 11so1465550bke.20
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 03:00:36 -0700 (PDT)
Subject: Re: [PATCH v2] wl12xx: set mac80211 flags for A-MPDU aggregation
 support
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1314686041-25489-1-git-send-email-arik@wizery.com>
References: <1314686041-25489-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 13:00:33 +0300
Message-ID: <1315994433.2498.90.camel@cumari> (sfid-20110914_120046_269244_FA6001C1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-30 at 09:34 +0300, Arik Nemtsov wrote: 
> We set the mac80211 flag for A-MPDU support and also indicate that
> Tx-agg session setup is performed in HW.
> 
> This patch depends on
> "mac80211: add flag to indicate HW only Tx-agg setup support"
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied, thanks.

-- 
Cheers,
Luca.

