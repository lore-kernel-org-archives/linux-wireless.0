Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:38863 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754822Ab1LAOiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 09:38:06 -0500
Received: by mail-lpp01m010-f53.google.com with SMTP id l5so230232lah.26
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2011 06:38:04 -0800 (PST)
Subject: Re: [PATCH 1/2] wl12xx: leave IV calculation to HW for CCMP
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1319350915-31222-1-git-send-email-arik@wizery.com>
References: <1319350915-31222-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 16:38:00 +0200
Message-ID: <1322750280.8996.36.camel@cumari> (sfid-20111201_153826_369600_E5DD5FC1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-10-23 at 08:21 +0200, Arik Nemtsov wrote: 
> Use an appropriate mac80211 flags in CCMP keys to indicate we are
> calculating the CCMP IV in HW, but require room for the IV to be reserved
> in the skb. The space is reserved by mac80211.
> 
> depends on "mac80211: support adding IV-room in the skb for CCMP keys".
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied.


-- 
Cheers,
Luca.

