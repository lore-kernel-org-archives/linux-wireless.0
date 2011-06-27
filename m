Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:34842 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756818Ab1F0Mn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 08:43:56 -0400
Received: by mail-bw0-f48.google.com with SMTP id 5so2545991bwb.21
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 05:43:54 -0700 (PDT)
Subject: Re: [PATCH 1/3] wl12xx: Check for FW quirks as soon as the FW boots
From: Luciano Coelho <coelho@ti.com>
To: Ido Yariv <ido@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1307361426-7573-1-git-send-email-ido@wizery.com>
References: <1307361426-7573-1-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 15:43:51 +0300
Message-ID: <1309178631.30221.32.camel@cumari> (sfid-20110627_144742_099270_71C24346)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-06 at 14:57 +0300, Ido Yariv wrote: 
> The FW initialization might depend on the FW revision, so check for any
> FW quirks right after booting it.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---

Applied the series, thanks!

-- 
Cheers,
Luca.

